library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;

package common_pkg is

  constant K_BYTE_WIDTH  : natural := 8;
  constant K_WORD_WIDTH  : natural := 16;
  constant K_DWORD_WIDTH : natural := 32;
  constant K_QWORD_WIDTH : natural := 64;

  subtype t_byte  is std_logic_vector(K_BYTE_WIDTH-1 downto 0);
  subtype t_word  is std_logic_vector(K_WORD_WIDTH-1 downto 0);
  subtype t_dword is std_logic_vector(K_DWORD_WIDTH-1 downto 0);
  subtype t_qword is std_logic_vector(K_QWORD_WIDTH-1 downto 0);

  type t_byte_arr  is array (natural range <>) of t_byte;
  type t_word_arr  is array (natural range <>) of t_word;
  type t_dword_arr is array (natural range <>) of t_dword;
  type t_qword_arr is array (natural range <>) of t_qword;

  type t_byte_arr_2d  is array (natural range <>) of t_byte_arr;
  type t_word_arr_2d  is array (natural range <>) of t_word_arr;
  type t_dword_arr_2d is array (natural range <>) of t_dword_arr;
  type t_qword_arr_2d is array (natural range <>) of t_qword_arr;

  type t_slv_arr is array (natural range <>) of std_logic_vector;
  type t_uns_arr is array (natural range <>) of unsigned;
  type t_sgn_arr is array (natural range <>) of signed;

  type t_slv_arr_2d is array (natural range <>) of t_slv_arr;
  type t_uns_arr_2d is array (natural range <>) of t_uns_arr;
  type t_sgn_arr_2d is array (natural range <>) of t_sgn_arr;

  type t_time_arr is array (natural range <>) of time;

end package common_pkg;