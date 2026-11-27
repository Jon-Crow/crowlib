library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.network_pkg.all;
  use crowlib.sim_pkg.all;
use std.env.finish;

entity tx_header_tb is
end entity tx_header_tb;

architecture tx_header_tb_arch of tx_header_tb is

  signal clk                 : std_logic;
  signal rst                 : std_logic;

  signal data_in             : t_byte;
  signal data_in_valid       : std_logic;
  signal data_in_last        : std_logic;
  signal data_in_ready       : std_logic;

  signal eth2_data_out       : t_byte;
  signal eth2_data_out_valid : std_logic;
  signal eth2_data_out_last  : std_logic;
  signal eth2_data_out_ready : std_logic;

  signal ipv4_data_out       : t_byte;
  signal ipv4_data_out_valid : std_logic;
  signal ipv4_data_out_last  : std_logic;
  signal ipv4_data_out_ready : std_logic;

  signal udp_data_out        : t_byte;
  signal udp_data_out_valid  : std_logic;
  signal udp_data_out_last   : std_logic;
  signal udp_data_out_ready  : std_logic;

  signal dhcp_data_out       : t_byte;
  signal dhcp_data_out_valid : std_logic;
  signal dhcp_data_out_last  : std_logic;
  signal dhcp_data_out_ready : std_logic;

  signal eth2_header_in      : t_eth2_header;
  signal ipv4_header_in      : t_ipv4_header;
  signal udp_header_in       : t_udp_header;
  signal dhcp_header_in      : t_dhcp_header;

begin

  dhcp_data_out_ready <= '1';

  eth2_header_in <= K_ETH2_HEADER_DEFAULT;
  ipv4_header_in <= K_IPV4_HEADER_DEFAULT;
  udp_header_in  <= K_UDP_HEADER_DEFAULT;
  dhcp_header_in <= K_DHCP_HEADER_DEFAULT;

  process
  begin
    for i in 0 to 9999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

  process
  begin
    data_in       <= (others => '0');
    data_in_valid <= '0';
    data_in_last  <= '0';

    wait until falling_edge(rst);

    for i in 0 to 31 loop
      wait until rising_edge(clk);
    end loop;

    data_in       <= x"55";
    data_in_valid <= '1';

    wait until rising_edge(clk) and data_in_ready = '1';

    data_in       <= x"AA";
    data_in_last  <= '1';

    wait until rising_edge(clk) and data_in_ready = '1';

    data_in       <= (others => '0');
    data_in_valid <= '0';
    data_in_last  <= '0';

    wait until rising_edge(clk) and dhcp_data_out_valid = '1' and dhcp_data_out_last = '1';

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

  u_eth2 : entity crowlib.tx_eth2_header
    port map (
      clk            => clk,
      rst            => rst,

      header_in      => eth2_header_in,

      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_in_last   => data_in_last,
      data_in_ready  => data_in_ready,

      data_out       => eth2_data_out,
      data_out_valid => eth2_data_out_valid,
      data_out_last  => eth2_data_out_last,
      data_out_ready => eth2_data_out_ready
  );

  u_ipv4 : entity crowlib.tx_ipv4_header
    port map (
      clk            => clk,
      rst            => rst,

      header_in      => ipv4_header_in,

      data_in        => eth2_data_out,
      data_in_valid  => eth2_data_out_valid,
      data_in_last   => eth2_data_out_last,
      data_in_ready  => eth2_data_out_ready,

      data_out       => ipv4_data_out,
      data_out_valid => ipv4_data_out_valid,
      data_out_last  => ipv4_data_out_last,
      data_out_ready => ipv4_data_out_ready
  );

  u_udp : entity crowlib.tx_udp_header
    port map (
      clk            => clk,
      rst            => rst,

      header_in      => udp_header_in,

      data_in        => ipv4_data_out,
      data_in_valid  => ipv4_data_out_valid,
      data_in_last   => ipv4_data_out_last,
      data_in_ready  => ipv4_data_out_ready,

      data_out       => udp_data_out,
      data_out_valid => udp_data_out_valid,
      data_out_last  => udp_data_out_last,
      data_out_ready => udp_data_out_ready
  );

  u_dhcp : entity crowlib.tx_dhcp_header
    port map (
      clk            => clk,
      rst            => rst,

      header_in      => dhcp_header_in,

      data_in        => udp_data_out,
      data_in_valid  => udp_data_out_valid,
      data_in_last   => udp_data_out_last,
      data_in_ready  => udp_data_out_ready,

      data_out       => dhcp_data_out,
      data_out_valid => dhcp_data_out_valid,
      data_out_last  => dhcp_data_out_last,
      data_out_ready => dhcp_data_out_ready
  );

end architecture tx_header_tb_arch;
