library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;
entity DDS_tb is
end DDS_tb;

architecture Behavioral of DDS_tb is
    constant CLK_PERIOD : time := 8 ns; 
    signal clk          : std_logic := '0';
    
    signal reset        : std_logic := '1';
    signal freq_ctrl    : std_logic_vector(31 downto 0) := (others => '0');
    signal sine_out     : std_logic_vector(11 downto 0);

    component DDS
 
        port (
            clk        : in  std_logic;
            reset      : in  std_logic;
            freq_ctrl  : in  std_logic_vector(31 downto 0);
            sine_out   : out std_logic_vector(11 downto 0)
               );
    end component;

begin
   
    dut: DDS
     
        port map (
            clk        => clk,
            reset      => reset,
            freq_ctrl  => freq_ctrl,
            sine_out   => sine_out
        );

    
    
    clk_process: process
    begin
        while true loop
            clk <= '0';
            wait for CLK_PERIOD / 2;
            clk <= '1';
            wait for CLK_PERIOD / 2;
        end loop;
    end process;


    test_process: process
    begin
        
        reset <= '0';
        wait for 100 ns;
        reset <= '1';

       -- Kuy Overflow
       -- freq_ctrl <= to_unsigned((1000 * (2**32)) / 125_000_000, 32); 
        
        freq_ctrl <= conv_std_logic_vector(1000 * 34, 32); 
        wait for 5 ms;
        
        freq_ctrl <= conv_std_logic_vector(3000 * 34, 32); 
        wait for 5 ms;
        
        freq_ctrl <= conv_std_logic_vector(5000 * 34, 32); 
        wait for 5 ms;
        
    end process;
end Behavioral;
