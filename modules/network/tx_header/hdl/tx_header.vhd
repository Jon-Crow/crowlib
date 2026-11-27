library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;
  use ieee.math_real.all;
library crowlib;
  use crowlib.common_pkg.all;

entity tx_header is
  generic (
    G_HEADER_BYTES : positive := 8
  );
  port (
    clk            : in  std_logic;
    rst            : in  std_logic;

    header_in      : in  std_logic_vector(G_HEADER_BYTES*K_BYTE_WIDTH-1 downto 0);

    data_in        : in  t_byte;
    data_in_valid  : in  std_logic;
    data_in_last   : in  std_logic;
    data_in_ready  : out std_logic;

    data_out       : out t_byte;
    data_out_valid : out std_logic;
    data_out_last  : out std_logic;
    data_out_ready : in  std_logic
  );
end entity tx_header;

architecture tx_header_arch of tx_header is

  constant K_HEADER_WIDTH     : natural := G_HEADER_BYTES*K_BYTE_WIDTH;
  constant K_BYTE_COUNT_WIDTH : natural := integer(ceil(log2(real(G_HEADER_BYTES))));

  subtype t_byte_counter is unsigned(K_BYTE_COUNT_WIDTH-1 downto 0);
  subtype t_header       is std_logic_vector(K_HEADER_WIDTH-1 downto 0);

  constant K_BYTE_COUNT_TARGET : t_byte_counter := to_unsigned(G_HEADER_BYTES-1, K_BYTE_COUNT_WIDTH);

  type t_state is (
    S_IDLE,
    S_HEADER,
    S_PAYLOAD
  );

  signal data_in_d         : t_byte;
  signal data_in_q         : t_byte;
  signal data_in_valid_d   : std_logic;
  signal data_in_valid_q   : std_logic;
  signal data_in_last_d    : std_logic;
  signal data_in_last_q    : std_logic;

  signal data_in_ready_int : std_logic;

  signal state_d           : t_state;
  signal state_q           : t_state;
  signal byte_cnt_d        : t_byte_counter;
  signal byte_cnt_q        : t_byte_counter;
  signal header_d          : t_header;
  signal header_q          : t_header;

begin

  c_data_in : process(all)
  begin
    data_in_d       <= data_in_q;
    data_in_valid_d <= data_in_valid_q;
    data_in_last_d  <= data_in_last_q;

    if(data_in_ready_int = '1') then
      data_in_d       <= data_in;
      data_in_valid_d <= data_in_valid;
      data_in_last_d  <= data_in_last;
    end if;

  end process c_data_in;

  c_fsm : process(all)
  begin
    state_d    <= state_q;
    byte_cnt_d <= byte_cnt_q;
    header_d   <= header_q;

    data_in_ready_int <= '0';

    data_out       <= (others => '0');
    data_out_valid <= '0';
    data_out_last  <= '0';

    case(state_q) is
      when S_IDLE =>
        if(data_in_valid_q = '1') then
          state_d <= S_HEADER;
        else
          data_in_ready_int <= '1';
        end if;

        byte_cnt_d <= (others => '0');
        header_d   <= header_in;

      when S_HEADER =>
        if(data_out_ready = '1') then
          if(byte_cnt_q = K_BYTE_COUNT_TARGET) then
            state_d <= S_PAYLOAD;
          else
            byte_cnt_d <= byte_cnt_q + to_unsigned(1, K_BYTE_COUNT_WIDTH);
            header_d   <= header_q(K_HEADER_WIDTH-K_BYTE_WIDTH-1 downto 0) & x"00";
          end if;
        end if;

        data_out       <= header_q(K_HEADER_WIDTH-1 downto K_HEADER_WIDTH-K_BYTE_WIDTH);
        data_out_valid <= '1';
        data_out_last  <= '0';

      when S_PAYLOAD =>
        if(data_in_valid_q = '1' and data_in_last_q = '1' and data_out_ready = '1') then
          state_d <= S_IDLE;
        end if;

        data_in_ready_int <= '1';

        data_out       <= data_in_q;
        data_out_valid <= data_in_valid_q;
        data_out_last  <= data_in_last_q;

      when others => null;
    end case;
  end process c_fsm;

  s_regs : process(clk)
  begin
    if(rising_edge(clk)) then
      if(rst = '1') then

        data_in_valid_q <= '0';

        state_q         <= S_IDLE;
        byte_cnt_q      <= (others => '0');

      else

        data_in_q       <= data_in_d;
        data_in_valid_q <= data_in_valid_d;
        data_in_last_q  <= data_in_last_d;

        state_q         <= state_d;
        byte_cnt_q      <= byte_cnt_d;
        header_q        <= header_d;

      end if;
    end if;
  end process s_regs;

end architecture tx_header_arch;
