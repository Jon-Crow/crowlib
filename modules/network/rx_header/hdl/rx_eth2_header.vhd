library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.network_pkg.all;

entity rx_eth2_header is
  port (
    clk            : in  std_logic;
    rst            : in  std_logic;

    data_in        : in  t_byte;
    data_in_valid  : in  std_logic;
    data_in_last   : in  std_logic;
    data_in_ready  : out std_logic;

    data_out       : out t_byte;
    data_out_valid : out std_logic;
    data_out_last  : out std_logic;
    data_out_ready : in  std_logic;

    header_out     : out t_eth2_header
  );
end entity rx_eth2_header;

architecture rx_eth2_header_arch of rx_eth2_header is

  signal eth2_hdr_slv : t_eth2_header_slv;

begin

  header_out <= f_slv_to_eth2_header(eth2_hdr_slv);

  u_rx_header : entity crowlib.rx_header
    generic map (
      G_HEADER_BYTES => K_ETH2_HEADER_BYTES
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

      header_out     => eth2_hdr_slv
  );

end architecture rx_eth2_header_arch;
