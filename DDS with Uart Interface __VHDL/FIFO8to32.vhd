library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FIFO8to32 is
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
end FIFO8to32;

architecture Behavioral of FIFO8to32 is
    signal Frame   : std_logic_vector(31 downto 0) := (others => '0');
    signal count    : integer range 0 to 4 := 0;
begin
    process(clk, reset)
    begin
        if rising_edge(clk) then
            if reset = '0' then
            
                Frame <= (others => '0');
                count <= 0;
                
                
            else
        
                if write_enable = '1' and count < 4 then
                    Frame((count * 8 + 7) downto (count * 8)) <= data_in;
                    count <= count + 1;
                
                elsif read_enable = '1' and count = 4 then
                
                    count <= 0;
                end if;
            end if;
        end if;
    end process;

    data_out <= Frame;
    empty <= '1' when count = 0 else '0';
    full <= '1' when count = 4 else '0';
end Behavioral;
