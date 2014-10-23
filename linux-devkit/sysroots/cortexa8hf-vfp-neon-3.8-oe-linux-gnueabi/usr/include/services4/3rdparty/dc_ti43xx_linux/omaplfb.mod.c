#include <linux/module.h>
#include <linux/vermagic.h>
#include <linux/compiler.h>

MODULE_INFO(vermagic, VERMAGIC_STRING);

struct module __this_module
__attribute__((section(".gnu.linkonce.this_module"))) = {
	.name = KBUILD_MODNAME,
	.init = init_module,
#ifdef CONFIG_MODULE_UNLOAD
	.exit = cleanup_module,
#endif
	.arch = MODULE_ARCH_INIT,
};

static const struct modversion_info ____versions[]
__used
__attribute__((section("__versions"))) = {
	{ 0x2374bad8, __VMLINUX_SYMBOL_STR(module_layout) },
	{ 0x12da5bb2, __VMLINUX_SYMBOL_STR(__kmalloc) },
	{ 0x539a5b03, __VMLINUX_SYMBOL_STR(mutex_destroy) },
	{ 0x2e5810c6, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr1) },
	{ 0x80d68d3e, __VMLINUX_SYMBOL_STR(fb_register_client) },
	{ 0x71b629b8, __VMLINUX_SYMBOL_STR(__alloc_workqueue_key) },
	{ 0x3cdf8fe, __VMLINUX_SYMBOL_STR(fb_pan_display) },
	{ 0xf7802486, __VMLINUX_SYMBOL_STR(__aeabi_uidivmod) },
	{ 0x7344cc7c, __VMLINUX_SYMBOL_STR(mutex_unlock) },
	{ 0x785136c, __VMLINUX_SYMBOL_STR(PVRGetDisplayClassJTable) },
	{ 0xe2d5255a, __VMLINUX_SYMBOL_STR(strcmp) },
	{ 0xc631580a, __VMLINUX_SYMBOL_STR(console_unlock) },
	{ 0xe707d823, __VMLINUX_SYMBOL_STR(__aeabi_uidiv) },
	{ 0xfa2a45e, __VMLINUX_SYMBOL_STR(__memzero) },
	{ 0x271f2ced, __VMLINUX_SYMBOL_STR(__mutex_init) },
	{ 0x27e1a049, __VMLINUX_SYMBOL_STR(printk) },
	{ 0x328a05f1, __VMLINUX_SYMBOL_STR(strncpy) },
	{ 0xfbaaf01e, __VMLINUX_SYMBOL_STR(console_lock) },
	{ 0x16305289, __VMLINUX_SYMBOL_STR(warn_slowpath_null) },
	{ 0x8c03d20c, __VMLINUX_SYMBOL_STR(destroy_workqueue) },
	{ 0x1c3977be, __VMLINUX_SYMBOL_STR(module_put) },
	{ 0xb8ff4713, __VMLINUX_SYMBOL_STR(registered_fb) },
	{ 0x83fb9d7e, __VMLINUX_SYMBOL_STR(fb_set_var) },
	{ 0x9be9d0b2, __VMLINUX_SYMBOL_STR(mutex_lock_nested) },
	{ 0x37a0cba, __VMLINUX_SYMBOL_STR(kfree) },
	{ 0x9d669763, __VMLINUX_SYMBOL_STR(memcpy) },
	{ 0x89c0ed7c, __VMLINUX_SYMBOL_STR(lockdep_init_map) },
	{ 0xb12cbacb, __VMLINUX_SYMBOL_STR(fb_unregister_client) },
	{ 0xefd6cf06, __VMLINUX_SYMBOL_STR(__aeabi_unwind_cpp_pr0) },
	{ 0xc0fa0d21, __VMLINUX_SYMBOL_STR(queue_work_on) },
	{ 0x5965fdfb, __VMLINUX_SYMBOL_STR(try_module_get) },
	{ 0x1fd09355, __VMLINUX_SYMBOL_STR(fb_blank) },
};

static const char __module_depends[]
__used
__attribute__((section(".modinfo"))) =
"depends=pvrsrvkm";


MODULE_INFO(srcversion, "9D789311ACD38C9A6368FFC");
