library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
use std.textio.all;

package sim_pkg is

  --------------------------------------------------------------------------------
  -- Randomization
  --------------------------------------------------------------------------------
  type t_random is protected

    procedure set_seed (
      seed : t_dword
    );

    impure function get_next      return t_dword;
    impure function get_next_uns  return t_dword_uns;
    impure function get_next_sgn  return t_dword_sgn;
    impure function get_next_real return real;
  
  end protected t_random;

  --------------------------------------------------------------------------------
  -- File I/O
  --------------------------------------------------------------------------------
  impure function f_hex_file_count_bytes(
    file_name : string
  ) return natural;

  impure function f_hex_file_read(
    file_name : string
  ) return t_byte_arr;

end package sim_pkg;

package body sim_pkg is

  --------------------------------------------------------------------------------
  -- Randomization
  --------------------------------------------------------------------------------
  type t_random is protected body

    variable lfsr : t_dword := (others => '0');

    procedure set_seed (
      seed : t_dword
    ) is
      variable prime : t_dword := (others => '0');
    begin
      lfsr := seed;
      for i in 0 to 31 loop
        prime := get_next;
      end loop;
    end procedure set_seed;

    impure function get_next return t_dword is
      variable rand     : t_dword   := (others => '0');
      variable feedback : std_logic := '0';
    begin
      rand     := lfsr;
      feedback := lfsr(0) xor lfsr(1) xor lfsr(2) xor lfsr(22);
      lfsr     :=  rand(K_DWORD_WIDTH-2 downto 0) & feedback;
      return rand;
    end function get_next;

    impure function get_next_uns return t_dword_uns is
    begin
      return unsigned(get_next);
    end function get_next_uns;

    impure function get_next_sgn return t_dword_sgn is
    begin
      return signed(get_next);
    end function get_next_sgn;

    impure function get_next_real return real is
      variable rand     : t_word_uns := (others => '0');
      variable rand_max : t_word_uns := (others => '1');
    begin
      rand := get_next_uns(K_WORD_WIDTH-1 downto 0);
      return real(to_integer(rand))/real(to_integer(rand_max));
    end function get_next_real;

  end protected body t_random;

  --------------------------------------------------------------------------------
  -- File I/O
  --------------------------------------------------------------------------------
  impure function f_hex_file_count_bytes(
    file_name : string
  ) return natural is
    file     hex_file  : text;
    variable read_line : line;
    variable read_byte : t_byte;
    variable read_ok   : boolean;
    variable count     : natural := 0;
  begin

    file_open(hex_file, file_name, read_mode);
    while not endfile(hex_file) loop
      readline(hex_file, read_line);
      loop
        hread(read_line, read_byte, read_ok);
        exit when not read_ok;
        count := count+1;
      end loop;
    end loop;
    file_close(hex_file);

    return count;

  end function f_hex_file_count_bytes;

  impure function f_hex_file_read(
    file_name : string
  ) return t_byte_arr is
    file     hex_file  : text;
    variable read_line : line;
    variable read_byte : t_byte;
    variable read_ok   : boolean;
    variable idx       : natural := 0;
    variable bytes     : t_byte_arr(0 to f_hex_file_count_bytes(file_name));
  begin

    file_open(hex_file, file_name, read_mode);
    while not endfile(hex_file) loop
      readline(hex_file, read_line);
      loop
        hread(read_line, read_byte, read_ok);
        exit when not read_ok;
        bytes(idx) := read_byte;
        idx := idx+1;
      end loop;
    end loop;
    file_close(hex_file);

    return bytes;

  end function f_hex_file_read;

end package body sim_pkg;
