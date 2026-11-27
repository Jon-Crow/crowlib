library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;
  use crowlib.sim_pkg.all;
use std.env.finish;

entity vga_master_tb is
  generic (
    G_WIDTH         : positive              := 640;
    G_HEIGHT        : positive              := 480;
    G_RGB_WIDTH     : positive range 1 to 8 := 4;
    G_H_FRONT_PORCH : positive              := 16;
    G_H_SYNC        : positive              := 96;
    G_H_BACK_PORCH  : positive              := 48;
    G_V_FRONT_PORCH : positive              := 10;
    G_V_SYNC        : positive              := 2;
    G_V_BACK_PORCH  : positive              := 33
  );
end entity vga_master_tb;

architecture vga_master_tb_arch of vga_master_tb is

  signal clk : std_logic;
  signal rst : std_logic;

  signal px  : t_color_arr_2d(0 to G_HEIGHT-1)(0 to G_WIDTH-1) := (others => (others => K_COLOR_DEFAULT));

  signal r   : std_logic_vector(G_RGB_WIDTH-1 downto 0);
  signal g   : std_logic_vector(G_RGB_WIDTH-1 downto 0);
  signal b   : std_logic_vector(G_RGB_WIDTH-1 downto 0);
  signal hs  : std_logic;
  signal vs  : std_logic;

begin

  process
  begin
    for row in 0 to G_HEIGHT-1 loop
      for col in 0 to G_WIDTH-1 loop
        px(row)(col) <= (
          r => to_unsigned(col, K_BYTE_WIDTH),
          g => to_unsigned(row, K_BYTE_WIDTH),
          b => (others => '0')
        );
      end loop;
    end loop;
    wait;
  end process;

  process
  begin
    wait until rising_edge(vs);
    for i in 0 to 999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

  u_clk_and_rst : entity crowlib.clk_and_rst
    generic map (
      G_NUM_CLKS => 1,
      G_CLK_PERS => (0 => 5 ns)
    )
    port map (
      clks(0) => clk,
      rsts(0) => rst
  );

  u_dut : entity crowlib.vga_master
    generic map (
      G_WIDTH         => G_WIDTH,
      G_HEIGHT        => G_HEIGHT,
      G_RGB_WIDTH     => G_RGB_WIDTH,
      G_H_FRONT_PORCH => G_H_FRONT_PORCH,
      G_H_SYNC        => G_H_SYNC,
      G_H_BACK_PORCH  => G_H_BACK_PORCH,
      G_V_FRONT_PORCH => G_V_FRONT_PORCH,
      G_V_SYNC        => G_V_SYNC,
      G_V_BACK_PORCH  => G_V_BACK_PORCH
    )
    port map (
      clk => clk,
      rst => rst,
      px  => px,
      r   => r,
      g   => g,
      b   => b,
      hs  => hs,
      vs  => vs
  );

end architecture vga_master_tb_arch;

