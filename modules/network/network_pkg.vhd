library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;

package network_pkg is

  constant K_MAC_ADDRESS_WIDTH : natural := 48;
  constant K_IP_ADDRESS_WIDTH  : natural := 32;
  constant K_NET_PORT_WIDTH    : natural := 16;

  subtype t_mac_addr is std_logic_vector(K_MAC_ADDRESS_WIDTH-1 downto 0);
  subtype t_ip_addr  is std_logic_vector(K_IP_ADDRESS_WIDTH-1  downto 0);
  subtype t_net_port is std_logic_vector(K_NET_PORT_WIDTH-1    downto 0);

  --------------------------------------------------------------------------------
  -- Ethernet II
  --------------------------------------------------------------------------------
  constant K_ETH2_TYPE_WIDTH : natural := 16;

  subtype t_eth2_type is std_logic_vector(K_ETH2_TYPE_WIDTH-1 downto 0);

  type t_eth2_header is record
    dst_addr : t_mac_addr;
    src_addr : t_mac_addr;
    eth_type : t_eth2_type;
  end record t_eth2_header;

  constant K_ETH2_HEADER_DEFAULT : t_eth2_header := (others => (others => '0'));

  constant K_ETH2_HEADER_WIDTH : natural := 2*K_MAC_ADDRESS_WIDTH + K_ETH2_TYPE_WIDTH;

  subtype t_eth2_header_slv is std_logic_vector(K_ETH2_HEADER_WIDTH-1 downto 0);

  function f_eth2_header_to_slv(
    hdr : t_eth2_header
  ) return t_eth2_header_slv;

  function f_slv_to_eth2_header(
    slv : t_eth2_header_slv
  ) return t_eth2_header;

  --------------------------------------------------------------------------------
  -- IPv4
  --------------------------------------------------------------------------------
  constant K_IPV4_VERSION_WIDTH         : natural := 4;
  constant K_IPV4_HEADER_LENGTH_WIDTH   : natural := 4;
  constant K_IPV4_DSCP_WIDTH            : natural := 6;
  constant K_IPV4_ECN_WIDTH             : natural := 2;
  constant K_IPV4_TOTAL_LENGTH_WIDTH    : natural := 16;
  constant K_IPV4_ID_WIDTH              : natural := 16;
  constant K_IPV4_FLAGS_WIDTH           : natural := 3;
  constant K_IPV4_FRAGMENT_OFFSET_WIDTH : natural := 13;
  constant K_IPV4_TIME_TO_LIVE_WIDTH    : natural := 8;
  constant K_IPV4_PROTOCOL_WIDTH        : natural := 8;
  constant K_IPV4_CHECKSUM_WIDTH        : natural := 16;

  subtype t_ipv4_version   is std_logic_vector(K_IPV4_VERSION_WIDTH-1         downto 0);
  subtype t_ipv4_hdr_len   is std_logic_vector(K_IPV4_HEADER_LENGTH_WIDTH-1   downto 0);
  subtype t_ipv4_dscp      is std_logic_vector(K_IPV4_DSCP_WIDTH-1            downto 0);
  subtype t_ipv4_ecn       is std_logic_vector(K_IPV4_ECN_WIDTH-1             downto 0);
  subtype t_ipv4_total_len is std_logic_vector(K_IPV4_TOTAL_LENGTH_WIDTH-1    downto 0);
  subtype t_ipv4_id        is std_logic_vector(K_IPV4_ID_WIDTH-1              downto 0);
  subtype t_ipv4_flags     is std_logic_vector(K_IPV4_FLAGS_WIDTH-1           downto 0);
  subtype t_ipv4_frag_off  is std_logic_vector(K_IPV4_FRAGMENT_OFFSET_WIDTH-1 downto 0);
  subtype t_ipv4_ttl       is std_logic_vector(K_IPV4_TIME_TO_LIVE_WIDTH-1    downto 0);
  subtype t_ipv4_protocol  is std_logic_vector(K_IPV4_PROTOCOL_WIDTH-1        downto 0);
  subtype t_ipv4_checksum  is std_logic_vector(K_IPV4_CHECKSUM_WIDTH-1        downto 0);

  type t_ipv4_header is record
    version   : t_ipv4_version;
    hdr_len   : t_ipv4_hdr_len;
    dscp      : t_ipv4_dscp;
    ecn       : t_ipv4_ecn;
    total_len : t_ipv4_total_len;
    id        : t_ipv4_id;
    flags     : t_ipv4_flags;
    frag_off  : t_ipv4_frag_off;
    ttl       : t_ipv4_ttl;
    protocol  : t_ipv4_protocol;
    checksum  : t_ipv4_checksum;
    src_addr  : t_ip_addr;
    dst_addr  : t_ip_addr;
  end record t_ipv4_header;

  constant K_IPV4_HEADER_DEFAULT : t_ipv4_header := (others => (others => '0'));

  constant K_IPV4_HEADER_WIDTH : natural := K_IPV4_VERSION_WIDTH         +
                                            K_IPV4_HEADER_LENGTH_WIDTH   +
                                            K_IPV4_DSCP_WIDTH            +
                                            K_IPV4_ECN_WIDTH             +
                                            K_IPV4_TOTAL_LENGTH_WIDTH    +
                                            K_IPV4_ID_WIDTH              +
                                            K_IPV4_FLAGS_WIDTH           +
                                            K_IPV4_FRAGMENT_OFFSET_WIDTH +
                                            K_IPV4_TIME_TO_LIVE_WIDTH    +
                                            K_IPV4_PROTOCOL_WIDTH        +
                                            K_IPV4_CHECKSUM_WIDTH        +
                                            2*K_IP_ADDRESS_WIDTH;

  subtype t_ipv4_header_slv is std_logic_vector(K_IPV4_HEADER_WIDTH-1 downto 0);

  function f_ipv4_header_to_slv(
    hdr : t_ipv4_header
  ) return t_ipv4_header_slv;

  function f_slv_to_ipv4_header(
    slv : t_ipv4_header_slv
  ) return t_ipv4_header;

