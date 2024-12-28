library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

entity DDS_with_Uart_tb is
end;


architecture bench of DDS_with_Uart_tb is

  component DDS_with_Uart
          Port 
          ( 
                SerDataIn   : in std_logic;
                clk         :  in std_logic;
                
                btns          :in std_logic_vector(1 downto 0) ;
               
                sine_out   : out std_logic_vector(11 downto 0) 
          );
  end component;

    constant CLK_PERIOD : time := 8 ns; 
    signal clk          : std_logic := '0';
    signal SerDataIn: std_logic;
    signal reset: std_logic;
    signal ctrl: std_logic;
    signal     btn : std_logic_vector(1 downto 0) ;
    signal sine_out: std_logic_vector(11 downto 0) ;
	signal	TM			        : integer	range 0 to 65535; 
	signal	Frequncy_command    : integer	range 0 to 65535; 
begin


  dut: DDS_with_Uart port map ( SerDataIn => SerDataIn,
                                
                                clk       => clk,
                                btns       => btn, 
                                sine_out  => sine_out );
 clk_process: process
 
 
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;
    
    btn(1)  <= reset;
    btn(0)  <= ctrl;
    


  stimulus: process
  variable	iSerData	: std_logic_vector( 9 downto 0 );
  begin
    
    reset <= '0';  -- Reset
    ctrl <= '0';  -- Control
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    reset <= '0';  -- Reset
    
    ctrl <= '1';  -- Control
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    reset <= '1';  -- Reset
    ctrl <= '0';  -- Control
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    reset <= '1';  -- Reset
    ctrl <= '1';  -- Control
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    
    
    -- TM=1 : Test at 1000Hz
    -------------------------------------------	
    TM <= 1; wait for 1 ns;
    Frequncy_command    <= 1000;
    Report "TM=" & integer'image(TM); 
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
   
    iSerData 	:= '1'&x"D0"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    iSerData 	:= '1'&x"84"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"00"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"00"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    ctrl <= '0';  -- Control

    wait for 625_000*CLK_PERIOD;
    
    
    
    
    
   
    
    -- TM=2 : Test at 3000Hz
    -------------------------------------------	
    TM <= 1; wait for 1 ns;
    Frequncy_command    <= 3000;
    Report "TM=" & integer'image(TM);
    ctrl <= '1'; 
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
   
    iSerData 	:= '1'&x"70"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    iSerData 	:= '1'&x"8E"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"01"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"00"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    ctrl <= '0';  -- Control
    
    wait for 625_000*CLK_PERIOD;
    
    
    
    
    
    
    
    
   
    
    
    -- TM=3 : Test at 5000Hz
    -------------------------------------------	
    TM <= 1; wait for 1 ns;
    Frequncy_command    <= 5000;
    Report "TM=" & integer'image(TM); 
    ctrl <= '1'; 
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
   
    iSerData 	:= '1'&x"10"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    iSerData 	:= '1'&x"98"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"02"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    
    iSerData 	:= '1'&x"00"&'0';
    For i in 0 to 9 loop
        SerDataIn	<= iSerData(0);
        wait for 867*CLK_PERIOD;
        wait until rising_edge(Clk);
        iSerData	:= '1' & iSerData(9 downto 1);
    End loop;
    
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    wait until rising_edge(Clk);
    ctrl <= '0';  -- Control
    
   
    wait for 625_000*CLK_PERIOD;
    
    
    
    
    
    
    
    

    -- Put test bench stimulus code here

    wait;
  end process;


end;
  