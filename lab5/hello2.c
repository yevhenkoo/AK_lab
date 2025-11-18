/* hello2.c */
#define pr_fmt(fmt) "hello2_control: " fmt

#include <linux/init.h>
#include <linux/module.h>
#include <linux/moduleparam.h>
#include <linux/errno.h>
#include "hello1.h" 

MODULE_LICENSE("GPL");
MODULE_AUTHOR("IO-32 Yevhenii Onischenko");
MODULE_DESCRIPTION("Control module with parameters");

static char *name = "world";
module_param(name, charp, 0444);
MODULE_PARM_DESC(name, "The name to display.");

static unsigned int howmany = 1;
module_param(howmany, uint, 0444);
MODULE_PARM_DESC(howmany, "Number of times to print 'Hello' (default: 1)");

static int __init hello2_init(void)
{
    int i;

    pr_info("Loading control module...\n");

    if (howmany > 10) {
        pr_err("'howmany' (%u) > 10. Aborting load.\n", howmany);
        return -EINVAL;
    }

    if (howmany == 0 || (howmany >= 5 && howmany <= 10)) {
        pr_warn("'howmany' (%u) is non-standard. Continuing.\n", howmany);
    }

    for (i = 0; i < howmany; i++) {
        print_hello(name, i + 1);
    }

    return 0;
}

static void __exit hello2_exit(void)
{
    pr_info("Unloading control module.\n");
}

module_init(hello2_init);
module_exit(hello2_exit);
