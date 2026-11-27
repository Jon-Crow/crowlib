library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
library crowlib;
  use crowlib.common_pkg.all;

package sim_pkg is

  type t_random is protected

    procedure set_seed (
      seed : t_dword
    );

    impure function get_next     return t_dword;
    impure function get_next_uns return t_dword_uns;
    impure function get_next_sgn return t_dword_sgn;
  
  end protected t_random;

end package sim_pkg;

package body sim_pkg is

  type t_random is protected body

    variable lfsr : t_dword := (others => '0');

    procedure set_seed (
      seed : t_dword
    ) is
    begin
      lfsr := seed;
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

  end protected body t_random;

end package body sim_pkg;
