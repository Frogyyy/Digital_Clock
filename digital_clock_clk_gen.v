`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 21:53:12
// Design Name: 
// Module Name: digital_clock_clk_gen
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


module digital_clock_clk_gen(
    input fpga_clk,
    input rstn,
    
    output reg sec_clk, // 1Hz
    output reg min_clk, // 1/60 Hz
    output reg hour_clk, // 1/3600 Hz 위 세개는 실제 디지털 시계에서 output으로 다시 뺼 것 
    output reg clk_5k // 5kHz
    );
reg [3:0] led_x;
//reg sec_clk; // 1Hz
//reg min_clk; // 1/60 Hz
//reg hour_clk; // 1/3600 Hz 위 세개는 실제 디지털 시계에서 output으로 다시 뺼 것 

reg [25:0] Dividing_to_1Hz_count;
reg [ 4:0] sec_count;
reg [ 4:0] min_count;
reg [31:0] count10k;


always@(posedge fpga_clk, negedge rstn) begin
    if(!rstn) begin
        count10k<=32'd0;
    end
    else begin
        if(count10k=='d10000)begin
          count10k<=32'b0;
          clk_5k<=~clk_5k;
        end
        else begin
            count10k<=count10k+1;
        end
    end
end

always@(posedge fpga_clk, negedge rstn) begin //Making 1Hz Clk
    if(!rstn) begin
        Dividing_to_1Hz_count <= 0;
        sec_clk <= 1;
    end   
    else if(Dividing_to_1Hz_count == 26'd49999999) begin
        Dividing_to_1Hz_count <= 26'd0;
        sec_clk <= ~sec_clk;
    end   
    else begin
        Dividing_to_1Hz_count <= Dividing_to_1Hz_count + 1;
    end
end

always@(posedge sec_clk, negedge rstn) begin //Making 1Hz Clk
    if(!rstn) begin
        min_clk <= 1;
        sec_count <= 0;
    end   
    else if(sec_count == 5'd29) begin
        min_clk <= ~min_clk;
        sec_count <= 0;
    end   
    else begin
        sec_count <= sec_count + 5'd1;
    end
end

always@(posedge min_clk, negedge rstn) begin //Making 1Hz Clk
    if(!rstn) begin
        hour_clk <= 1;
        min_count <= 0;
    end   
    else if(min_count == 5'd29) begin
        hour_clk <= ~hour_clk;
        min_count <= 0;
    end   
    else begin
        min_count <= min_count + 5'd1;
    end
end

always@(posedge sec_clk, negedge rstn) begin
    if(!rstn) begin
        led_x <= 0;
    end
    else begin
        led_x[0] = ~led_x[0];
    end
 end
 
endmodule
