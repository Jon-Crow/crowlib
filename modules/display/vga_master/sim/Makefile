CROWLIB_PATH ?= ../../../../

WIDTH         ?= 320
HEIGHT        ?= 400
RGB_WIDTH     ?= 8
H_FRONT_PORCH ?= 8
H_SYNC        ?= 48
H_BACK_PORCH  ?= 24
V_FRONT_PORCH ?= 12
V_SYNC        ?= 2
V_BACK_PORCH  ?= 35

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
       --ieee-asserts=disable-at-0 --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
