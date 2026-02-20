`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2026 11:09:49
// Design Name: 
// Module Name: digclock
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


module top_module(
    input clk,
    input reset,
    input ena,
    output pm,
    output reg [7:0] seg,
    output reg [3:0] an
);

    reg h1clk = 0;
    reg [9:0] dig1 = 0;
    reg [9:0] dig2 = 0;
    reg [7:0] dig3 = 0;

    always @(posedge clk) begin
        if (reset) begin
            dig1  <= 0;
            dig2  <= 0;
            dig3  <= 0;
            h1clk <= 0;
        end
        else begin
            if (dig1 == 10'd1000) begin
                dig1 <= 0;

                if (dig2 == 10'd1000) begin
                    dig2 <= 0;

                    if (dig3 == 8'd100) begin
                        dig3  <= 0;
                        h1clk <= ~h1clk;
                    end
                    else begin
                        dig3 <= dig3 + 1;
                    end
                end
                else begin
                    dig2 <= dig2 + 1;
                end
            end
            else begin
                dig1 <= dig1 + 1;
            end
        end
    end


    reg [7:0] seconds = 8'h00;
    reg [7:0] minutes = 8'h00;
    reg [7:0] hours   = 8'h12;
    reg am = 1'b0;

    assign pm = am;

    always @(posedge clk) begin
        if (reset) begin
            seconds <= 0;
            minutes <= 0;
            hours   <= 8'h12;
            am      <= 0;
        end
        else if (ena && h1clk) begin
            if (seconds == 8'h59) begin
                seconds <= 0;

                if (minutes == 8'h59) begin
                    minutes <= 0;

                    if (hours == 8'h12) begin
                        hours <= 8'h01;
                        am <= ~am;
                    end
                    else begin
                        hours <= hours + 1;
                    end
                end
                else begin
                    minutes <= minutes + 1;
                end
            end
            else begin
                seconds <= seconds + 1;
            end
        end
    end


    reg [19:0] counter = 0;
    wire [1:0] select;
    reg [3:0] digit;

    assign select = counter[19:18];

    always @(posedge clk) begin
        counter <= counter + 1;
    end

    always @(*) begin
        case(select)
            2'b00: begin an = 4'b1110; digit = seconds[3:0]; end
            2'b01: begin an = 4'b1101; digit = seconds[7:4]; end
            2'b10: begin an = 4'b1011; digit = minutes[3:0]; end
            2'b11: begin an = 4'b0111; digit = minutes[7:4]; end
        endcase
    end


    always @(*) begin
        case(digit)
            4'd0 : seg = 8'b00000011;
            4'd1 : seg = 8'b10011111;
            4'd2 : seg = 8'b00100011;
            4'd3 : seg = 8'b00001101;
            4'd4 : seg = 8'b10011001;
            4'd5 : seg = 8'b01001001;
            4'd6 : seg = 8'b01000001;
            4'd7 : seg = 8'b00011111;
            4'd8 : seg = 8'b00000001;
            4'd9 : seg = 8'b00001001;
            default: seg = 8'b11111111;
        endcase
    end

endmodule

