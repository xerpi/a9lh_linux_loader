ifeq ($(strip $(DEVKITARM)),)
$(error "Please set DEVKITARM in your environment. export DEVKITARM=<path to>devkitARM")
endif

include $(DEVKITARM)/base_tools

TARGET = a9lh_linux_loader
SOURCES = source source/fatfs
INCLUDES = include include/fatfs

SFILES = $(foreach dir, $(SOURCES), $(wildcard $(dir)/*.s))
CFILES = $(foreach dir, $(SOURCES), $(wildcard $(dir)/*.c))

OBJS = $(SFILES:.s=.o) $(CFILES:.c=.o)
INCLUDE = $(foreach dir, $(INCLUDES), -I$(CURDIR)/$(dir))

ARCH = -mcpu=arm946e-s -march=armv5te -mlittle-endian -mthumb-interwork
ASFLAGS = $(ARCH) $(INCLUDE) -x assembler-with-cpp
CFLAGS = -Wall -O0 -fno-builtin -nostartfiles $(ARCH) $(INCLUDE)

all: $(TARGET).bin

$(TARGET).elf: $(OBJS)
	$(CC) -T linker.ld $^ -o $@

%.bin: %.elf
	$(OBJCOPY) -O binary --set-section-flags .bss=alloc,load,contents $< $@

.c.o:
	$(CC) $(CFLAGS) -c $< -o $@

.s.o:
	$(CC) $(ASFLAGS) -c $< -o $@

clean:
	@rm -f $(OBJS) $(TARGET).elf $(TARGET).bin

copy: $(TARGET).bin
	cp $< $(SD3DS)/luma/payloads/down_$(TARGET).bin && sync
