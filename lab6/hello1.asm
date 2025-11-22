
hello1.o:     file format elf32-littlearm


Disassembly of section .text:

00000000 <print_hello>:
			unsigned int index = kmalloc_index(size);

			if (!index)
				return ZERO_SIZE_PTR;

			return kmem_cache_alloc_trace(kmalloc_caches[index],
   0:	e3003000 	movw	r3, #0
   4:	e3403000 	movt	r3, #0
};

static LIST_HEAD(event_list_head);

void print_hello(const char *name, unsigned int counter)
{
   8:	e92d4370 	push	{r4, r5, r6, r8, r9, lr}
   c:	e3a02018 	mov	r2, #24
  10:	e1a05001 	mov	r5, r1
  14:	e1a06000 	mov	r6, r0
  18:	e3a010c0 	mov	r1, #192	@ 0xc0
  1c:	e3401060 	movt	r1, #96	@ 0x60
  20:	e5930018 	ldr	r0, [r3, #24]
  24:	ebfffffe 	bl	0 <kmem_cache_alloc_trace>
    struct hello_event *new_event;

    new_event = kmalloc(sizeof(*new_event), GFP_KERNEL);

    if (counter == 2) {
  28:	e3550002 	cmp	r5, #2
  2c:	e1a04000 	mov	r4, r0
  30:	0a000014 	beq	88 <print_hello+0x88>
        if (new_event) kfree(new_event); 
	new_event = NULL; 
    }

    BUG_ON(!new_event);
  34:	e3500000 	cmp	r0, #0
  38:	0a000015 	beq	94 <print_hello+0x94>

    new_event->time_start = ktime_get();
  3c:	ebfffffe 	bl	0 <ktime_get>
    pr_info("Hello, %s! (event %u)\n", name, counter);
  40:	e1a02005 	mov	r2, r5
    new_event->time_start = ktime_get();
  44:	e1a08000 	mov	r8, r0
  48:	e1a09001 	mov	r9, r1
    pr_info("Hello, %s! (event %u)\n", name, counter);
  4c:	e3000000 	movw	r0, #0
  50:	e3400000 	movt	r0, #0
  54:	e1a01006 	mov	r1, r6
    new_event->time_start = ktime_get();
  58:	e1c480f8 	strd	r8, [r4, #8]
    pr_info("Hello, %s! (event %u)\n", name, counter);
  5c:	ebfffffe 	bl	0 <printk>
    new_event->time_end = ktime_get();
  60:	ebfffffe 	bl	0 <ktime_get>
 * Insert a new entry before the specified head.
 * This is useful for implementing queues.
 */
static inline void list_add_tail(struct list_head *new, struct list_head *head)
{
	__list_add(new, head->prev, head);
  64:	e3003000 	movw	r3, #0
  68:	e3403000 	movt	r3, #0
  6c:	e1c401f0 	strd	r0, [r4, #16]
	new->next = next;
  70:	e5843000 	str	r3, [r4]
	__list_add(new, head->prev, head);
  74:	e5932004 	ldr	r2, [r3, #4]
	new->prev = prev;
  78:	e5842004 	str	r2, [r4, #4]
	next->prev = new;
  7c:	e5834004 	str	r4, [r3, #4]
static __always_inline void __write_once_size(volatile void *p, void *res, int size)
{
	switch (size) {
	case 1: *(volatile __u8 *)p = *(__u8 *)res; break;
	case 2: *(volatile __u16 *)p = *(__u16 *)res; break;
	case 4: *(volatile __u32 *)p = *(__u32 *)res; break;
  80:	e5824000 	str	r4, [r2]
     
    list_add_tail(&new_event->list, &event_list_head);
}
  84:	e8bd8370 	pop	{r4, r5, r6, r8, r9, pc}
        if (new_event) kfree(new_event); 
  88:	e3500000 	cmp	r0, #0
  8c:	0a000000 	beq	94 <print_hello+0x94>
  90:	ebfffffe 	bl	0 <kfree>
    BUG_ON(!new_event);
  94:	e7f001f2 	.word	0xe7f001f2

Disassembly of section .init.text:

00000000 <init_module>:
EXPORT_SYMBOL(print_hello);

static int __init hello1_init(void)
{
   0:	e92d4010 	push	{r4, lr}
    pr_info("Service module loaded.\n");
   4:	e3000000 	movw	r0, #0
   8:	e3400000 	movt	r0, #0
   c:	ebfffffe 	bl	0 <printk>
    return 0;
}
  10:	e3a00000 	mov	r0, #0
  14:	e8bd8010 	pop	{r4, pc}

Disassembly of section .exit.text:

00000000 <cleanup_module>:

static void __exit hello1_exit(void)
{
   0:	e92d4070 	push	{r4, r5, r6, lr}
    struct hello_event *cur, *tmp;
    
    pr_info("Unloading service module. Printing execution times...\n");

    list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
   4:	e3005000 	movw	r5, #0
   8:	e3405000 	movt	r5, #0
    pr_info("Unloading service module. Printing execution times...\n");
   c:	e3000000 	movw	r0, #0
  10:	e3400000 	movt	r0, #0
  14:	ebfffffe 	bl	0 <printk>
    list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
  18:	e5954000 	ldr	r4, [r5]
  1c:	e5946000 	ldr	r6, [r4]
  20:	e1540005 	cmp	r4, r5
  24:	08bd8070 	popeq	{r4, r5, r6, pc}
        s64 duration = ktime_to_ns(ktime_sub(cur->time_end, cur->time_start));
  28:	e5941008 	ldr	r1, [r4, #8]
        pr_info("Event printing took: %lld ns\n", duration);
  2c:	e3000000 	movw	r0, #0
  30:	e3400000 	movt	r0, #0
        s64 duration = ktime_to_ns(ktime_sub(cur->time_end, cur->time_start));
  34:	e5942010 	ldr	r2, [r4, #16]
  38:	e5943014 	ldr	r3, [r4, #20]
  3c:	e0522001 	subs	r2, r2, r1
  40:	e594100c 	ldr	r1, [r4, #12]
  44:	e0c33001 	sbc	r3, r3, r1
        pr_info("Event printing took: %lld ns\n", duration);
  48:	ebfffffe 	bl	0 <printk>
        list_del(&cur->list);
        kfree(cur);
  4c:	e1a00004 	mov	r0, r4
static inline void __list_del_entry(struct list_head *entry)
{
	if (!__list_del_entry_valid(entry))
		return;

	__list_del(entry->prev, entry->next);
  50:	e1c420d0 	ldrd	r2, [r4]
	next->prev = prev;
  54:	e5823004 	str	r3, [r2, #4]
  58:	e5832000 	str	r2, [r3]
}

static inline void list_del(struct list_head *entry)
{
	__list_del_entry(entry);
	entry->next = LIST_POISON1;
  5c:	e3a02c01 	mov	r2, #256	@ 0x100
  60:	e3a03c02 	mov	r3, #512	@ 0x200
  64:	e1c420f0 	strd	r2, [r4]
  68:	ebfffffe 	bl	0 <kfree>
    list_for_each_entry_safe(cur, tmp, &event_list_head, list) {
  6c:	e1a04006 	mov	r4, r6
  70:	e5966000 	ldr	r6, [r6]
  74:	eaffffe9 	b	20 <cleanup_module+0x20>
