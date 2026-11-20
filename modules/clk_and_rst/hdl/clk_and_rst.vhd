library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;

entity clk_and_rst is
  generic (
    G_NUM_CLKS : positive                      := 1;
    G_CLK_PERS : t_time_arr(0 to G_NUM_CLKS-1) := (others => 5 ns)
  );
  port (
    clks : out std_logic_vector(G_NUM_CLKS-1 downto 0);
    rsts : out std_logic_vector(G_NUM_CLKS-1 downto 0)
  );
end entity clk_and_rst;

architecture clk_and_rst_arch of clk_and_rst is
begin

  gen_clocks : for i in 0 to G_NUM_CLKS-1 generate

    process
    begin
      clks(i) <= '0';
      wait for G_CLK_PERS(i)/2;
      clks(i) <= '1';
      wait for G_CLK_PERS(i)/2;
    end process;

    process
    begin
      rsts(i) <= '1';
      for x in 0 to 9 loop
        wait until rising_edge(clks(i));
      end loop;
      rsts(i) <= '0';
      wait;
    end process;

  end generate gen_clocks;

end architecture clk_and_rst_arch;
