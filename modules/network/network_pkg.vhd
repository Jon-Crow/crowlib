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
  constant K_ETH2_HEADER_BYTES : natural := K_ETH2_HEADER_WIDTH/K_BYTE_WIDTH;

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
  constant K_IPV4_HEADER_BYTES : natural := K_IPV4_HEADER_WIDTH/K_BYTE_WIDTH;

  subtype t_ipv4_header_slv is std_logic_vector(K_IPV4_HEADER_WIDTH-1 downto 0);

  function f_ipv4_header_to_slv(
    hdr : t_ipv4_header
  ) return t_ipv4_header_slv;

  function f_slv_to_ipv4_header(
    slv : t_ipv4_header_slv
  ) return t_ipv4_header;

  --------------------------------------------------------------------------------
  -- UDP
  --------------------------------------------------------------------------------
  constant K_UDP_LENGTH_WIDTH   : natural := 16;
  constant K_UDP_CHECKSUM_WIDTH : natural := 16;

  subtype t_udp_length   is std_logic_vector(K_UDP_LENGTH_WIDTH-1   downto 0);
  subtype t_udp_checksum is std_logic_vector(K_UDP_CHECKSUM_WIDTH-1 downto 0);

  type t_udp_header is record
    src_port : t_net_port;
    dst_port : t_net_port;
    length   : t_udp_length;
    checksum : t_udp_checksum;
  end record t_udp_header;

  constant K_UDP_HEADER_DEFAULT : t_udp_header := (others => (others => '0'));

  constant K_UDP_HEADER_WIDTH : natural := K_UDP_LENGTH_WIDTH   +
                                           K_UDP_CHECKSUM_WIDTH +
                                           2*K_NET_PORT_WIDTH;
  constant K_UDP_HEADER_BYTES : natural := K_UDP_HEADER_WIDTH/K_BYTE_WIDTH;

  subtype t_udp_header_slv is std_logic_vector(K_UDP_HEADER_WIDTH-1 downto 0);

  function f_udp_header_to_slv(
    hdr : t_udp_header
  ) return t_udp_header_slv;

  function f_slv_to_udp_header(
    slv : t_udp_header_slv
  ) return t_udp_header;


  --------------------------------------------------------------------------------
  -- DHCP
  --------------------------------------------------------------------------------
  constant K_DHCP_MESSAGE_TYPE_WIDTH            : natural := 8;
  constant K_DHCP_HARDWARE_TYPE_WIDTH           : natural := 8;
  constant K_DHCP_HARDWARE_ADDRESS_LENGTH_WIDTH : natural := 8;
  constant K_DHCP_HOPS_WIDTH                    : natural := 8;
  constant K_DHCP_TRANSACTION_ID_WIDTH          : natural := 32;
  constant K_DHCP_SECONDS_WIDTH                 : natural := 16;
  constant K_DHCP_FLAGS_WIDTH                   : natural := 16;
  constant K_DHCP_CLIENT_ADDRESS_WIDTH          : natural := 128;
  constant K_DHCP_SERVER_HOST_NAME_WIDTH        : natural := 512;
  constant K_DHCP_BOOT_FILE_NAME_WIDTH          : natural := 1024;

  subtype t_dhcp_msg_type    is std_logic_vector(K_DHCP_MESSAGE_TYPE_WIDTH-1            downto 0);
  subtype t_dhcp_hw_type     is std_logic_vector(K_DHCP_HARDWARE_TYPE_WIDTH-1           downto 0);
  subtype t_dhcp_hw_addr_len is std_logic_vector(K_DHCP_HARDWARE_ADDRESS_LENGTH_WIDTH-1 downto 0);
  subtype t_dhcp_hops        is std_logic_vector(K_DHCP_HOPS_WIDTH-1                    downto 0);
  subtype t_dhcp_trans_id    is std_logic_vector(K_DHCP_TRANSACTION_ID_WIDTH-1          downto 0);
  subtype t_dhcp_secs        is std_logic_vector(K_DHCP_SECONDS_WIDTH-1                 downto 0);
  subtype t_dhcp_flags       is std_logic_vector(K_DHCP_FLAGS_WIDTH-1                   downto 0);
  subtype t_dhcp_client_addr is std_logic_vector(K_DHCP_CLIENT_ADDRESS_WIDTH-1          downto 0);
  subtype t_dhcp_server_name is std_logic_vector(K_DHCP_SERVER_HOST_NAME_WIDTH-1        downto 0);
  subtype t_dhcp_boot_name   is std_logic_vector(K_DHCP_BOOT_FILE_NAME_WIDTH-1          downto 0);

  type t_dhcp_header is record
    msg_type    : t_dhcp_msg_type;
    hw_type     : t_dhcp_hw_type;
    hw_addr_len : t_dhcp_hw_addr_len;
    hops        : t_dhcp_hops;
    trans_id    : t_dhcp_trans_id;
    secs        : t_dhcp_secs;
    flags       : t_dhcp_flags;
    client_ip   : t_ip_addr;
    your_ip     : t_ip_addr;
    server_ip   : t_ip_addr;
    relay_ip    : t_ip_addr;
    client_addr : t_dhcp_client_addr;
    server_name : t_dhcp_server_name;
    boot_name   : t_dhcp_boot_name;
  end record t_dhcp_header;

  constant K_DHCP_HEADER_DEFAULT : t_dhcp_header := (others => (others => '0'));

  constant K_DHCP_HEADER_WIDTH : natural := K_DHCP_MESSAGE_TYPE_WIDTH            +
                                            K_DHCP_HARDWARE_TYPE_WIDTH           +
                                            K_DHCP_HARDWARE_ADDRESS_LENGTH_WIDTH +
                                            K_DHCP_HOPS_WIDTH                    +
                                            K_DHCP_TRANSACTION_ID_WIDTH          +
                                            K_DHCP_SECONDS_WIDTH                 +
                                            K_DHCP_FLAGS_WIDTH                   +
                                            4*K_IP_ADDRESS_WIDTH                 +
                                            K_DHCP_CLIENT_ADDRESS_WIDTH          +
                                            K_DHCP_SERVER_HOST_NAME_WIDTH        +
                                            K_DHCP_BOOT_FILE_NAME_WIDTH;
  constant K_DHCP_HEADER_BYTES : natural := K_DHCP_HEADER_WIDTH/K_BYTE_WIDTH;

  subtype t_dhcp_header_slv is std_logic_vector(K_DHCP_HEADER_WIDTH-1 downto 0);

  function f_dhcp_header_to_slv(
    hdr : t_dhcp_header
  ) return t_dhcp_header_slv;

  function f_slv_to_dhcp_header(
    slv : t_dhcp_header_slv
  ) return t_dhcp_header;

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
    variable idx : natural       := 0;
  begin
    hdr.eth_type := slv(idx+K_ETH2_TYPE_WIDTH-1 downto idx);
    idx := idx + K_ETH2_TYPE_WIDTH;

    hdr.src_addr := slv(idx+K_MAC_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_MAC_ADDRESS_WIDTH;

    hdr.dst_addr := slv(idx+K_MAC_ADDRESS_WIDTH-1 downto idx);

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


  --------------------------------------------------------------------------------
  -- UDP
  --------------------------------------------------------------------------------
  function f_udp_header_to_slv(
    hdr : t_udp_header
  ) return t_udp_header_slv is
  begin
    return hdr.src_port &
           hdr.dst_port &
           hdr.length   &
           hdr.checksum;
  end function f_udp_header_to_slv;

  function f_slv_to_udp_header(
    slv : t_udp_header_slv
  ) return t_udp_header is
    variable hdr : t_udp_header := K_UDP_HEADER_DEFAULT;
    variable idx : natural      := 0;
  begin
    hdr.checksum := slv(idx+K_UDP_CHECKSUM_WIDTH-1 downto idx);
    idx := idx + K_UDP_CHECKSUM_WIDTH;

    hdr.length := slv(idx+K_UDP_LENGTH_WIDTH-1 downto idx);
    idx := idx + K_UDP_LENGTH_WIDTH;

    hdr.dst_port := slv(idx+K_NET_PORT_WIDTH-1 downto idx);
    idx := idx + K_NET_PORT_WIDTH;

    hdr.src_port := slv(idx+K_NET_PORT_WIDTH-1 downto idx);

    return hdr;
  end function f_slv_to_udp_header;


  --------------------------------------------------------------------------------
  -- DHCP
  --------------------------------------------------------------------------------
  function f_dhcp_header_to_slv(
    hdr : t_dhcp_header
  ) return t_dhcp_header_slv is
  begin
    return hdr.msg_type    &
           hdr.hw_type     &
           hdr.hw_addr_len &
           hdr.hops        &
           hdr.trans_id    &
           hdr.secs        &
           hdr.flags       &
           hdr.client_ip   &
           hdr.your_ip     &
           hdr.server_ip   &
           hdr.relay_ip    &
           hdr.client_addr &
           hdr.server_name &
           hdr.boot_name;
  end function f_dhcp_header_to_slv;

  function f_slv_to_dhcp_header(
    slv : t_dhcp_header_slv
  ) return t_dhcp_header is
    variable hdr : t_dhcp_header := K_DHCP_HEADER_DEFAULT;
    variable idx : natural       := 0;
  begin
    hdr.boot_name := slv(idx+K_DHCP_BOOT_FILE_NAME_WIDTH-1 downto idx);
    idx := idx + K_DHCP_BOOT_FILE_NAME_WIDTH;

    hdr.server_name := slv(idx+K_DHCP_SERVER_HOST_NAME_WIDTH-1 downto idx);
    idx := idx + K_DHCP_SERVER_HOST_NAME_WIDTH;

    hdr.client_addr := slv(idx+K_DHCP_CLIENT_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_DHCP_CLIENT_ADDRESS_WIDTH;

    hdr.relay_ip := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.server_ip := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.your_ip := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.client_ip := slv(idx+K_IP_ADDRESS_WIDTH-1 downto idx);
    idx := idx + K_IP_ADDRESS_WIDTH;

    hdr.flags := slv(idx+K_DHCP_FLAGS_WIDTH-1 downto idx);
    idx := idx + K_DHCP_FLAGS_WIDTH;

    hdr.secs := slv(idx+K_DHCP_SECONDS_WIDTH-1 downto idx);
    idx := idx + K_DHCP_SECONDS_WIDTH;

    hdr.trans_id := slv(idx+K_DHCP_TRANSACTION_ID_WIDTH-1 downto idx);
    idx := idx + K_DHCP_TRANSACTION_ID_WIDTH;

    hdr.hops := slv(idx+K_DHCP_HOPS_WIDTH-1 downto idx);
    idx := idx + K_DHCP_HOPS_WIDTH;

    hdr.hw_addr_len := slv(idx+K_DHCP_HARDWARE_ADDRESS_LENGTH_WIDTH-1 downto idx);
    idx := idx + K_DHCP_HARDWARE_ADDRESS_LENGTH_WIDTH;

    hdr.hw_type := slv(idx+K_DHCP_HARDWARE_TYPE_WIDTH-1 downto idx);
    idx := idx + K_DHCP_HARDWARE_TYPE_WIDTH;

    hdr.msg_type := slv(idx+K_DHCP_MESSAGE_TYPE_WIDTH-1 downto idx);

    return hdr;
  end function f_slv_to_dhcp_header;

end package body network_pkg;
