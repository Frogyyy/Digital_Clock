`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/01/16 23:07:50
// Design Name: 
// Module Name: Digital_Clock
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


module Digital_Clock(
    input rstn,
    input sec_clk, // 1Hz
    input min_clk,
    input hour_clk,
    input clk_5k,
    
    output reg [7:0] digit,
    output reg [6:0] seg
    );
    reg  [ 6:0] seg0, seg1, seg2, seg3, seg4, seg5, seg6, seg7;
    reg  [ 5:0] SEC;
    reg  [ 5:0] MIN;
    reg  [ 4:0] HOUR;   
    reg  [ 3:0] SEC_ONES;
    reg  [ 3:0] SEC_TENS;
    reg  [ 3:0] MIN_ONES;
    reg  [ 3:0] MIN_TENS;
    reg  [ 3:0] HOUR_ONES;
    reg  [ 3:0] HOUR_TENS;
    
    always@(SEC, MIN, HOUR) begin
        SEC_ONES  <= SEC%10;
        SEC_TENS  <= SEC/10;
        MIN_ONES  <= MIN%10;
        MIN_TENS  <= MIN/10;
        HOUR_ONES <= HOUR%10;
        HOUR_TENS <= HOUR/10;
    end
    
    always @(posedge sec_clk, negedge rstn) begin
        if(!rstn) begin
            SEC <= 0;
        end    
        else if(SEC == 6'd59) begin
            SEC <= 6'd0;
        end     
        else begin
            SEC <= SEC + 1;
        end
    end
    
    always @(posedge min_clk, negedge rstn) begin
        if(!rstn) begin
            MIN <= 0;
        end    
        else if(MIN == 6'd59) begin
            MIN <= 6'd0;
        end     
        else begin
            MIN <= MIN + 1;
        end
    end
    
    always @(posedge hour_clk, negedge rstn) begin
        if(!rstn) begin
            HOUR <= 0;
        end    
        else if(HOUR == 5'd23) begin
            HOUR <= 5'd0;
        end     
        else begin
            HOUR <= HOUR + 1;
        end
    end
    
    always@(posedge clk_5k, negedge rstn) begin // 1600us 마다 1개 7segment 갱신 // 200us 마다 digit 변경됨
        if(!rstn) begin
            digit <= 8'b11111110;
            seg2 <= 7'b1111110;
            seg5 <= 7'b1111110;
        end
        else begin
            digit <= {digit[6:0], digit[7]};
        end
    end
    
    always@(digit or seg0 or seg1 or seg2 or seg3 or seg4 or seg5 or seg6 or seg7) begin
        case(digit)
        8'b11111110 : seg = seg0;
        8'b11111101 : seg = seg1;
        8'b11111011 : seg = seg2; // min - sec 사이 "-" 표기 7segment = 7'b0000001
        8'b11110111 : seg = seg3;
        8'b11101111 : seg = seg4;
        8'b11011111 : seg = seg5; // min - hour 사이 "-" 표기 7segment = 7'b0000001
        8'b10111111 : seg = seg6;
        8'b01111111 : seg = seg7;
        default:seg = 7'b0;
        endcase 
    end
    
    always@(SEC_ONES) begin
        case(SEC_ONES)
        4'd0 : seg0 = 7'b0000001;
        4'd1 : seg0 = 7'b1001111;
        4'd2 : seg0 = 7'b0010010;
        4'd3 : seg0 = 7'b0000110;
        4'd4 : seg0 = 7'b1001100;
        4'd5 : seg0 = 7'b0100100;
        4'd6 : seg0 = 7'b0100000;
        4'd7 : seg0 = 7'b0001111;
        4'd8 : seg0 = 7'b0000000;
        4'd9 : seg0 = 7'b0000100;
        default:seg0 = 7'b0;
        endcase        
    end
    
    always@(SEC_TENS) begin
        case(SEC_TENS)
        4'd0 : seg1 = 7'b0000001;
        4'd1 : seg1 = 7'b1001111;
        4'd2 : seg1 = 7'b0010010;
        4'd3 : seg1 = 7'b0000110;
        4'd4 : seg1 = 7'b1001100;
        4'd5 : seg1 = 7'b0100100;
        default:seg1 = 7'b0;
        endcase        
    end
    
    always@(MIN_ONES) begin
        case(MIN_ONES)
        4'd0 : seg3 = 7'b0000001;
        4'd1 : seg3 = 7'b1001111;
        4'd2 : seg3 = 7'b0010010;
        4'd3 : seg3 = 7'b0000110;
        4'd4 : seg3 = 7'b1001100;
        4'd5 : seg3 = 7'b0100100;
        4'd6 : seg3 = 7'b0100000;
        4'd7 : seg3 = 7'b0001111;
        4'd8 : seg3 = 7'b0000000;
        4'd9 : seg3 = 7'b0000100;
        default:seg3 = 7'b0;
        endcase        
    end
    
    always@(MIN_TENS) begin
        case(MIN_TENS)
        4'd0 : seg4 = 7'b0000001;
        4'd1 : seg4 = 7'b1001111;
        4'd2 : seg4 = 7'b0010010;
        4'd3 : seg4 = 7'b0000110;
        4'd4 : seg4 = 7'b1001100;
        4'd5 : seg4 = 7'b0100100;
        default:seg4 = 7'b0;
        endcase        
    end
    
    always@(HOUR_ONES) begin
        case(HOUR_ONES)
        4'd0 : seg6 = 7'b0000001;
        4'd1 : seg6 = 7'b1001111;
        4'd2 : seg6 = 7'b0010010;
        4'd3 : seg6 = 7'b0000110;
        4'd4 : seg6 = 7'b1001100;
        4'd5 : seg6 = 7'b0100100;
        4'd6 : seg6 = 7'b0100000;
        4'd7 : seg6 = 7'b0001111;
        4'd8 : seg6 = 7'b0000000;
        4'd9 : seg6 = 7'b0000100;
        default:seg6 = 7'b0;
        endcase        
    end
    
    always@(HOUR_TENS) begin
        case(HOUR_TENS)
        4'd0 : seg7 = 7'b0000001;
        4'd1 : seg7 = 7'b1001111;
        4'd2 : seg7 = 7'b0010010;
        default:seg7 = 7'b0;
        endcase        
    end    
    
endmodule
