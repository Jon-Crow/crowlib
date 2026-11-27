library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.network_pkg.all;
  use crowlib.sim_pkg.all;
use std.env.finish;
use std.textio.all;

entity rx_header_packet_tb is
  generic (
    G_INPUT_FILE : string := "udp_packet.txt"
  );
end entity rx_header_packet_tb;

architecture rx_header_packet_tb_arch of rx_header_packet_tb is

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

  signal eth2_header_out     : t_eth2_header;
  signal ipv4_header_out     : t_ipv4_header;
  signal udp_header_out      : t_udp_header;

begin

  udp_data_out_ready <= '1';

  process
  begin
    for i in 0 to 1999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

  process
    file     pkt_file  : text open read_mode is G_INPUT_FILE;
    variable read_line : line;
    variable read_byte : t_byte;
    variable read_ok   : boolean;
  begin
    wait until falling_edge(rst);

    data_in       <= (others => '0');
    data_in_valid <= '0';
    data_in_last  <= '0';

    for i in 0 to 31 loop
      wait until rising_edge(clk);
    end loop;

    data_in_valid <= '1';

    while not endfile(pkt_file) loop
      readline(pkt_file, read_line);
      hread(read_line, read_byte, read_ok);
      next when not read_ok;

      data_in <= read_byte;
      if(endfile(pkt_file)) then
        data_in_last <= '1';
      else
        data_in_last <= '0';
      end if;

      wait until rising_edge(clk) and data_in_ready = '1';
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

  u_eth2 : entity crowlib.rx_eth2_header
    port map (
      clk            => clk,
      rst            => rst,

      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_in_last   => data_in_last,
      data_in_ready  => data_in_ready,

      data_out       => eth2_data_out,
      data_out_valid => eth2_data_out_valid,
      data_out_last  => eth2_data_out_last,
      data_out_ready => eth2_data_out_ready,

      header_out     => eth2_header_out
  );

  u_ipv4 : entity crowlib.rx_ipv4_header
    port map (
      clk            => clk,
      rst            => rst,

      data_in        => eth2_data_out,
      data_in_valid  => eth2_data_out_valid,
      data_in_last   => eth2_data_out_last,
      data_in_ready  => eth2_data_out_ready,

      data_out       => ipv4_data_out,
      data_out_valid => ipv4_data_out_valid,
      data_out_last  => ipv4_data_out_last,
      data_out_ready => ipv4_data_out_ready,

      header_out     => ipv4_header_out
  );

  u_udp : entity crowlib.rx_udp_header
    port map (
      clk            => clk,
      rst            => rst,

      data_in        => ipv4_data_out,
      data_in_valid  => ipv4_data_out_valid,
      data_in_last   => ipv4_data_out_last,
      data_in_ready  => ipv4_data_out_ready,

      data_out       => udp_data_out,
      data_out_valid => udp_data_out_valid,
      data_out_last  => udp_data_out_last,
      data_out_ready => udp_data_out_ready,

      header_out     => udp_header_out
  );

end architecture rx_header_packet_tb_arch;