end package network_pkg;

package body network_pkg is

  --------------------------------------------------------------------------------
  -- Ethernet II
  --------------------------------------------------------------------------------
  function f_eth2_header_to_slv(
    hdr : t_eth2_header
  ) return t_eth2_header_slv is
  begin
    return hdr.dst_addr &
           hdr.src_addr &
           hdr.eth_type;
  end function f_eth2_header_to_slv;

  function f_slv_to_eth2_header(
    slv : t_eth2_header_slv
  ) return t_eth2_header is
    variable hdr : t_eth2_header := K_ETH2_HEADER_DEFAULT;
  begin
    hdr.eth_type := slv(K_ETH2_TYPE_WIDTH-1 downto 0);
    hdr.src_addr := slv(K_MAC_ADDRESS_WIDTH+K_ETH2_TYPE_WIDTH-1 downto K_ETH2_TYPE_WIDTH);
    hdr.dst_addr := slv(2*K_MAC_ADDRESS_WIDTH+K_ETH2_TYPE_WIDTH-1 downto K_MAC_ADDRESS_WIDTH+K_ETH2_TYPE_WIDTH);
    return hdr;
  end function f_slv_to_eth2_header;

  --------------------------------------------------------------------------------
  -- IPv4
  --------------------------------------------------------------------------------
  function f_ipv4_header_to_slv(
    hdr : t_ipv4_header
  ) return t_ipv4_header_slv is
  begin
    return hdr.version   &
           hdr.hdr_len   &
           hdr.dscp      &
           hdr.ecn       &
           hdr.total_len &
           hdr.id        &
           hdr.flags     &
           hdr.frag_off  &
           hdr.ttl       &
           hdr.protocol  &
           hdr.checksum  &
           hdr.src_addr  &
           hdr.dst_addr;
  end function f_ipv4_header_to_slv;

  function f_slv_to_ipv4_header(
    slv : t_ipv4_header_slv
  ) return t_ipv4_header is
    variable hdr : t_ipv4_header := K_IPV4_HEADER_DEFAULT;
    variable idx : natural       := 0;
  begin
    hdr.dst_addr := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.src_addr := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.checksum := slv(idx+K_IPV4_CHECKSUM_WIDTH-1 downto idx);
    idx := idx + K_IPV4_CHECKSUM_WIDTH;

    hdr.protocol := slv(idx+K_IPV4_PROTOCOL_WIDTH-1 downto idx);
    idx := idx + K_IPV4_PROTOCOL_WIDTH;

    hdr.ttl := slv(idx+K_IPV4_TIME_TO_LIVE_WIDTH-1 downto idx);
    idx := idx + K_IPV4_TIME_TO_LIVE_WIDTH;

    hdr.frag_off := slv(idx+K_IPV4_FRAGMENT_OFFSET_WIDTH-1 downto idx);
    idx := idx + K_IPV4_FRAGMENT_OFFSET_WIDTH;

    hdr.flags := slv(idx+K_IPV4_FLAGS_WIDTH-1 downto idx);
    idx := idx + K_IPV4_FLAGS_WIDTH;

    hdr.id := slv(idx+K_IPV4_ID_WIDTH-1 downto idx);
    idx := idx + K_IPV4_ID_WIDTH;

    hdr.total_len := slv(idx+K_IPV4_TOTAL_LENGTH_WIDTH-1 downto idx);
    idx := idx + K_IPV4_TOTAL_LENGTH_WIDTH;

    hdr.ecn := slv(idx+K_IPV4_ECN_WIDTH-1 downto idx);
    idx := idx + K_IPV4_ECN_WIDTH;

    hdr.dscp := slv(idx+K_IPV4_DSCP_WIDTH-1 downto idx);
    idx := idx + K_IPV4_DSCP_WIDTH;

    hdr.hdr_len := slv(idx+K_IPV4_HEADER_LENGTH_WIDTH-1 downto idx);
    idx := idx + K_IPV4_HEADER_LENGTH_WIDTH;

    hdr.version := slv(idx+K_IPV4_VERSION_WIDTH-1 downto idx);

    return hdr;
  end function f_slv_to_ipv4_header;

end package body network_pkg;
