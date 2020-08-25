--0 Black 
--1 white

library ieee;
use ieee.std_logic_1164.all;

entity Car is

port(clk_in,sonar_echo,line1,line2: in std_logic;
sonar_trig,e1,e2,m11,m12,m21,m22,buzzer: OUT std_logic;
segment1,segment10,segment100: out STD_LOGIC_VECTOR (6 downto 0));

end Car;

architecture behavioral of Car is

signal stop,turn: std_LOGIC;
signal count: INTEGER:= 0;


component ultrasonic is

Port ( clk: in  STD_LOGIC;
       sonar_trig : out STD_LOGIC;
       sonar_echo,NotEn : in  STD_LOGIC;
       segment1,segment10,segment100: out STD_LOGIC_VECTOR (6 downto 0);
		 stop: out std_LOGIC);
end component;

begin

sonar: ultrasonic port map(clk_in,sonar_trig,sonar_echo,turn,segment1,segment10,segment100,stop);

process(clk_in)
begin

		
if(clk_in'event and clk_in = '1') then	
 buzzer<='0';
		if(stop = '0' and turn = '0') then
		
			if(line1 = '1' and line2 = '1') then
			--forward
				e1 <= '1';
				m11 <= '1';
				m12 <= '0';
				e2 <= '1';
                                m22 <= '0';			
                                m21 <= '1';
				
			end if;
			
			---------------------------
			if(line1 = '1' and line2 = '0') then
			--right
				e1 <= '1';
				m11 <= '1';
				m12 <= '0';
				e2 <= '1';
				m21 <= '0';
				m22 <= '1';
			end if;
			---------------------------
			if(line1 = '0' and line2 = '1') then
			--left
				e1 <= '1';
				m11 <= '0';
				m12 <= '1';
				e2 <= '1';
				m21 <= '1';
				m22 <= '0';
			end if;
			---------------------------
			if(line1 = '0' and line2 = '0') then
			--Stop
				e1 <= '0';
				e2 <= '0';
			end if;
			---------------------------
			
		elsif(turn = '1' and stop = '0') then
			count <= count + 1;
			if(count < 150000000) then
			e1 <= '0';
				e2 <= '0';
				buzzer<='1';
			elsif(count < 170000000) then
			--left   
				e1 <= '1';
				 m11 <= '0';
				 m12 <= '1';
				 e2 <= '1';
				 m21 <= '1';
				 m22 <= '0';
			elsif(count < 205000000)then
			--forward
			   e1 <= '1';
				m11 <= '1';
				m12 <= '0';
				e2 <= '1';
				m21 <= '1';
				m22 <= '0';
			elsif(count < 223500000)then
			 --right 
			  e1 <= '1';
				m11 <= '1';
				m12 <= '0';
				e2 <= '1';
				m21 <= '0';
				m22 <= '1';
				else 
				count <= 0;
				turn <='0';
				end if;
			
	
		elsif(stop = '1' and turn <='0') then
			turn <= '1';
	
		end if;

end if;
			

end process;	
end behavioral;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

------------------------------------
entity Ultrasonic is
    Port ( clk: in  STD_LOGIC;
           sonar_trig : out STD_LOGIC;
           sonar_echo,NotEn : in  STD_LOGIC;
           segment1,segment10,segment100: out STD_LOGIC_VECTOR (6 downto 0);
			  stop: out STD_LOGIC);
end Ultrasonic;

architecture Behavioral of Ultrasonic is
    signal count            : unsigned(16 downto 0) := (others => '0');
    signal centimeters      : unsigned(15 downto 0) := (others => '0');
    signal centimeters_ones : unsigned(3 downto 0)  := (others => '0');
    signal centimeters_tens : unsigned(3 downto 0)  := (others => '0');
	 signal centimeters_hundreds: unsigned(3 downto 0)  := (others => '0');
    signal output_ones      : unsigned(3 downto 0)  := (others => '0');
    signal output_tens      : unsigned(3 downto 0)  := (others => '0');
	 signal output_hundreds  : unsigned(3 downto 0)  := (others => '0');
    signal digit            : unsigned(3 downto 0)  := (others => '0');
	 signal digit2, digit22  : unsigned(3 downto 0)  := (others => '0');
	 signal digit3           : unsigned(3 downto 0)  := (others => '0');
    signal echo_last        : std_logic := '0';
    signal echo_synced      : std_logic := '0';
    signal echo_unsynced    : std_logic := '0';
    signal waiting          : std_logic := '0'; 
    signal seven_seg_count  : unsigned(15 downto 0) := (others => '0');
begin

decode: process(digit)
    begin
        case digit is 
           when "0001" => segment1 <= "1111001";
           when "0010" => segment1 <= "0100100";
           when "0011" => segment1 <= "0110000";
           when "0100" => segment1 <= "0011001";
           when "0101" => segment1 <= "0010010";
           when "0110" => segment1 <= "0000010";
           when "0111" => segment1 <= "1111000";
           when "1000" => segment1 <= "0000000";
           when "1001" => segment1 <= "0010000";
           when others => segment1 <= "1000000";
        end case;
    end process;

decode2: process(digit2)
    begin
        case digit2 is 
           when "0001" => segment10 <= "1111001";
           when "0010" => segment10 <= "0100100";
           when "0011" => segment10 <= "0110000";
           when "0100" => segment10 <= "0011001";
           when "0101" => segment10 <= "0010010";
           when "0110" => segment10 <= "0000010";
           when "0111" => segment10 <= "1111000";
           when "1000" => segment10 <= "0000000";
           when "1001" => segment10 <= "0010000";
           when others => segment10 <= "1000000";
        end case;
    end process;
	 
decode3: process(digit3)
    begin
        case digit3 is 
			  when "0001" => segment100 <= "1111001";
           when "0010" => segment100 <= "0100100";
           when "0011" => segment100 <= "0110000";
           when "0100" => segment100 <= "0011001";
           when "0101" => segment100 <= "0010010";
           when "0110" => segment100 <= "0000010";
           when "0111" => segment100 <= "1111000";
           when "1000" => segment100 <= "0000000";
           when "1001" => segment100 <= "0010000";
           when others => segment100 <= "1000000";
        end case;
    end process;

	 
	 
seven_seg: process(clk)
    begin
        if rising_edge(clk) then
--            if seven_seg_count(seven_seg_count'high) = '1' then
				
                digit <= output_ones;
--            else
                digit2 <= output_tens;
					 digit3 <= output_hundreds;
--            end if; 

            seven_seg_count <= seven_seg_count +1; 
        end if;
    end process;
    
Ulrasonic: process(clk)
    begin
        if rising_edge(clk) then
            if waiting = '0' then
                if count = 500 then -- Assumes 50MHz
                   -- After 10us then go into waiting mode
                   sonar_trig <= '0';
                   waiting <= '1';
                   count <= (others => '0');
                else
                   sonar_trig <= '1';
                   count <= count+1;
                end if;  
					 -- waiting mode (waiting = 1)
            elsif echo_last = '0' and echo_synced = '1' then
                -- Seen rising edge - start count
                count <= (others => '0');
                centimeters <= (others => '0');
                centimeters_ones <= (others => '0');
                centimeters_tens <= (others => '0');
					 centimeters_hundreds <= (others => '0');
            elsif echo_last = '1' and echo_synced = '0' then
                -- Seen falling edge, so capture count
                output_ones <= centimeters_ones; 
                output_tens <= centimeters_tens; 
					 output_hundreds <= centimeters_hundreds;
            elsif count = 2900 - 1 then
                -- advance the counter
					 if (centimeters_ones = 9 AND centimeters_tens = 9) then
						  centimeters_ones <= (others => '0');
                    centimeters_tens <= (others => '0');
						  centimeters_hundreds <= centimeters_hundreds + 1;
                elsif (centimeters_ones = 9) then
						  centimeters_ones <= (others => '0');
                    centimeters_tens <= centimeters_tens + 1;
					 else
                    centimeters_ones <= centimeters_ones + 1;
                end if;
                centimeters <= centimeters + 1;
                count <= (others => '0');
                if centimeters = 3448 then
                    -- time out - send another pulse
                    waiting <= '0';
                end if;
            else
                count <= count + 1;                
            end if;
				
				if( digit3 = 0 and digit2 < 3 and NotEn = '0'  and (digit > 0 and digit2 > 0) and digit22 < 5 ) then
					stop <= '1';
				else
					stop <= '0';
				end if;
				
				digit22 <= digit2;
            echo_last     <= echo_synced;
            echo_synced   <= echo_unsynced;
            echo_unsynced <= sonar_echo;
        end if;
        
    end process;
end Behavioral;
