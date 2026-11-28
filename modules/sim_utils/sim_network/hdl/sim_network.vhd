library ieee;
  use ieee.std_logic_1164.all;
library crowlib;
  use crowlib.common_pkg.all;

entity sim_network is
  port(
    clk            : in  std_logic;
    rst            : in  std_logic;

    data_in        : in  t_byte;
    data_in_valid  : in  std_logic;
    data_in_last   : in  std_logic;
    data_in_ready  : out std_logic;

    data_out       : out t_byte;
    data_out_valid : out std_logic;
    data_out_last  : out std_logic;
    data_out_ready : in  std_logic
  );
end entity sim_network;

architecture sim_network_arch of sim_network is
begin

end architecture sim_network_arch;
