/* hello1.c */
#define pr_fmt(fmt) "hello1_service: " fmt

#include <linux/init.h>
#include <linux/module.h>
#include <linux/printk.h>
#include <linux/ktime.h>
#include <linux/list.h>
#include <linux/slab.h>
#include "hello1.h" 

MODULE_LICENSE("GPL");
MODULE_AUTHOR("IO-32 Yevhenii Onischenko");
MODULE_DESCRIPTION("Service module handling list and timing");

struct hello_event {
    struct list_head list;
    ktime_t time_start;
    ktime_t time_end;
};

static LIST_HEAD(event_list_head);

void print_hello(const char *name, unsigned int counter)
{
    struct hello_event *new_event;

    new_event = kmalloc(sizeof(*new_event), GFP_KERNEL);
    if (!new_event) {
        pr_err("Failed to allocate memory for event\n");
        return;
    }

    new_event->time_start = ktime_get();
    pr_info("Hello, %s! (event %u)\n", name, counter);
    new_event->time_end = ktime_get();
	 
    list_add_tail(&new_event->list, &event_list_head);
}
EXPORT_SYMBOL(print_hello);
static int __init hello1_init(void)
{
    pr_info("Service module loaded.\n");
    return 0;
}

static void __exit hello1_exit(void)
{
    struct hello_event *cur, *tmp;
    
    pr_info("Unloading service module. Printing execution times...\n");

    list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
        s64 duration = ktime_to_ns(ktime_sub(cur->time_end, cur->time_start));
        
        pr_info("Event printing took: %lld ns\n", duration);
        
        list_del(&cur->list);
        kfree(cur);
    }
}

module_init(hello1_init);
module_exit(hello1_exit);
