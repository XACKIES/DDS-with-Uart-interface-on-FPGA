library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;






entity DDS_with_Uart is
        Port 
        ( 
                SerDataIn   : in std_logic;
                clk         :  in std_logic;
                btns         :in std_logic_vector(1 downto 0) ;
               
                sine_out   : out std_logic_vector(11 downto 0) 
        );
        
end DDS_with_Uart;

architecture rtl of DDS_with_Uart is

        component DDS is
            
             
            port 
            (
                 clk        : in  std_logic;
                reset      : in  std_logic;
                freq_ctrl  : in  std_logic_vector(31 downto 0); 
                sine_out   : out std_logic_vector(11 downto 0) 
            );
        end component;

        component FIFO8to32 is
            port 
            (
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
        
        
        
        
        component Rx_serial is
        port 
        (
            RstB		: in	std_logic;
            clk			: in	std_logic;
            
            SerDataIn	: in	std_logic;
            
            RxFfFull	: in	std_logic;
            RxFfWrData	: out	std_logic_vector( 7 downto 0 );
            RxFfWrEn	: out	std_logic
        );
        end component;
        
        component Control is
        Port(
            clk			    : in std_logic;
            
            empty           : in std_logic;
            btn             : in std_logic_vector(1 downto 0);
            
            SinglePulse_SW  : out std_logic_vector(1 downto 0);
            DeBounce_SW     : out std_logic_vector(1 downto 0)
        );
        end component;
        
        
        signal write_enable : std_logic;
        signal read_enable : std_logic;
        signal data_in : std_logic_vector(7 downto 0);
        signal data_out : std_logic_vector(31 downto 0) ;
        signal empty : std_logic;
        signal SinglePulse_SW : std_logic_vector(1 downto 0);
        signal DeBounce_SW : std_logic_vector(1 downto 0);
        signal full : std_logic;
        
        
        
begin

    --UUT (Unit Under Test)
    
    uut_DDS : DDS
           port map (
           
              clk       => clk,
              reset     => btns(1),
              freq_ctrl => data_out,
              sine_out  => sine_out
           );
           
           


    
    uut_Control: Control
        Port map 
        (           
            clk             => clk  ,
            empty           => empty,
            btn            =>  btns ,
            SinglePulse_SW  => SinglePulse_SW ,
            
            DeBounce_SW     => DeBounce_SW 
        );

    uut_FIFO8to32: FIFO8to32
        Port map (
            clk          => clk,
            reset        => btns(1) ,
            write_enable => write_enable,
            read_enable  => btns(0),
            data_in      => data_in,
            data_out     => data_out,
            empty        => empty,
            full         => full
        );
        
    uut_Rx_serial: Rx_serial
        Port map 
        (
            RstB	    => btns(1),	
            clk		    => clk,
            SerDataIn	=> SerDataIn,
            RxFfFull	 => full,
            RxFfWrData	=> data_in,
            RxFfWrEn	=> write_enable
        );

end rtl;
