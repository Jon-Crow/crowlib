library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;

entity sim_display is
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
end entity sim_display;

architecture sim_display_arch of sim_display is

  signal px_q     : t_slv_arr(0 to G_HEIGHT-1)(G_WIDTH-1 downto 0);
  signal update_q : std_logic;

  signal vpi_tag_sim_display : std_logic := '0';

begin

  s_regs : process(all)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        px_q     <= (others => (others => '0'));
        update_q <= '0';

      else

        px_q     <= px;
        update_q <= update;

      end if;
    end if;
  end process s_regs;

end architecture sim_display_arch;
