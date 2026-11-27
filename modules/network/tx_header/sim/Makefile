CROWLIB_PATH ?= ../../../..

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 tx_header_tb.vhd

compile: analyze
	ghdl -e --std=08 tx_header_tb

sim:
	ghdl -r --std=08 tx_header_tb --ieee-asserts=disable-at-0 --wave=wave.ghw

view:
	gtkwave -a wave.gtkw wave.ghw
