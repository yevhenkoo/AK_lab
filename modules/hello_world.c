#define pr_fmt(fmt) "hello: " fmt

#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/moduleparam.h>
#include <linux/stat.h>
#include <linux/ktime.h>
#include <linux/list.h>
#include <linux/slab.h>
#include <linux/errno.h>

MODULE_LICENSE("GPL");
MODULE_AUTHOR("IO-32 Yevhenii Onischenko");
MODULE_DESCRIPTION("LKM with charp, uint param, ktime, and lists.");
MODULE_VERSION("1.0");

static char *name = "world";
module_param(name, charp, 0444);
MODULE_PARM_DESC(name, "The name to display.");

static unsigned int howmany = 1;
module_param(howmany, uint, 0444);
MODULE_PARM_DESC(howmany, "Number of times to print 'Hello' (default: 1)");

struct hello_event {
	struct list_head list;
	ktime_t event_time;
};

static LIST_HEAD(event_list_head);

static int __init hello_init(void)
{
	int i;
	struct hello_event *new_event;

	pr_info("Module loading...\n");

	if (howmany > 10) {
		pr_err("'howmany' (%u) > 10. Aborting load.\n", howmany);
		return -EINVAL;
	}

	if (howmany == 0 || (howmany >= 5 && howmany <= 10))
		pr_warn("'howmany' (%u) is non-standard. Continuing.\n",
			howmany);

	for (i = 0; i < howmany; i++) {
		new_event = kmalloc(sizeof(*new_event), GFP_KERNEL);
		if (!new_event)
			goto cleanup;

		new_event->event_time = ktime_get();
		list_add_tail(&new_event->list, &event_list_head);

		pr_info("Hello, %s! (event %d/%u)\n", name, i + 1, howmany);
	}

	return 0;

cleanup:
	{
		struct hello_event *cur, *tmp;

		pr_info("Error occurred during init, cleaning up...\n");
		list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
			list_del(&cur->list);
			kfree(cur);
		}
	}
	return -ENOMEM;
}

static void __exit hello_exit(void)
{
	struct hello_event *cur, *tmp;
	int count = 0;

	pr_info("Module unloading. Printing saved times...\n");

	list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
		count++;
		pr_info("Event %d time: %lld ns\n",
			count, ktime_to_ns(cur->event_time));

		list_del(&cur->list);
		kfree(cur);
	}

	pr_info("Cleaned up %d events. Goodbye, %s!\n", count, name);
}

module_init(hello_init);
module_exit(hello_exit);

