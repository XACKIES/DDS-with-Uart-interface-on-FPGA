library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO8to32_tb is
end FIFO8to32_tb;

architecture Behavioral of FIFO8to32_tb is

    -- Component Declaration
    component FIFO8to32
        Port (
            clk          : in  std_logic;
            reset        : in  std_logic;
            write_enable : in  std_logic;
            read_enable  : in  std_logic;
            data_in      : in  std_logic_vector(7 downto 0);
            data_out     : out std_logic_vector(31 downto 0);
            empty        : out std_logic;
            full         : out std_logic
        );
    end component;

    -- Signals
    signal clk          : std_logic := '0';
    signal reset        : std_logic := '0';
    signal write_enable : std_logic := '0';
    signal read_enable  : std_logic := '0';
    signal data_in      : std_logic_vector(7 downto 0) := (others => '0');
    signal data_out     : std_logic_vector(31 downto 0);
    signal empty        : std_logic;
    signal full         : std_logic;
    signal	TM			: integer	range 0 to 65535;
    constant clk_period : time := 10 ns;

begin
    --DUT (Device Under Test)
    uut: FIFO8to32
        Port map (
            clk          => clk,
            reset        => reset ,
            write_enable => write_enable,
            read_enable  => read_enable,
            data_in      => data_in,
            data_out     => data_out,
            empty        => empty,
            full         => full
        );

    -- Clock Gen
    clk_process : process
    begin
        while True loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
    end process;

   
    tb_process : process
    begin
        -- Initial Reset
        reset <= '1';
        wait for clk_period;
        reset <= '0';



        -------------------------------------------
		-- TM=0 : Write 4 bytes into FIFO Reset
		-------------------------------------------
        TM <= 0 ; wait for 1 ns;
        
        for i in 0 to 3 loop
            data_in <= std_logic_vector(to_unsigned(i, 8));
            write_enable <= '1';
            wait for clk_period;
        end loop;
        write_enable <= '0';
        wait for clk_period;
        read_enable <= '1';
        wait for clk_period;
        read_enable <= '0';

        -------------------------------------------
		-- TM=1 : Write data over 4 bytes into FIFO Reset
		-------------------------------------------
        TM <= 1 ; wait for 1 ns;
        for i in 0 to 7 loop
            write_enable <= '1';
            data_in <= std_logic_vector(to_unsigned(i+2, 8));
            
            wait for clk_period;
        end loop;
        write_enable <= '0';
        wait for clk_period;
        read_enable <= '1';
        wait for clk_period;
        read_enable <= '0';
       
       
       -------------------------------------------
		-- TM=2 : Force reset Fifo , during use
		-------------------------------------------
        TM <= 2 ; wait for 1 ns;
        for i in 0 to 4loop
            data_in <= std_logic_vector(to_unsigned(i+3, 8));
            write_enable <= '1';
            wait for clk_period;
        end loop;
        reset <= '1';
        wait for clk_period;
        reset <= '0';
        
        write_enable <= '0';
        wait for clk_period;
        read_enable <= '1';
        wait for clk_period;
        read_enable <= '0';
       
       
        -- End Simulation
        wait for clk_period * 10;
        wait;
    end process;

end Behavioral;
