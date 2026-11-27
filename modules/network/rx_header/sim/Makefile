CROWLIB_PATH ?= ../../../../

HEADER_BYTES ?= 8

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 rx_header_tb.vhd

compile: analyze
	ghdl -e --std=08 rx_header_tb

sim:
	ghdl -r --std=08 rx_header_tb -gG_HEADER_BYTES=$(HEADER_BYTES) --ieee-asserts=disable-at-0 --fst=wave.fst

view:
	gtkwave -a wave.gtkw wave.fst
