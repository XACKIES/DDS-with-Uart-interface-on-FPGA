library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity Control is
    Port(
        
        clk			    : in std_logic;
        
        empty           : in std_logic;
        btn             : in std_logic_vector(1 downto 0);
        
        SinglePulse_SW  : out std_logic_vector(1 downto 0);
        DeBounce_SW     : out std_logic_vector(1 downto 0)
    );
end Control;

architecture Behavioral of Control is
	signal btn_sync 	: std_logic_vector(1 downto 0);
	signal btn_stable      : std_logic_vector(1 downto 0) :=  conv_std_logic_vector(0,2);  
	signal SinglePluse 	: std_logic_vector(1 downto 0);
	constant debounce_time : integer := 12_500_000; 
    signal counter         : integer := 0;
begin

    u_sync : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
				btn_sync 	<= btn;
		end if;
	End Process u_sync;

	
	u_Debounce : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
		
			 if btn_sync /= btn_stable then
                counter <= counter + 1;
                if counter >= debounce_time then
                    btn_stable <= btn_sync;
                    counter <= 0;
                end if;
            else
                counter <= 0; 
            end if;	
		end if;
	End Process u_Debounce;
	
	
    u_SinglePulse : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
				SinglePluse 	<= btn_sync;
		end if;
	End Process u_SinglePulse;
	
	
	 SinglePulse_SW    <=  SinglePluse and btn_sync and (not(empty & empty)) ;
	 DeBounce_SW       <= btn_stable;
	
	
	
	

end Behavioral;