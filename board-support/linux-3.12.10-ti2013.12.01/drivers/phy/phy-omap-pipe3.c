/*
 * omap-pipe3 - PHY driver for SATA, USB and PCIE in OMAP platforms
 *
 * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * Author: Kishon Vijay Abraham I <kishon@ti.com>
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#include <linux/module.h>
#include <linux/platform_device.h>
#include <linux/slab.h>
#include <linux/phy/omap_pipe3.h>
#include <linux/phy/phy.h>
#include <linux/of.h>
#include <linux/clk.h>
#include <linux/err.h>
#include <linux/pm_runtime.h>
#include <linux/delay.h>
#include <linux/phy/omap_control_phy.h>
#include <linux/of_platform.h>

#define	PLL_STATUS		0x00000004
#define	PLL_GO			0x00000008
#define	PLL_CONFIGURATION1	0x0000000C
#define	PLL_CONFIGURATION2	0x00000010
#define	PLL_CONFIGURATION3	0x00000014
#define	PLL_CONFIGURATION4	0x00000020

#define	PLL_REGM_MASK		0x001FFE00
#define	PLL_REGM_SHIFT		9
#define	PLL_REGM_F_MASK		0x0003FFFF
#define	PLL_REGM_F_SHIFT	0
#define	PLL_REGN_MASK		0x000001FE
#define	PLL_REGN_SHIFT		1
#define	PLL_SELFREQDCO_MASK	0x0000000E
#define	PLL_SELFREQDCO_SHIFT	1
#define	PLL_SD_MASK		0x0003FC00
#define	PLL_SD_SHIFT		10
#define	SET_PLL_GO		0x1
#define	PLL_TICOPWDN		BIT(16)
#define PLL_LDOPWDN		BIT(15)
#define	PLL_LOCK		0x2
#define	PLL_IDLE		0x1

/*
 * This is an Empirical value that works, need to confirm the actual
 * value required for the PIPE3PHY_PLL_CONFIGURATION2.PLL_IDLE status
 * to be correctly reflected in the PIPE3PHY_PLL_STATUS register.
 */
#define PLL_IDLE_TIME	100	/* in milliseconds */
#define PLL_LOCK_TIME	100	/* in milliseconds */

static struct pipe3_dpll_map dpll_map_usb[] = {
	{12000000, {1250, 5, 4, 20, 0} },	/* 12 MHz */
	{16800000, {3125, 20, 4, 20, 0} },	/* 16.8 MHz */
	{19200000, {1172, 8, 4, 20, 65537} },	/* 19.2 MHz */
	{20000000, {1000, 7, 4, 10, 0} },	/* 20 MHz */
	{26000000, {1250, 12, 4, 20, 0} },	/* 26 MHz */
	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
	{ },					/* Terminator */
};

static struct pipe3_dpll_map dpll_map_sata[] = {
	{12000000, {1000, 7, 4, 6, 0} },	/* 12 MHz */
	{16800000, {714, 7, 4, 6, 0} },		/* 16.8 MHz */
	{19200000, {625, 7, 4, 6, 0} },		/* 19.2 MHz */
	{20000000, {600, 7, 4, 6, 0} },		/* 20 MHz */
	{26000000, {461, 7, 4, 6, 0} },		/* 26 MHz */
	{38400000, {312, 7, 4, 6, 0} },		/* 38.4 MHz */
	{ },					/* Terminator */
};

static struct pipe3_dpll_params *omap_pipe3_get_dpll_params(struct omap_pipe3
									*pipe3)
{
	unsigned long rate;
	struct pipe3_dpll_map *dpll_map = pipe3->dpll_map;

	rate = clk_get_rate(pipe3->sys_clk);

	for (; dpll_map->rate; dpll_map++) {
		if (rate == dpll_map->rate)
			return &dpll_map->params;
	}

	dev_err(pipe3->dev,
		  "No DPLL configuration for %lu Hz SYS CLK\n", rate);
	return 0;
}

static int omap_pipe3_wait_lock(struct omap_pipe3 *phy)
{
	u32		val;
	unsigned long	timeout;

	timeout = jiffies + msecs_to_jiffies(PLL_LOCK_TIME);
	do {
		cpu_relax();
		val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
		if (val & PLL_LOCK)
			break;
	} while (!time_after(jiffies, timeout));

	if (!(val & PLL_LOCK)) {
		dev_err(phy->dev, "DPLL failed to lock\n");
		return -EBUSY;
	}

	return 0;
}

static int omap_pipe3_dpll_program(struct omap_pipe3 *phy)
{
	u32			val;
	unsigned long		rate;
	struct pipe3_dpll_params *dpll_params;

	rate = clk_get_rate(phy->sys_clk);
	dpll_params = omap_pipe3_get_dpll_params(phy);
	if (!dpll_params) {
		dev_err(phy->dev, "Invalid DPLL parameters\n");
		return -EINVAL;
	}

	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
	val &= ~PLL_REGN_MASK;
	val |= dpll_params->n << PLL_REGN_SHIFT;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);

	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
	val &= ~PLL_SELFREQDCO_MASK;
	val |= dpll_params->freq << PLL_SELFREQDCO_SHIFT;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);

	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
	val &= ~PLL_REGM_MASK;
	val |= dpll_params->m << PLL_REGM_SHIFT;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);

	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
	val &= ~PLL_REGM_F_MASK;
	val |= dpll_params->mf << PLL_REGM_F_SHIFT;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);

	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
	val &= ~PLL_SD_MASK;
	val |= dpll_params->sd << PLL_SD_SHIFT;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);

	omap_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);

	return omap_pipe3_wait_lock(phy);
}

