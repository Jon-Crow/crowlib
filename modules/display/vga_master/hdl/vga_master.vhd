library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;
  use crowlib.display_pkg.all;

entity vga_master is
  generic (
    G_WIDTH         : positive              := 640;
    G_HEIGHT        : positive              := 480;
    G_RGB_WIDTH     : positive range 1 to 8 := 4;
    G_H_FRONT_PORCH : positive              := 16;
    G_H_SYNC        : positive              := 96;
    G_H_BACK_PORCH  : positive              := 48;
    G_V_FRONT_PORCH : positive              := 10;
    G_V_SYNC        : positive              := 2;
    G_V_BACK_PORCH  : positive              := 33
  );
  port (
    clk    : in  std_logic;
    rst    : in  std_logic;

    px_col : out std_logic_vector(integer(ceil(log2(real(G_WIDTH))))-1 downto 0);
    px_row : out std_logic_vector(integer(ceil(log2(real(G_HEIGHT))))-1 downto 0);
    px     : in  t_color;

    r      : out std_logic_vector(G_RGB_WIDTH-1 downto 0);
    g      : out std_logic_vector(G_RGB_WIDTH-1 downto 0);
    b      : out std_logic_vector(G_RGB_WIDTH-1 downto 0);
    hs     : out std_logic;
    vs     : out std_logic
  );
end entity vga_master;

architecture vga_master_arch of vga_master is

  subtype R_RGB is natural range K_BYTE_WIDTH-1 downto K_BYTE_WIDTH-G_RGB_WIDTH;

  constant K_COL_COUNTER_MAX    : natural := G_WIDTH  + G_H_FRONT_PORCH + G_H_SYNC + G_H_BACK_PORCH;
  constant K_ROW_COUNTER_MAX    : natural := G_HEIGHT + G_V_FRONT_PORCH + G_V_SYNC + G_V_BACK_PORCH;
  constant K_COL_COUNTER_WIDTH  : natural := integer(ceil(log2(real(K_COL_COUNTER_MAX))));
  constant K_ROW_COUNTER_WIDTH  : natural := integer(ceil(log2(real(K_ROW_COUNTER_MAX))));
  constant K_H_SYNC_FIRST_NAT   : natural := G_WIDTH  + G_H_FRONT_PORCH;
  constant K_H_SYNC_LAST_NAT    : natural := G_WIDTH  + G_H_FRONT_PORCH + G_H_SYNC - 1;
  constant K_V_SYNC_FIRST_NAT   : natural := G_HEIGHT + G_V_FRONT_PORCH;
  constant K_V_SYNC_LAST_NAT    : natural := G_HEIGHT + G_V_FRONT_PORCH + G_V_SYNC - 1;

  subtype t_rgb         is std_logic_vector(G_RGB_WIDTH-1 downto 0);
  subtype t_col_counter is unsigned(K_COL_COUNTER_WIDTH-1 downto 0);
  subtype t_row_counter is unsigned(K_ROW_COUNTER_WIDTH-1 downto 0);

  constant K_COL_COUNTER_TARGET : t_col_counter := to_unsigned(K_COL_COUNTER_MAX-1, K_COL_COUNTER_WIDTH);
  constant K_ROW_COUNTER_TARGET : t_row_counter := to_unsigned(K_ROW_COUNTER_MAX-1, K_ROW_COUNTER_WIDTH);
  constant K_H_SYNC_FIRST       : t_col_counter := to_unsigned(K_H_SYNC_FIRST_NAT,  K_COL_COUNTER_WIDTH);
  constant K_H_SYNC_LAST        : t_col_counter := to_unsigned(K_H_SYNC_LAST_NAT,   K_COL_COUNTER_WIDTH);
  constant K_V_SYNC_FIRST       : t_row_counter := to_unsigned(K_V_SYNC_FIRST_NAT,  K_ROW_COUNTER_WIDTH);
  constant K_V_SYNC_LAST        : t_row_counter := to_unsigned(K_V_SYNC_LAST_NAT,   K_ROW_COUNTER_WIDTH);

  signal col_cnt_d  : t_col_counter;
  signal col_cnt_q  : t_col_counter;
  signal col_cnt_2q : t_col_counter;
  signal row_cnt_d  : t_row_counter;
  signal row_cnt_q  : t_row_counter;
  signal row_cnt_2q : t_row_counter;

  signal r_d        : t_rgb;
  signal r_q        : t_rgb;
  signal g_d        : t_rgb;
  signal g_q        : t_rgb;
  signal b_d        : t_rgb;
  signal b_q        : t_rgb;
  signal hs_d       : std_logic;
  signal hs_q       : std_logic;
  signal vs_d       : std_logic;
  signal vs_q       : std_logic;

begin

  px_col <= std_logic_vector(col_cnt_q);
  px_row <= std_logic_vector(row_cnt_q);

  r  <= r_q;
  g  <= g_q;
  b  <= b_q;
  hs <= hs_q;
  vs <= vs_q;

  c_outputs : process(all)
  begin
    r_d  <= (others => '0');
    g_d  <= (others => '0');
    b_d  <= (others => '0');
    hs_d <= '0';
    vs_d <= '0';

    if(col_cnt_2q < to_unsigned(G_WIDTH, K_COL_COUNTER_WIDTH) and row_cnt_2q < to_unsigned(G_HEIGHT, K_ROW_COUNTER_WIDTH)) then
      r_d <= std_logic_vector(px.r(R_RGB));
      g_d <= std_logic_vector(px.g(R_RGB));
      b_d <= std_logic_vector(px.b(R_RGB));
    end if;

    if(col_cnt_2q >= K_H_SYNC_FIRST and col_cnt_2q <= K_H_SYNC_LAST) then
      hs_d <= '1';
    end if;

    if(row_cnt_2q >= K_V_SYNC_FIRST and row_cnt_2q <= K_V_SYNC_LAST) then
      vs_d <= '1';
    end if;
  end process c_outputs;

  c_counters : process(all)
  begin
    col_cnt_d <= col_cnt_q;
    row_cnt_d <= row_cnt_q;

    if(col_cnt_q = K_COL_COUNTER_TARGET) then
      col_cnt_d <= (others => '0');
      if(row_cnt_q = K_ROW_COUNTER_TARGET) then
        row_cnt_d <= (others => '0');
      else
        row_cnt_d <= row_cnt_q + to_unsigned(1, K_ROW_COUNTER_WIDTH);
      end if;
    else
      col_cnt_d <= col_cnt_q + to_unsigned(1, K_COL_COUNTER_WIDTH);
    end if;

  end process c_counters;

  s_regs : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        col_cnt_q  <= (others => '0');
        col_cnt_2q <= (others => '1');
        row_cnt_q  <= (others => '0');
        row_cnt_2q <= (others => '1');

        r_q        <= (others => '0');
        g_q        <= (others => '0');
        b_q        <= (others => '0');
        hs_q       <= '0';
        vs_q       <= '0';

      else

        col_cnt_q  <= col_cnt_d;
        col_cnt_2q <= col_cnt_q;
        row_cnt_q  <= row_cnt_d;
        row_cnt_2q <= row_cnt_q;

        r_q        <= r_d;
        g_q        <= g_d;
        b_q        <= b_d;
        hs_q       <= hs_d;
        vs_q       <= vs_d;

      end if;
    end if;
  end process s_regs;

end architecture vga_master_arch;
