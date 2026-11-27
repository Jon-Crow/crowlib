CROWLIB_PATH ?= ../../../../

WIDTH         ?= 640
HEIGHT        ?= 480
RGB_WIDTH     ?= 4
H_FRONT_PORCH ?= 16
H_SYNC        ?= 96
H_BACK_PORCH  ?= 48
V_FRONT_PORCH ?= 10
V_SYNC        ?= 2
V_BACK_PORCH  ?= 33

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 vga_master_tb.vhd

compile: analyze
	ghdl -e --std=08 vga_master_tb

sim:
	ghdl -r --std=08 vga_master_tb          \
       -gG_WIDTH=$(WIDTH)                 \
       -gG_HEIGHT=$(HEIGHT)               \
       -gG_RGB_WIDTH=$(RGB_WIDTH)         \
       -gG_H_FRONT_PORCH=$(H_FRONT_PORCH) \
       -gG_H_SYNC=$(H_SYNC)               \
       -gG_H_BACK_PORCH=$(H_BACK_PORCH)   \
       -gG_V_FRONT_PORCH=$(V_FRONT_PORCH) \
       -gG_V_SYNC=$(V_SYNC)               \
       -gG_V_BACK_PORCH=$(V_BACK_PORCH)   \
       --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
