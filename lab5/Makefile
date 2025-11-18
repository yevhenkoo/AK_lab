ccflags-y := -I$(src)/inc

obj-m += hello1.o
obj-m += hello2.o

KDIR ?= /lib/modules/$(shell uname -r)/build

all:
	make -C $(KDIR) M=$(PWD) modules

clean:
	make -C $(KDIR) M=$(PWD) clean
