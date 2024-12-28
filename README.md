# DDS-with-Uart-interface
create by [Kittiphop Phanthachart](https://bento.me/mac-kittiphop) (a 3rd-year Engineering student)
### Specification 
- Sine_Wave_LUT      : 256  (But you can customize it to your project using this code. [Sinewave_LUT](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Sinewave_LUT.py))

- Output Resolution  : 2^12(4096)

- Frequency Max.(Hz)    : 62.5 MHz@Nyquist frequency  (My system_clock is 125 MHz )


### Formula
$$
F_{out} = \frac{F_{freq_ctrl} \times F_{clk}}{2^{N}}
$$


## System_Diagram
![System_Diagram](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/System_Diagram.png)

## Schematic
![Schematic](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/Schematic%20.png)

## Simulation Results
![Simulation Results](https://github.com/XACKIES/DDS-with-Uart-interface/blob/main/Doc/Simmulation_Result.png)
