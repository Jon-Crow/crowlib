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

  function f_count_ones_slv (
    slv : std_logic_vector
  ) return natural;

  function f_count_ones_uns (
    uns : unsigned
  ) return natural;

  function f_count_ones_sgn (
    sgn : signed
  ) return natural;

end package common_pkg;

package body common_pkg is

  function f_count_ones_slv (
    slv : std_logic_vector
  ) return natural is
    variable count : natural := 0;
  begin
    for i in slv'range loop
      if(slv(i) = '1') then
        count := count + 1;
      end if;
    end loop;

    return count;
  end function f_count_ones_slv;

  function f_count_ones_uns (
    uns : unsigned
  ) return natural is
  begin
    return f_count_ones_slv(std_logic_vector(uns));
  end function f_count_ones_uns;

  function f_count_ones_sgn (
    sgn : signed
  ) return natural is
  begin
    return f_count_ones_slv(std_logic_vector(sgn));
  end function f_count_ones_sgn;

end package body common_pkg;
