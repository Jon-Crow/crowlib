library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;
use std.env.finish;

entity sim_display is
  generic (
    G_WIDTH  : positive := 256;
    G_HEIGHT : positive := 256
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;

    px     : in  t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1);
    update : in  std_logic
  );
end entity sim_display;

architecture sim_display_arch of sim_display is

  signal px_d     : t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1);
  signal px_q     : t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1);
  signal update_q : std_logic;

  signal vpi_tag_sim_display : std_logic := '1';

begin

  process
  begin
    wait until vpi_tag_sim_display = '0';
    finish;
  end process;

  c_blend : process(all)
  begin
    px_d <= px_q;

    if(update = '1') then
      for r in 0 to G_HEIGHT-1 loop
        for c in 0 to G_WIDTH-1 loop
          px_d(r)(c) <= f_blend_color(px_q(r)(c), px(r)(c));
        end loop;
      end loop;
    end if;
  end process c_blend;

  s_regs : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        px_q     <= (others => (others => K_COLOR_DEFAULT));
        update_q <= '0';

      else

        px_q     <= px_d;
        update_q <= update;

      end if;
    end if;
  end process s_regs;

end architecture sim_display_arch;
