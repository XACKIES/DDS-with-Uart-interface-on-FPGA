# DDS-with-Uart-interface-on-FPGA
create by [Kittiphop Phanthachart](https://bento.me/mac-kittiphop) (a 3rd-year Engineering student)
### Specification 
- Sine_Wave_LUT      : 256  (But you can customize it to your project using this code. [Sinewave_LUT](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Sinewave_LUT.py))

- Output Resolution  : 2^12(4096)

- Frequency (Max.)    : 62.5 MHz@Nyquist frequency  (My system_clock is 125 MHz )

- No. LUT : 108

- No.Filp Flop : 95

- No. Rx_Data_Frame : 4 bytes


### Formula
$$
F_{out} = \frac{F_{freq_ctrl} \times F_{clk}}{2^{N}}
$$




## Interface
![Interface](https://github.com/XACKIES/DDS-with-Uart-interface-on-FPGA/blob/main/Doc/DDS_Interface.jpg)

## System_Diagram
![System_Diagram](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/System_Diagram.png)

## Schematic
![Schematic](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/Schematic%20.png)

## Simulation Results
![Simulation Results](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/Simmulation_Result.png)


## Application

- Signal Generator 
  
- Programmable Oscillator

- Signal Controller
