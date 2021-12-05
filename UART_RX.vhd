library IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD. ALL;

entity UART_RX is
generic (n_bitsdata :positive := 8);---Cantidad de bits que tendra el paquete de datos que se va a recibir
port(
clk          :  in  std_logic;--Clock
reset        :  in  std_logic;--Reset
rx_d         :  in  std_logic;--Receive data (el bit que se recibe por el serial)
data_package :  out std_logic_vector(n_bitsdata-1 downto 0));---Paquete de datos recibidos

end entity UART_RX;

architecture Behavioral of UART_RX is

type status is (Rx_Idle, Rx_Start, RX_Data, Rx_Stop);--Estados que componen la maquina de estados

signal nextstatus : status;---Señal de proximo estado
signal register_dataRx  : std_logic_vector (n_bitsdata-1 downto 0);--Aqui se incorporan los bits que se reciben (registro de desplazamiento)
signal buffer_Rx        : std_logic_vector (n_bitsdata-1 downto 0);--Aqui se copia el registro para limpiar el regitro
signal counter_bits     : unsigned (3 downto 0);--Es para contar los 8 bits
signal counter_pulse    : unsigned (3 downto 0);--Es para contar los pulsos de la señal de cada bit recibido

constant baud_rate    : integer := 115200;--Velocidad (bits/s)
constant pulses_count : integer := (24000000/baud_rate)-1;--Cantidad de pulsos para ir de la mitad de un bit a la mitad de otro bit

begin

Rx:process(clK) 
begin 
	if rising_edge(clk) then
		if reset='1' then
			register_dataRx<=(others=>'0' ) ;
			buffer_Rx<=(others=>'0' ) ;
			nextstatus<=Rx_Idle;
		else 
			case nextstatus is
			
---------------------Rx_Idle--------------------------------
				when Rx_Idle =>
				counter_bits     <= (others => '0');
				counter_pulse    <= (others => '0');
				register_dataRx  <= (others => '0');
					if rx_d = '0' then
						nextstatus <= Rx_Start;
					end if;
					
---------------------Rx_Start-------------------------------
				when Rx_Start =>
					if counter_pulse <  (pulses_count/2) then
						counter_pulse <= counter_pulse+1;
					else 
						counter_pulse <= (others=>'0');
						if rx_d ='0' then
							nextstatus <= Rx_Data;
						else 
							nextstatus <= Rx_Idle;
						end if;
					end if; 
					
----------------------Rx_Data-------------------------------
				when Rx_Data =>
					if counter_pulse   <  pulses_count then
						counter_pulse   <= counter_pulse+1;
					else 
						counter_pulse   <= (others=>'0');
						if counter_bits <   n_bitsdata then
							register_dataRx <= rx_d & register_dataRx(n_bitsdata-1 downto 1);
							counter_bits <= counter_bits +1;
						else 
							counter_bits <= (others =>'0');
							nextstatus <= Rx_Stop;
						end if;
					end if;
					
----------------------Rx_Stop-------------------------------
				when Rx_Stop =>
					if counter_pulse < pulses_count then
						counter_pulse <= counter_pulse+1;
					else 
						counter_pulse <= (others=>'0');
						buffer_Rx <= register_dataRx;
						nextstatus <= Rx_Idle;
					end if;
					
			end case;
		end if;
	end if;
end process Rx;
data_package <= buffer_Rx;
end architecture Behavioral;
