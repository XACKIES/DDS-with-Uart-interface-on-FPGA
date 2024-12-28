import numpy as np


LUT_SIZE = 256 
BIT_WIDTH = 12  
MAX_VALUE = 2**BIT_WIDTH - 1  
AMPLITUDE = MAX_VALUE // 2    

sine_lut = [
    round(AMPLITUDE * (1 + np.sin(2 * np.pi * n / LUT_SIZE))) for n in range(LUT_SIZE)
]

vhdl_lut = [
    f'"{bin(value)[2:].zfill(BIT_WIDTH)}"' for value in sine_lut
]
print(f"constant sine_lut : std_logic_vector({BIT_WIDTH-1} downto 0) array (0 to {LUT_SIZE-1}) := (")
for i, val in enumerate(vhdl_lut):
    if i < LUT_SIZE - 1:
        print(f"    {val},")
    else:
        print(f"    {val}")
print(");")