static int omap_pipe3_power_off(struct phy *x)
{
	struct omap_pipe3 *phy = phy_get_drvdata(x);

	omap_control_phy_power(phy->control_dev, 0);
	return 0;
}

static int omap_pipe3_power_on(struct phy *x)
{
	struct omap_pipe3 *phy = phy_get_drvdata(x);

	omap_control_phy_power(phy->control_dev, 1);
	return 0;
}

static int omap_pipe3_init(struct phy *x)
{
	struct omap_pipe3 *phy = phy_get_drvdata(x);
	u32 val;
	int ret = 0;

	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie"))
		return 0;

	/* Bring it out of IDLE if it is IDLE */
	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
	if (val & PLL_IDLE) {
		val &= ~PLL_IDLE;
		omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
		ret = omap_pipe3_wait_lock(phy);
	}

	/* Program the DPLL only if not locked */
	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
	if (!(val & PLL_LOCK))
		if (omap_pipe3_dpll_program(phy))
			return -EINVAL;

	return ret;
}

static int omap_pipe3_exit(struct phy *x)
{
	struct omap_pipe3 *phy = phy_get_drvdata(x);
	u32 val;
	unsigned long timeout;

	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-pcie"))
		return 0;

	/* SATA DPLL can't be powered down due to Errata i783 */
	if (of_device_is_compatible(phy->dev->of_node, "ti,phy-pipe3-sata"))
		return 0;

	/* Put DPLL in IDLE mode */
	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
	val |= PLL_IDLE;
	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);

	/* wait for LDO and Oscillator to power down */
	timeout = jiffies + msecs_to_jiffies(PLL_IDLE_TIME);
	do {
		cpu_relax();
		val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
		if ((val & PLL_TICOPWDN) && (val & PLL_LDOPWDN))
			break;
	} while (!time_after(jiffies, timeout));

	if (!(val & PLL_TICOPWDN) || !(val & PLL_LDOPWDN)) {
		dev_err(phy->dev, "Failed to power down: PLL_STATUS 0x%x\n",
									val);
		return -EBUSY;
	}

	return 0;
}

static struct phy_ops ops = {
	.init		= omap_pipe3_init,
	.power_on	= omap_pipe3_power_on,
	.power_off	= omap_pipe3_power_off,
	.exit		= omap_pipe3_exit,
	.owner		= THIS_MODULE,
};

#ifdef CONFIG_OF
static const struct of_device_id omap_pipe3_id_table[] = {
	{
		.compatible = "ti,phy-pipe3-usb3",
		.data = dpll_map_usb,
	},
	{
		.compatible = "ti,phy-pipe3-sata",
		.data = dpll_map_sata,
	},
	{
		.compatible = "ti,phy-pipe3-pcie",
	},
	{},
};
MODULE_DEVICE_TABLE(of, omap_pipe3_id_table);
#endif

