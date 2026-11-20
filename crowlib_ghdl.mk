CROWLIB_PATH ?= .
SDL_PATH ?= C:/Users/jonat/Documents/gamedev/libraries/SDL/install

analyze::
	ghdl -a --std=08 --work=crowlib $(CROWLIB_PATH)/packages/common_pkg.vhd \
                                  $(CROWLIB_PATH)/modules/clk_and_rst/hdl/clk_and_rst.vhd \
                                  $(CROWLIB_PATH)/modules/sim_display/hdl/sim_display.vhd

plugins:
	ghdl --vpi-compile gcc -I$(SDL_PATH)/include \
                         -c $(CROWLIB_PATH)/plugins/sim_display/sim_display.c \
                         -o sim_display.o
	ghdl --vpi-link gcc sim_display.o -L$(SDL_PATH)/lib -lSDL3 -o sim_display.vpi
