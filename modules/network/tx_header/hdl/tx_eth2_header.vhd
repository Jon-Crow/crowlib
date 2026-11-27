library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.network_pkg.all;

entity tx_eth2_header is
  port (
    clk            : in  std_logic;
    rst            : in  std_logic;

    header_in      : in  t_eth2_header;

    data_in        : in  t_byte;
    data_in_valid  : in  std_logic;
    data_in_last   : in  std_logic;
    data_in_ready  : out std_logic;

    data_out       : out t_byte;
    data_out_valid : out std_logic;
    data_out_last  : out std_logic;
    data_out_ready : in  std_logic
  );
end entity tx_eth2_header;

architecture tx_eth2_header_arch of tx_eth2_header is

  signal eth2_hdr_slv : t_eth2_header_slv;

begin

  eth2_hdr_slv <= f_eth2_header_to_slv(header_in);

  u_tx_header : entity crowlib.tx_header
    generic map (
      G_HEADER_BYTES => K_ETH2_HEADER_BYTES
    )
    port map (
      clk            => clk,
      rst            => rst,

      header_in      => eth2_hdr_slv,

      data_in        => data_in,
      data_in_valid  => data_in_valid,
      data_in_last   => data_in_last,
      data_in_ready  => data_in_ready,

      data_out       => data_out,
      data_out_valid => data_out_valid,
      data_out_last  => data_out_last,
      data_out_ready => data_out_ready
  );

end architecture tx_eth2_header_arch;
