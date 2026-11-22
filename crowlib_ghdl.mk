CROWLIB_PATH ?= .
SDL_PATH ?= C:/Users/jonat/Documents/gamedev/libraries/SDL/install
GCC ?= C:/msys64/ucrt64/bin/gcc.exe

analyze::
	ghdl -a --std=08 --work=crowlib $(CROWLIB_PATH)/packages/common_pkg.vhd                                  \
                                  $(CROWLIB_PATH)/packages/display_pkg.vhd                                 \
																	$(CROWLIB_PATH)/modules/cellular_automata/hdl/cellular_automata_grid.vhd \
                                  $(CROWLIB_PATH)/modules/clk_and_rst/hdl/clk_and_rst.vhd                  \
                                  $(CROWLIB_PATH)/modules/sim_display/hdl/sim_display.vhd                  \
                                  $(CROWLIB_PATH)/modules/sim_display/hdl/sim_display_bw.vhd

plugins:
	copy /Y "$(subst /,\,$(SDL_PATH)/bin/SDL3.dll)" .
	ghdl --vpi-compile $(GCC) -I$(SDL_PATH)/include                             \
                         -c $(CROWLIB_PATH)/plugins/sim_display/sim_display.c \
                         -o sim_display.o
	ghdl --vpi-link $(GCC) sim_display.o -L$(SDL_PATH)/lib -lSDL3 -o sim_display.vpi
