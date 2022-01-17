`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 23:33:34
// Design Name: 
// Module Name: TOP_Digital_Clock
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


module TOP_Digital_Clock(
    input fpga_clk,
    input rstn,

    output wire [7:0] digit,
    output wire [6:0] seg
);
wire sec_clk;
wire min_clk;
wire hour_clk;
wire w_clk_5k;

digital_clock_clk_gen inst_clk_gen(
    // INPUTS
    .fpga_clk(fpga_clk),
    .rstn(rstn),
    
    // OUTPUTS
    .sec_clk(sec_clk),
    .min_clk(min_clk),
    .hour_clk(hour_clk),
    .clk_5k(w_clk_5k)
);

Digital_Clock inst_Digital_Clock(
    // INPUTS
    .rstn(rstn),
    .sec_clk(sec_clk),
    .min_clk(min_clk),
    .hour_clk(hour_clk),
    .clk_5k(w_clk_5k),
    
    // OUTPUTS
    .digit(digit),
    .seg(seg)
);
endmodule
