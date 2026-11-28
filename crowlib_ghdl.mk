CROWLIB_PATH ?= .
SDL_PATH ?= C:/SDL/install
GCC ?= C:/msys64/ucrt64/bin/gcc.exe

analyze::
	ghdl -a --std=08 --work=crowlib $(CROWLIB_PATH)/modules/common_pkg.vhd                                        \
                                  $(CROWLIB_PATH)/modules/display/display_pkg.vhd                               \
                                  $(CROWLIB_PATH)/modules/network/network_pkg.vhd                               \
                                  $(CROWLIB_PATH)/modules/sim_utils/sim_pkg.vhd                                 \
                                  $(CROWLIB_PATH)/modules/sim_utils/clk_and_rst/hdl/clk_and_rst.vhd             \
                                  $(CROWLIB_PATH)/modules/sim_utils/sim_display/hdl/sim_display.vhd             \
                                  $(CROWLIB_PATH)/modules/sim_utils/sim_display/hdl/sim_display_bw.vhd          \
                                  $(CROWLIB_PATH)/modules/misc/cellular_automata/hdl/cellular_automata_grid.vhd \
                                  $(CROWLIB_PATH)/modules/display/vga_master/hdl/vga_master.vhd                 \
                                  $(CROWLIB_PATH)/modules/network/rx_header/hdl/rx_header.vhd                   \
                                  $(CROWLIB_PATH)/modules/network/rx_header/hdl/rx_eth2_header.vhd              \
                                  $(CROWLIB_PATH)/modules/network/rx_header/hdl/rx_ipv4_header.vhd              \
                                  $(CROWLIB_PATH)/modules/network/rx_header/hdl/rx_udp_header.vhd               \
                                  $(CROWLIB_PATH)/modules/network/rx_header/hdl/rx_dhcp_header.vhd              \
                                  $(CROWLIB_PATH)/modules/network/tx_header/hdl/tx_header.vhd                   \
                                  $(CROWLIB_PATH)/modules/network/tx_header/hdl/tx_eth2_header.vhd              \
                                  $(CROWLIB_PATH)/modules/network/tx_header/hdl/tx_ipv4_header.vhd              \
                                  $(CROWLIB_PATH)/modules/network/tx_header/hdl/tx_udp_header.vhd               \
                                  $(CROWLIB_PATH)/modules/network/tx_header/hdl/tx_dhcp_header.vhd

plugin_common:
	ghdl --vpi-compile $(GCC) -c $(CROWLIB_PATH)/plugins/common.c -o common.o

plugin_display: plugin_common
	copy /Y "$(subst /,\,$(SDL_PATH)/bin/SDL3.dll)" .
	ghdl --vpi-compile $(GCC) -I$(SDL_PATH)/include                                \
                            -c $(CROWLIB_PATH)/plugins/sim_display/sim_display.c \
                            -o sim_display.o
	ghdl --vpi-link $(GCC) common.o sim_display.o -L$(SDL_PATH)/lib -lSDL3 -o sim_display.vpi

plugin_network: plugin_common
	ghdl --vpi-compile $(GCC) -c $(CROWLIB_PATH)/plugins/sim_network/sim_network.c \
                            -o sim_network.o
	ghdl --vpi-link $(GCC) common.o sim_network.o -o sim_network.vpi

plugins: plugin_display plugin_network
