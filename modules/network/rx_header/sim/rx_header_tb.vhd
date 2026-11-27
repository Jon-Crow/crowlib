library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.sim_pkg.all;
use std.env.finish;

entity rx_header_tb is
  generic (
    G_HEADER_BYTES : positive := 8;
    G_SEED         : positive := 1
  );
end entity rx_header_tb;

architecture rx_header_tb_arch of rx_header_tb is

  signal clk            : std_logic;
  signal rst            : std_logic;

  signal data_in        : t_byte;
  signal data_in_valid  : std_logic;
  signal data_in_last   : std_logic;
  signal data_in_ready  : std_logic;

  signal data_out       : t_byte;
  signal data_out_valid : std_logic;
  signal data_out_last  : std_logic;
  signal data_out_ready : std_logic;

  signal header_out     : std_logic_vector(G_HEADER_BYTES*K_BYTE_WIDTH-1 downto 0);

begin

  process
    variable rand       : t_random;
    variable bytes_sent : natural := 0;
  begin
    rand.set_seed(std_logic_vector(to_unsigned(G_SEED, K_DWORD_WIDTH)));

    wait until falling_edge(rst);

    data_out_ready <= '1';

    for i in 0 to 31 loop
      wait until rising_edge(clk);
    end loop;

    data_in       <= rand.get_next(K_BYTE_WIDTH-1 downto 0);
    data_in_valid <= '1';

    while bytes_sent < G_HEADER_BYTES + 16 loop

      if(rand.get_next_real < 0.5) then
        data_out_ready <= '1';
      else
        data_out_ready <= '0';
      end if;
      
      if(bytes_sent = G_HEADER_BYTES+15) then
        data_in_last <= '1';
      else
        data_in_last <= '0';
      end if;

      if(data_in_ready = '1') then
        data_in    <= rand.get_next(K_BYTE_WIDTH-1 downto 0);
        bytes_sent := bytes_sent + 1;
      end if;

      wait until rising_edge(clk);
    end loop;
      
    data_in_valid <= '0';

    for i in 0 to 31 loop
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

  u_dut : entity crowlib.rx_header
    generic map (
      G_HEADER_BYTES => G_HEADER_BYTES
    )
    port map (
      clk            => clk,
      rst            => rst,

      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_in_last   => data_in_last,
      data_in_ready  => data_in_ready,

      data_out       => data_out,
      data_out_valid => data_out_valid,
      data_out_last  => data_out_last,
      data_out_ready => data_out_ready,

      header_out     => header_out
  );

end architecture rx_header_tb_arch;
