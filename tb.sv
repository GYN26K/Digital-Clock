`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2026 11:11:37
// Design Name: 
// Module Name: clock_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module clock_tb();

reg clk , reset , ena ;
wire pm ;
wire [7:0] hh , mm , ss ;

top_module dut(
    .clk(clk) ,
    .reset(reset) ,
    .ena(ena) ,
    .pm(pm) ,
    .hh(hh) ,
    .mm(mm) ,
    .ss(ss)
);

initial begin
    clk = 1'b1 ;
    forever #20 clk = ~clk ;
end

initial begin
    
    #20 reset = 1 ; ena = 1 ;
    #20 reset = 0 ;
    #2000000; 
    $finish ;
end
 
endmodule
