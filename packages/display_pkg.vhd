library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;

package display_pkg is

  type t_color is record
    r : t_byte_uns;
    g : t_byte_uns;
    b : t_byte_uns;
    a : t_byte_uns;
  end record t_color;

  type t_color_real is record
    r : real;
    g : real;
    b : real;
    a : real;
  end record t_color_real;

  constant K_COLOR_WIDTH : natural := 4*K_BYTE_WIDTH;

  subtype t_color_slv is std_logic_vector(K_COLOR_WIDTH-1 downto 0);

  constant K_COLOR_DEFAULT      : t_color      := (others => (others => '0'));
  constant K_COLOR_REAL_DEFAULT : t_color_real := (others => 0.0);

  constant K_COLOR_RED : t_color := (
    r => (others => '1'),
    g => (others => '0'),
    b => (others => '0'),
    a => (others => '1')
  );
  constant K_COLOR_GREEN : t_color := (
    r => (others => '0'),
    g => (others => '1'),
    b => (others => '0'),
    a => (others => '1')
  );
  constant K_COLOR_BLUE : t_color := (
    r => (others => '0'),
    g => (others => '0'),
    b => (others => '1'),
    a => (others => '1')
  );
  constant K_COLOR_WHITE : t_color := (
    r => (others => '1'),
    g => (others => '1'),
    b => (others => '1'),
    a => (others => '1')
  );
  constant K_COLOR_BLACK : t_color := (
    r => (others => '0'),
    g => (others => '0'),
    b => (others => '0'),
    a => (others => '1')
  );

  type t_color_arr      is array (natural range <>) of t_color;
  type t_color_real_arr is array (natural range <>) of t_color_real;
  type t_color_slv_arr  is array (natural range <>) of t_color_slv;

  type t_color_arr_2d      is array (natural range <>) of t_color_arr;
  type t_color_real_arr_2d is array (natural range <>) of t_color_real_arr;
  type t_color_slv_arr_2d  is array (natural range <>) of t_color_slv_arr;

  function f_color_to_slv(
    clr : t_color
  ) return t_color_slv;

  function f_slv_to_color(
    slv : t_color_slv
  ) return t_color;

  function f_color_real_to_color(
    clr_real : t_color_real
  ) return t_color;

  function f_blend_color(
    bg : t_color;
    fg : t_color
  ) return t_color;

end package display_pkg;

package body display_pkg is

  function f_color_to_slv(
    clr : t_color
  ) return t_color_slv is
    variable slv : t_color_slv := (others => '0');
  begin
    slv := std_logic_vector(clr.r) &
           std_logic_vector(clr.g) &
           std_logic_vector(clr.b) &
           std_logic_vector(clr.a);
    return slv;
  end function f_color_to_slv;

  function f_slv_to_color(
    slv : t_color_slv
  ) return t_color is
    variable clr : t_color := K_COLOR_DEFAULT;
  begin
    clr.a := unsigned(slv(K_BYTE_WIDTH-1   downto 0));
    clr.b := unsigned(slv(2*K_BYTE_WIDTH-1 downto K_BYTE_WIDTH));
    clr.g := unsigned(slv(3*K_BYTE_WIDTH-1 downto 2*K_BYTE_WIDTH));
    clr.r := unsigned(slv(4*K_BYTE_WIDTH-1 downto 3*K_BYTE_WIDTH));
    return clr;
  end function f_slv_to_color;

  function f_color_real_to_color(
    clr_real : t_color_real
  ) return t_color is
    variable clr : t_color := K_COLOR_DEFAULT;
  begin
    clr.r := to_unsigned(integer(round(clr_real.r)), K_BYTE_WIDTH);
    clr.g := to_unsigned(integer(round(clr_real.g)), K_BYTE_WIDTH);
    clr.b := to_unsigned(integer(round(clr_real.b)), K_BYTE_WIDTH);
    clr.a := to_unsigned(integer(round(clr_real.a)), K_BYTE_WIDTH);
    return clr;
  end function f_color_real_to_color;

  function f_blend_color(
    bg : t_color;
    fg : t_color
  ) return t_color is
    variable alpha : real         := 0.0;
    variable clr   : t_color_real := K_COLOR_REAL_DEFAULT;
  begin
    alpha := real(to_integer(fg.a))/real(K_BYTE_UNS_MAX);
    clr.r := real(to_integer(fg.r))*alpha + real(to_integer(bg.r))*(1.0-alpha);
    clr.g := real(to_integer(fg.g))*alpha + real(to_integer(bg.g))*(1.0-alpha);
    clr.b := real(to_integer(fg.b))*alpha + real(to_integer(bg.b))*(1.0-alpha);
    clr.a := 1.0;

    return f_color_real_to_color(clr);
  end function f_blend_color;

end package body display_pkg;
