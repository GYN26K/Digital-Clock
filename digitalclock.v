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

    reg [27:0] clkdiv = 0;
    reg tick_1hz = 0;

    always @(posedge clk) begin
        if (reset) begin
            clkdiv <= 0;
            tick_1hz <= 0;
        end
        else if (clkdiv == 28'd49999999) begin
            clkdiv <= 0;
            tick_1hz <= 1;
        end
        else begin
            clkdiv <= clkdiv + 1;
            tick_1hz <= 0;
        end
    end

    reg [7:0] seconds = 8'h00;
    reg [7:0] minutes = 8'h00;
    reg [7:0] hours   = 8'h12;
    reg am = 1'b0;

    assign pm = am;

    always @(posedge clk) begin
        if (reset) begin
            seconds <= 8'h00;
            minutes <= 8'h00;
            hours   <= 8'h12;
            am      <= 0;
        end
        else if (ena && tick_1hz) begin

            // seconds
            if (seconds == 8'h59) begin
                seconds <= 8'h00;

                // minutes
                if (minutes == 8'h59) begin
                    minutes <= 8'h00;

                    // hours
                    if (hours == 8'h11) begin
                        hours <= 8'h12;
                        am <= ~am;
                    end
                    else if (hours == 8'h12) begin
                        hours <= 8'h01;
                    end
                    else begin
                        if (hours[3:0] == 9)
                            hours <= {hours[7:4] + 1, 4'd0};
                        else
                            hours <= hours + 1;
                    end

                end
                else begin
                    if (minutes[3:0] == 9)
                        minutes <= {minutes[7:4] + 1, 4'd0};
                    else
                        minutes <= minutes + 1;
                end

            end
            else begin
                if (seconds[3:0] == 9)
                    seconds <= {seconds[7:4] + 1, 4'd0};
                else
                    seconds <= seconds + 1;
            end

        end
    end

    reg [19:0] counter = 0;
    wire [1:0] select;
    reg [3:0] digit;

    assign select = counter[19:18];

    always @(posedge clk) begin
        if(reset)
            counter <= 0;
        else
            counter <= counter + 1;
    end

    // Digit selection
    always @(*) begin
        case(select)
            2'b00: begin an = 4'b1110; digit = seconds[3:0]; end
            2'b01: begin an = 4'b1101; digit = seconds[7:4]; end
            2'b10: begin an = 4'b1011; digit = minutes[3:0]; end
            2'b11: begin an = 4'b0111; digit = minutes[7:4]; end
            default: begin an = 4'b1111; digit = 4'd0; end
        endcase
    end

    // 7 segment decoder
    always @(*) begin
        case(digit)
            4'd0 : seg = 8'b00000001;
            4'd1 : seg = 8'b01001111;
            4'd2 : seg = 8'b00010010;
            4'd3 : seg = 8'b00000110;
            4'd4 : seg = 8'b01001100;
            4'd5 : seg = 8'b00100100;
            4'd6 : seg = 8'b00100000;
            4'd7 : seg = 8'b00001111;
            4'd8 : seg = 8'b00000000;
            4'd9 : seg = 8'b00000100;
            default: seg = 8'b11111111;
        endcase
    end

endmodule