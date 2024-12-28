library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.STD_LOGIC_UNSIGNED.all;

Entity Tx_serial Is
Port(
	RstB		: in	std_logic;
	clk			: in	std_logic;
	
	TxFfEmpty	: in	std_logic;
	TxFfRdData	: in	std_logic_vector( 7 downto 0 );
	TxFfRdEn	: out	std_logic;
	
	SerDataOut	: out	std_logic
);
End Entity Tx_serial;

Architecture rtl Of Tx_serial Is

----------------------------------------------------------------------------------
-- Constant declaration
----------------------------------------------------------------------------------
	Constant cbuadCnt	:	natural:= 5209 ;
	

----------------------------------------------------------------------------------
-- Signal declaration
----------------------------------------------------------------------------------

	type 	SerStateType is 
						(
							stIdle,
							stRdReg,
							stWtData,
							stWtEnd
						);
	Signal	rState		:	SerStateType;
	
	Signal	rTxFfRdEn	:	std_logic_vector(1 downto 0);
	Signal	rSerData	:	std_logic_vector(9 downto 0);
	Signal 	rBuadCnt	:	std_logic_vector(9 downto 0);
	Signal	rBuadEnd	:	std_logic;
	Signal	rDataCnt	:	std_logic_vector(3 downto 0);

	
	-- imposter variable
	Signal	Start		:	std_logic;
	Signal	SerEnd		:	std_logic;		
Begin
----------------------------------------------------------------------------------
-- Output assignment
----------------------------------------------------------------------------------
	SerDataOut	<=	rSerData(0);
	TxFfRdEn	<=	rTxFfRdEn(0);
	
	---------------------
	------ Checked ------
	------ Confirm ------
	---------------------
	
	u_rBuadCnt : process (clk) Is -- Prescaler to 115200 band
	Begin
		if( rising_edge(clk) ) then 
		
			if (RstB = '0') then
			
				rBuadCnt(9 downto 0) 	<=	(others =>'0');
				
			else
			
				--if ( rBuadCnt(9 downto 0) = 1 or (rState /= stWtEnd )or TxFfEmpty = '1' ) then
				if ( rBuadCnt(9 downto 0) = 1 or (rState /= stWtEnd ) ) then	
					rBuadCnt(9 downto 0)	<=	 conv_std_logic_vector(cbuadCnt,10);
				
				else
				
					rBuadCnt(9 downto 0)	<=	rBuadCnt(9 downto 0) - 1;
					
				end if;
			end if;
		end if;
	End	process u_rBuadCnt;
	
	
	
	---------------------
	------ Checked ------
	---------------------
	u_rDataCnt : process (clk) Is
	Begin
		if( rising_edge(clk) ) then 
			if (RstB = '0') then
				rDataCnt(3 downto 0) 	<=	(others =>'0');
			else
				if(	rBuadCnt(9 downto 0) = 1  and rDataCnt(3 downto 0) /=  9 ) then
				
					rDataCnt(3 downto 0) 	<=	rDataCnt(3 downto 0) + 1;
					
				elsif ( (rDataCnt(3 downto 0) = 9 and  rBuadEnd = '1') or (rState	=	stIdle)) then				
				--elsif ( rDataCnt(3 downto 0) =  9  and rBuadCnt(9 downto 0) = 1) then
					
					rDataCnt(3 downto 0) 	<=	(others =>'0');
					
				else
					rDataCnt(3 downto 0) 	<=	 rDataCnt(3 downto 0);
				end if;
			end if;
		end if;
	End	process u_rDataCnt;
	
	
	
	---------------------
	------ Checked ------
	---------------------
	u_rBuadEnd : process(Clk) Is
	Begin
		if( rising_edge(Clk) ) then
		
			if (RstB = '0') then
				rBuadEnd	 <=	'0';
			else
				if ( rBuadCnt(9 downto 0) = 2 and rState = stWtEnd  ) then
					rBuadEnd <=	'1';
				else
					rBuadEnd <=	'0';
				end if;
			end if;
			
		end if;
	End process u_rBuadEnd;

	
	
	
		u_rState	: Process(Clk)	Is
	Begin
		if( rising_edge(Clk) ) then
			if (RstB = '0') then
				rState	<=	stIdle;
			else 
				case ( rState ) is 
				
				
					when stIdle		=>
						if (TxFfEmpty = '0') then
							rState 	<= 	stRdReg;
						else
							rState	<=	stIdle;
						end if;
		
		
					when stRdReg		=>
						if (rTxFfRdEn(0) = '0') then 
							rState 	<= 	stWtData;
						else
							rState	<=	stRdReg;
						end if;
						

					when stWtData	=>
						
						if  ( rTxFfRdEn(1) = '1' ) then
							rState	<=	stWtEnd;
						else
							rState	<=	stWtData;
						end if;
						
						

					when stWtEnd	=>
						if (  (rDataCnt(3 downto 0) = 9 and  rBuadEnd = '1') ) then
							rState 	<= stIdle ;
						else
							rState 	<=	stWtEnd;
						end if;
				end case;
			end if;
		end if;
	End Process u_rState;
	
	
	
	
	
	---------------------
	------ Checked ------
	---------------------
	u_rTxFfRdEn	:	Process(Clk) Is
	Begin
		if( rising_edge(Clk) ) then
			if (RstB = '0') then
				
				rTxFfRdEn(1 downto 0)	<=	"00"; 
				
			else 
				 
				if ( rState = stRdReg) then
				--if ( rState = stIdle	) then
					rTxFfRdEn(0) <= '1';
				else 
					rTxFfRdEn(1)	<= rTxFfRdEn(0) ;
					rTxFfRdEn(0)  	<= '0';
				end if ;
			end if ;
		end if ;
	End process u_rTxFfRdEn;
	


	---------------------
	------ Checked ------
	---------------------
	u_rSerData : Process (Clk) Is 
	Begin
	
		if( rising_edge(Clk) ) then
			if (RstB = '0')	then
				rSerData	<= (others => '1');
			else 
				if (rTxFfRdEn(1) = '1' and rState = stWtData)	then
					rSerData(9)	<='1';
					rSerData(8 downto 1) <= TxFfRdData;
					rSerData(0)	<='0';
					
					
				elsif (rBuadEnd = '1' and rBuadCnt(9 downto 0) = 1 )then
				
					rSerData(9 downto 0) 	<=	'1' & rSerData(9 downto 1);
				else
					rSerData(9 downto 0) 	<=	rSerData(9 downto 0) ;
				end if;
			end if;
		end if ;
	End Process u_rSerData;	
			
			
End Architecture rtl;