/*
 * (C) Copyright 2013
 * Texas Instruments Incorporated, <www.ti.com>
 *
 * Sricharan R	<r.sricharan@ti.com>
 * Nishant Kamat <nskamat@ti.com>
 *
 * SPDX-License-Identifier:	GPL-2.0+
 */
#ifndef _MUX_DATA_DRA7XX_H_
#define _MUX_DATA_DRA7XX_H_

#include <asm/arch/mux_dra7xx.h>

const struct pad_conf_entry core_padconf_array_essential[] = {
	{MMC1_CLK, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_CLK */
	{MMC1_CMD, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_CMD */
	{MMC1_DAT0, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_DAT0 */
	{MMC1_DAT1, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_DAT1 */
	{MMC1_DAT2, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_DAT2 */
	{MMC1_DAT3, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_DAT3 */
	{MMC1_SDCD, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* MMC1_SDCD */
	{MMC1_SDWP, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(14))},	/* MMC1_SDWP */
	{GPMC_A19, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat4 */
	{GPMC_A20, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat5 */
	{GPMC_A21, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat6 */
	{GPMC_A22, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat7 */
	{GPMC_A23, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_clk */
	{GPMC_A24, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat0 */
	{GPMC_A25, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat1 */
	{GPMC_A26, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat2 */
	{GPMC_A27, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmc2_dat3 */
	{GPMC_CS1, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* mmm2_cmd */
	{UART1_RXD, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* UART1_RXD */
	{UART1_TXD, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* UART1_TXD */
	{UART1_CTSN, (PIN_INPUT_PULLUP | PIN_MUX_MODE(3))},	/* UART1_CTSN */
	{UART1_RTSN, (PIN_INPUT_PULLUP | PIN_MUX_MODE(3))},	/* UART1_RTSN */
	{I2C1_SDA, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* I2C1_SDA */
	{I2C1_SCL, (PIN_INPUT_PULLUP | PIN_MUX_MODE(0))},	/* I2C1_SCL */
	{MDIO_MCLK, (PIN_OUTPUT_NOPULL | PIN_MUX_MODE(0))},	/* MDIO_MCLK  */
	{MDIO_D, (PIN_INPUT_NOPULL | PIN_MUX_MODE(0))},		/* MDIO_D  */
	{RGMII0_TXC, PIN_MUX_MODE(0) },
	{RGMII0_TXCTL, PIN_MUX_MODE(0) },
	{RGMII0_TXD3, PIN_MUX_MODE(0) },
	{RGMII0_TXD2, PIN_MUX_MODE(0) },
	{RGMII0_TXD1, PIN_MUX_MODE(0) },
	{RGMII0_TXD0, PIN_MUX_MODE(0) },
	{RGMII0_RXC, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{RGMII0_RXCTL, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{RGMII0_RXD3, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{RGMII0_RXD2, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{RGMII0_RXD1, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{RGMII0_RXD0, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0))},
	{GPMC_A13, (PIN_INPUT_NOPULL | PIN_MUX_MODE(1))},	/* QSPI1_RTCLK*/
	{GPMC_A14, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_D[3] */
	{GPMC_A15, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_D[2] */
	{GPMC_A16, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_D[1] */
	{GPMC_A17, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_D[0] */
	{GPMC_A18, (PIN_OUTPUT_NOPULL | PIN_MUX_MODE(1))},	/* QSPI1_SCLK */
	{GPMC_A3, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_CS2 */
	{GPMC_A4, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(1))},	/* QSPI1_CS3 */
	{GPMC_CS2, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* QSPI1_CS0 */
	{GPMC_CS3, (PIN_INPUT_PULLUP | PIN_MUX_MODE(1))},	/* QSPI1_CS1*/
	{USB2_DRVVBUS, (PIN_INPUT_PULLDOWN | PIN_MUX_MODE(0)) },
 #ifdef CONFIG_NAND
	{GPMC_AD0 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD0  */
	{GPMC_AD1 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD1  */
	{GPMC_AD2 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD2  */
	{GPMC_AD3 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD3  */
	{GPMC_AD4 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD4  */
	{GPMC_AD5 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD5  */
	{GPMC_AD6 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD6  */
	{GPMC_AD7 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD7  */
	{GPMC_AD8 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD8  */
	{GPMC_AD9 , PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD9  */
	{GPMC_AD10, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD10 */
	{GPMC_AD11, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD11 */
	{GPMC_AD12, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD12 */
	{GPMC_AD13, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD13 */
	{GPMC_AD14, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD14 */
	{GPMC_AD15, PIN_MUX_MODE(0) | PIN_INPUT_NOPULL}, /* GPMC_AD15 */
	{GPMC_CS0,  PIN_MUX_MODE(0) | PIN_OUTPUT_PULLUP}, /* GPMC_CS0 */
	{GPMC_ADVN_ALE, PIN_MUX_MODE(0) | PIN_OUTPUT_PULLDOWN}, /* GPMC_ALE */
	{GPMC_OEN_REN, PIN_MUX_MODE(0) | PIN_OUTPUT_PULLDOWN}, /* GPMC_OEN_REN*/
	{GPMC_WEN, PIN_MUX_MODE(0) | PIN_OUTPUT_PULLUP}, /* GPMC_WEN */
	{GPMC_BEN0, PIN_MUX_MODE(0) | PIN_OUTPUT_PULLDOWN}, /* GPMC_BEN0_CLE */
	{GPMC_WAIT0, PIN_MUX_MODE(0) | PIN_INPUT_PULLUP}, /* GPMC_WAIT0 */
	/* GPMC_WPN is controlled by on-board DIP Switch SW10(12) */
 #endif /* CONFIG_NAND */
};


#endif /* _MUX_DATA_DRA7XX_H_ */