static int omap_pipe3_probe(struct platform_device *pdev)
{
	struct omap_pipe3 *phy;
	struct phy *generic_phy;
	struct phy_provider *phy_provider;
	struct resource *res;
	struct device_node *node = pdev->dev.of_node;
	struct device_node *control_node;
	struct platform_device *control_pdev;
	const struct of_device_id *match;
	struct clk *clk;

	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
	if (!phy) {
		dev_err(&pdev->dev, "unable to alloc mem for OMAP PIPE3 PHY\n");
		return -ENOMEM;
	}
	phy->dev		= &pdev->dev;

	if (!of_device_is_compatible(node, "ti,phy-pipe3-pcie")) {
		match = of_match_device(of_match_ptr(omap_pipe3_id_table), &pdev->dev);
		if (!match)
			return -EINVAL;

		phy->dpll_map = (struct pipe3_dpll_map *)match->data;
		if (!phy->dpll_map) {
			dev_err(&pdev->dev, "no dpll data\n");
			return -EINVAL;
		}

		res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pll_ctrl");
		phy->pll_ctrl_base = devm_ioremap_resource(&pdev->dev, res);
		if (IS_ERR(phy->pll_ctrl_base))
			return PTR_ERR(phy->pll_ctrl_base);

		phy->sys_clk = devm_clk_get(phy->dev, "sys_clkin");
		if (IS_ERR(phy->sys_clk)) {
			pr_err("%s: unable to get sys_clkin\n", __func__);
			return -EINVAL;
		}
	} else {
		clk = devm_clk_get(phy->dev, "dpll_ref");
		if (IS_ERR(clk)) {
			dev_err(&pdev->dev, "unable to get dpll ref clk\n");
			return PTR_ERR(clk);
		}
		clk_set_rate(clk, 1500000000);

		clk = devm_clk_get(phy->dev, "dpll_ref_m2");
		if (IS_ERR(clk)) {
			dev_err(&pdev->dev, "unable to get dpll ref m2 clk\n");
			return PTR_ERR(clk);
		}
		clk_set_rate(clk, 100000000);

		clk = devm_clk_get(phy->dev, "pcie-phy-div");
		if (IS_ERR(clk)) {
			dev_err(&pdev->dev, "unable to get pcie-phy-div clk\n");
			return PTR_ERR(clk);
		}
		clk_set_rate(clk, 100000000);
	}

	phy->wkupclk = devm_clk_get(phy->dev, "wkupclk");
	if (IS_ERR(phy->wkupclk))
		dev_dbg(&pdev->dev, "unable to get wkupclk\n");

	phy->optclk = devm_clk_get(phy->dev, "refclk");
	if (IS_ERR(phy->optclk))
		dev_dbg(&pdev->dev, "unable to get refclk\n");

	phy->optclk2 = devm_clk_get(phy->dev, "refclk2");
	if (IS_ERR(phy->optclk2))
		dev_dbg(&pdev->dev, "unable to get refclk2\n");

	control_node = of_parse_phandle(node, "ctrl-module", 0);
	if (!control_node) {
		dev_err(&pdev->dev, "Failed to get control device phandle\n");
		return -EINVAL;
	}

	phy_provider = devm_of_phy_provider_register(phy->dev,
			of_phy_simple_xlate);
	if (IS_ERR(phy_provider))
		return PTR_ERR(phy_provider);

	control_pdev = of_find_device_by_node(control_node);
	if (!control_pdev) {
		dev_err(&pdev->dev, "Failed to get control device\n");
		return -EINVAL;
	}

	phy->control_dev = &control_pdev->dev;

	omap_control_phy_power(phy->control_dev, 0);

	platform_set_drvdata(pdev, phy);
	pm_runtime_enable(phy->dev);

	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
	if (IS_ERR(generic_phy))
		return PTR_ERR(generic_phy);

	phy_set_drvdata(generic_phy, phy);

	pm_runtime_get_sync(&pdev->dev);

	return 0;
}

static int omap_pipe3_remove(struct platform_device *pdev)
{
	if (!pm_runtime_suspended(&pdev->dev))
		pm_runtime_put_sync(&pdev->dev);
	pm_runtime_disable(&pdev->dev);

	return 0;
}

#ifdef CONFIG_PM_RUNTIME

static int omap_pipe3_runtime_suspend(struct device *dev)
{
	struct omap_pipe3	*phy = dev_get_drvdata(dev);

	if (!IS_ERR(phy->wkupclk))
		clk_disable_unprepare(phy->wkupclk);
	if (!IS_ERR(phy->optclk))
		clk_disable_unprepare(phy->optclk);
	if (!IS_ERR(phy->optclk2))
		clk_disable_unprepare(phy->optclk2);

	return 0;
}

static int omap_pipe3_runtime_resume(struct device *dev)
{
	u32 ret = 0;
	struct omap_pipe3	*phy = dev_get_drvdata(dev);

	if (!IS_ERR(phy->optclk)) {
		ret = clk_prepare_enable(phy->optclk);
		if (ret) {
			dev_err(phy->dev, "Failed to enable optclk %d\n", ret);
			goto err1;
		}
	}

	if (!IS_ERR(phy->wkupclk)) {
		ret = clk_prepare_enable(phy->wkupclk);
		if (ret) {
			dev_err(phy->dev, "Failed to enable wkupclk %d\n", ret);
			goto err2;
		}
	}

	if (!IS_ERR(phy->optclk2)) {
		ret = clk_prepare_enable(phy->optclk2);
		if (ret) {
			dev_err(phy->dev, "Failed to enable optclk2 %d\n", ret);
			goto err3;
		}
	}

	return 0;

err3:
	if (!IS_ERR(phy->wkupclk))
		clk_disable_unprepare(phy->wkupclk);
err2:
	if (!IS_ERR(phy->optclk))
		clk_disable_unprepare(phy->optclk);

err1:
	return ret;
}

static const struct dev_pm_ops omap_pipe3_pm_ops = {
	SET_RUNTIME_PM_OPS(omap_pipe3_runtime_suspend,
		omap_pipe3_runtime_resume, NULL)
};

#define DEV_PM_OPS     (&omap_pipe3_pm_ops)
#else
#define DEV_PM_OPS     NULL
#endif

static struct platform_driver omap_pipe3_driver = {
	.probe		= omap_pipe3_probe,
	.remove		= omap_pipe3_remove,
	.driver		= {
		.name	= "omap-pipe3",
		.owner	= THIS_MODULE,
		.pm	= DEV_PM_OPS,
		.of_match_table = of_match_ptr(omap_pipe3_id_table),
	},
};

module_platform_driver(omap_pipe3_driver);

MODULE_ALIAS("platform: omap_pipe3");
MODULE_AUTHOR("Texas Instruments Inc.");
MODULE_DESCRIPTION("OMAP PIPE3 phy driver");
MODULE_LICENSE("GPL v2");
