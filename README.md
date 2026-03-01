## Digital Clock – Basys 3 (Verilog | AM/PM | HH:MM:SS)

### Project Description

This project implements a 12-hour digital clock with AM/PM indication and seconds display on the Basys 3 FPGA board using Verilog HDL.

### Implementation Steps

1. Coded the digital clock in Verilog  
   - 12-hour format  
   - AM/PM support  
   - Seconds display included  

2. Designed a frequency divider  
   - Converted 100 MHz onboard clock to 1 Hz  

3. Verified the design  
   - Created SystemVerilog (.sv) testbench  
   - Simulated rollover conditions  
   - Verified AM/PM switching  

4. Created XDC constraints file  
   - Mapped 100 MHz clock  
   - Mapped 7-segment display pins  
   - Mapped reset button  

5. Added clock constraint  

6. Ran synthesis  

7. Ran implementation  

8. Generated bitstream  

9. Programmed the Basys 3 board  
