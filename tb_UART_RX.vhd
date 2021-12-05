library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD. ALL;
entity tb_UART_RX is
end entity;
------------------CONNECTION-------------------------
architecture Behavioral of tb_UART_RX is
component UART_RX is 
generic (n_bitsdata :positive := 8);
port(
		clk:          in std_logic;
		reset:        in std_logic;
		rx_d:         in std_logic;
		data_package: out std_logic_vector(n_bitsdata-1 downto 0));
end component;
-------------------SIGNALS------------------------------
constant NBITS:           integer := 8;
signal clk_int :          std_logic:= '1';
signal reset_int :        std_logic:= '1';
signal rx_d_int :         std_logic:='1';
signal data_package_int : std_logic_vector(NBITS-1 downto 0);

constant frequency : integer  :=24; --MHz
constant periode   : time     := 1 us/frequency;--ns
signal   stop      : boolean  := false;

begin 
-----------------MAPEO I/O---------------------------------
DUT: UART_RX 
generic map ( n_bitsdata => NBITS)
PORT MAP (
         clk          => clk_int,
			reset        => reset_int,
			rx_d         => rx_d_int,
			data_package => data_package_int);

----------------ESTIMULATION INPUTS---------------------------------
clock:process 
begin  
clk_int<= '1', '0'after periode/2;-- se genera una señal periódica de reloj 
wait for periode;
if stop then-- stop predeterminadamente es falso pero cuando es verdadero pasa al wait y se detiene el reloj 
	wait;
	end if;
end process clock;
reset_int <= '1', '0' after periode*3/2;--es periode*3/2 porque es lo que tarda el comando anterior de clk

------Para calcular el tiempo de un bit = (1/115200) = 8680.55555 => 8681

PRUEBA:process
begin
			-------------Rx_Idle-------------------
			rx_d_int <= '1';
			wait for 8681 ns;
			-------------Rx_Start------------------
			rx_d_int <= '0';
			wait for 8681 ns;
			-------------Rx_Data------------------
			------------"01001000"----------------
			rx_d_int <= '0';    --bit 0 => 0
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 1 => 0
			wait for 8681 ns;
			
			rx_d_int<= '0';     --bit 2 => 0
			wait for 8681 ns;
			
			rx_d_int <= '1';    --bit 3 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 4 => 0
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 5 => 0
			wait for 8681 ns;
			
			rx_d_int<= '1';     --bit 6 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 7 => 0
			wait for 8681 ns;
			-------------Rx_Stop------------------
			rx_d_int<= '1' ;
			wait for 8681 ns;
			
			
			
----------------------Rx_Idle-----------------------------
			rx_d_int <= '1';
			wait for 8681 ns;
			-------------Rx_Start------------------
			rx_d_int <= '0';
			wait for 8681 ns;
			-------------Rx_Data------------------
			------------"01101111"----------------
			rx_d_int <= '1';    --bit 0 => 1
			wait for 8681 ns;
			
			rx_d_int <= '1';    --bit 1 => 1
			wait for 8681 ns;
			
			rx_d_int<= '1';     --bit 2 => 1
			wait for 8681 ns;
			
			rx_d_int <= '1';    --bit 3 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 4 => 0
			wait for 8681 ns;
			
			rx_d_int <= '1';    --bit 5 => 1
			wait for 8681 ns;
			
			rx_d_int<= '1';     --bit 6 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 7 => 0
			wait for 8681 ns;
			-------------Rx_Stop------------------
			rx_d_int<= '1' ;
			wait for 8681 ns;
			
			
			
----------------------Rx_Idle---------------------------
			
			rx_d_int <= '1';
			wait for 8681 ns;
			
			
			-------------Rx_Start------------------
			rx_d_int <= '0';
			wait for 8681 ns;
			-------------Rx_Data------------------
			------------"01100001"----------------
			rx_d_int <= '1';    --bit 0 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 1 => 0
			wait for 8681 ns;
			
			rx_d_int<= '0';     --bit 2 => 0
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 3 => 0
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 4 => 0
			wait for 8681 ns;
			
			rx_d_int <= '1';    --bit 5 => 1
			wait for 8681 ns;
			
			rx_d_int<= '1';     --bit 6 => 1
			wait for 8681 ns;
			
			rx_d_int <= '0';    --bit 7 => 0
			wait for 8681 ns;
			-------------Rx_Stop------------------
			rx_d_int<= '1' ;
			wait for 8681 ns;
			
			-------------Rx_Idle-------------------
			rx_d_int <= '1';
			wait for 8681 ns;

 stop <=true;
 wait;
end process PRUEBA;
end architecture Behavioral;




