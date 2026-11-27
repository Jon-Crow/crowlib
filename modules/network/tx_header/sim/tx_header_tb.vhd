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

  constant K_MAC_ADDRESS : t_mac_addr := x"FC9D050293FA";
  constant K_PACKET_DATA : t_byte_arr := f_hex_file_read("dhcp_packet.txt");

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

  eth2_header_in <= (
    dst_addr => x"FFFFFFFFFFFF",
    src_addr => K_MAC_ADDRESS,
    eth_type => K_ETH2_TYPE_IPV4
  );

  ipv4_header_in <= (
    version   => x"4",
    hdr_len   => x"5",
    dscp      => (others => '0'),
    ecn       => (others => '0'),
    total_len => x"0148",
    id        => x"D41E",
    flags     => (others => '0'),
    frag_off  => (others => '0'),
    ttl       => x"80",
    protocol  => K_IPV4_PROTOCOL_UDP,
    checksum  => (others => '0'),
    src_addr  => (others => '0'),
    dst_addr  => (others => '1')
  );

  udp_header_in  <= (
    src_port => x"0044",
    dst_port => x"0043",
    length   => x"0134",
    checksum => x"F236"
  );

  dhcp_header_in <= (
    msg_type    => x"01",
    hw_type     => x"01",
    hw_addr_len => x"06",
    hops        => (others => '0'),
    trans_id    => x"D8FA822B",
    secs        => (others => '0'),
    flags       => (others => '0'),
    client_ip   => (others => '0'),
    your_ip     => (others => '0'),
    server_ip   => (others => '0'),
    relay_ip    => (others => '0'),
    client_addr => (R_DHCP_CLIENT_ADDRESS_MAC => K_MAC_ADDRESS, R_DHCP_CLIENT_ADDRESS_MAC_PAD => '0'),
    server_name => (others => '0'),
    boot_name   => (others => '0'),
    cookie      => K_DHCP_MAGIC_COOKIE_DEFAULT
  );

  process
  begin
    for i in 0 to 9999 loop
      wait until rising_edge(clk);
    end loop;
    finish;
  end process;

  process
    variable pkt_idx : natural := 0;
  begin
    wait until falling_edge(rst);

    data_in       <= (others => '0');
    data_in_valid <= '0';
    data_in_last  <= '0';

    for i in 0 to 31 loop
      wait until rising_edge(clk);
    end loop;

    data_in_valid <= '1';

    for i in 0 to K_PACKET_DATA'length-1 loop
      data_in <= K_PACKET_DATA(pkt_idx);
      if(i = K_PACKET_DATA'length-1) then
        data_in_last <= '1';
      else
        data_in_last <= '0';
      end if;
      wait until rising_edge(clk) and data_in_ready = '1';
      pkt_idx := pkt_idx+1;
    end loop;

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
