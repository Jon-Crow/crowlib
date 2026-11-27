CROWLIB_PATH ?= ../../../..

TB           ?= rx_header_tb
HEADER_BYTES ?= 8
INPUT_FILE   ?= "udp_packet.txt"
GENERICS     ?= 

ifeq ($(TB), rx_header_tb)
	GENERICS += -gG_HEADER_BYTES=$(HEADER_BYTES)
else ifeq ($(TB), rx_header_tb)
	GENERICS += -gG_INPUT_FILE=$(INPUT_FILE)
endif

include $(CROWLIB_PATH)/crowlib_ghdl.mk

clean:
	del *.cf *.fst *.o *.exe *.vpi *.dll

analyze::
	ghdl -a --std=08 rx_header_tb.vhd \
                   rx_header_packet_tb.vhd

compile: analyze
	ghdl -e --std=08 $(TB)

sim:
	ghdl -r --std=08 $(TB) $(GENERICS) --ieee-asserts=disable-at-0 --wave=wave.ghw

view:
	gtkwave -a wave.gtkw wave.ghw
