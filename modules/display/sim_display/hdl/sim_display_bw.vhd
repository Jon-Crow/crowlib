library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;

entity sim_display_bw is
  generic (
    G_WIDTH  : positive := 256;
    G_HEIGHT : positive := 256
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;

    px     : in  t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
    update : in  std_logic
  );
end entity sim_display_bw;

architecture sim_display_bw_arch of sim_display_bw is

  component sim_display is
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
  end component sim_display;

  signal px_bw : t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1);

begin

  gen_clr_to_bw_row : for r in 0 to G_HEIGHT-1 generate
    gen_clr_to_bw_col : for c in 0 to G_WIDTH-1 generate
      px_bw(r)(c) <= K_COLOR_WHITE when px(r)(c) = '1' else K_COLOR_BLACK;
    end generate gen_clr_to_bw_col;
  end generate gen_clr_to_bw_row;

  u_display : sim_display
    generic map (
      G_WIDTH  => G_WIDTH,
      G_HEIGHT => G_HEIGHT
    )
    port map (
      clk    => clk,
      rst    => rst,

      px     => px_bw,
      update => update
  );

end architecture sim_display_bw_arch;
