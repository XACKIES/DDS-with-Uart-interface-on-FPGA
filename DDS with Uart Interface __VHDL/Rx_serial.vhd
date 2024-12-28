library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


Entity Rx_serial Is
Port(
	RstB		: in	std_logic;
	clk			: in	std_logic;
	
	SerDataIn	: in	std_logic;
	
	RxFfFull	: in	std_logic;
	RxFfWrData	: out	std_logic_vector( 7 downto 0 );
	RxFfWrEn	: out	std_logic
);
End Entity Rx_serial;

Architecture rtl Of Rx_serial Is

constant cbuadCnt  :integer := 868;

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

signal rSerCnt : std_logic_vector(9 downto 0);   
signal rSerEn : std_logic; 
	
signal	rSerDataIn	: std_logic;  
signal	rRxFfWrData	: std_logic_vector( 9 downto 0 ); 
signal	rRxFfWrEn	: std_logic; 

signal rDataCnt 	: std_logic_vector( 3 downto 0 );  

signal rRxFfFull 	: std_logic; 

type SerStateType Is
	( stIdle ,
	stSamp,
	stRdReq,
	stFault
	);
signal rState : SerStateType;


Begin

----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
RxFfWrEn   <= rRxFfWrEn;
RxFfWrData <= rRxFfWrData( 8 downto 1);


----------------------------------------------------------------------------------
-- DFF 
----------------------------------------------------------------------------------

	u_rSerDataIn : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			rSerDataIn		<= SerDataIn;
		end if;
	End Process u_rSerDataIn;
	
	


u_rSerCnt : Process(Clk) Is 
Begin
	if (rising_edge(Clk)) then 
		if (RstB='0') then
			rSerCnt (9 downto 0) <=  conv_std_logic_vector(cbuadCnt,10);
		else 
			if (rSerCnt =1 or (rState = stIdle and rSerDataIn ='1' ))  then  
				rSerCnt (9 downto 0) <=  conv_std_logic_vector(cbuadCnt,10);
			else
				rSerCnt (9 downto 0) <= rSerCnt (9 downto 0)-1 ;
				
			end if;
		end if;
	end if;
	
end process u_rSerCnt;


u_rSerEn : Process(Clk) Is  
Begin
	
	if (rising_edge(Clk)) then
		if (RstB='0') then
			rSerEn  <=  '0';
		else 
			if (rSerCnt(9 downto 0) = (cbuadCnt/2)) then --Sampling at Center of signal
			
				rSerEn  <=  '1';
			else
				rSerEn  <=  '0';
			end if;
		end if;
	end if;

end process u_rSerEn;



u_rRxFfWrData : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' or rState = stIdle ) then
				rRxFfWrData(9 downto 0)	<= (others=>'0');
			else
			
				if ( rSerEn='1' ) then					
					rRxFfWrData(8 downto 0)	<= rRxFfWrData(9 downto 1);
					rRxFfWrData(9)				<= rSerDataIn;
				else
					rRxFfWrData(9 downto 0)	<= rRxFfWrData(9 downto 0);
				end if;
			end if;
		end if;
	End Process u_rRxFfWrData;	



u_rRxFfWrEn : Process (Clk) Is
	Begin
		if ( rising_edge(Clk) ) then
			if ( RstB='0' ) then
				rRxFfWrEn	<= '0';
			else

				if ( rState = stRdReq and RxFfFull = '0' and rSerCnt = 1) then  
					rRxFfWrEn	<= '1';
				else
					rRxFfWrEn	<= '0';
				end if;
			end if;
		end if;
	End Process u_rRxFfWrEn;



u_rDataCnt : Process(Clk) Is  
Begin
	if (rising_edge(Clk)) then 
		if (RstB='0') then
			rDataCnt (3 downto 0) <=  (others => '0');
		else 
			if ((rDataCnt = 9 and rSerCnt = 1 )or rState = stIdle ) then  
				rDataCnt (3 downto 0) <=  (others => '0');
				
			elsif (rSerCnt = 1) then
				rDataCnt (3 downto 0) <= rDataCnt (3 downto 0) + 1 ;
			else
				rDataCnt (3 downto 0) <= rDataCnt (3 downto 0) ;
			end if;
		end if;
	end if;
end process u_rDataCnt;





----------------------------------------------------------------------------------
-- State Machine
----------------------------------------------------------------------------------
u_rState : Process(Clk) Is 
Begin

	if (rising_edge(Clk)) then
		if (RstB='0') then
			rState <= stIdle;
		else 
			case (rState) Is
			
				when stIdle =>
					if (rSerDataIn ='0' and rDataCnt = 0) then
						rState <= stSamp;
					else
						rState <= stIdle;
					end if;
					
					
				when stSamp => 
				
					if (rSerDataIn ='1' and rSerEn = '1' and rDataCnt = 9) then
						rState <= stRdReq;
					elsif (rSerDataIn ='0' and rSerEn = '1' and rDataCnt = 9) then  
						rState <= stFault;
					else
						rState <= stSamp;
					end if;
						
					
				when stRdReq => 
					if (rSerCnt = 1) then 
						rState <= stIdle; 
					else
						rState <= stRdReq; 					
					end if;
					
					
					
				when stFault => 
					if (rSerCnt = 1) then 
						rState <= stIdle; 
					else
						rState <= stFault; 
					end if;
						
				
			end case;
		end if;
	end if;
	
end process u_rState;

	
End Architecture rtl;