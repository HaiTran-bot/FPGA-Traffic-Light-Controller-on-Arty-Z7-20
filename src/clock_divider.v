`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 01:31:10 AM
// Design Name: 
// Module Name: clock_divider
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
module clock_divider (
    input wire clk,          // 125 MHz clock
    input wire btn_mode,     // Button for mode toggle
    output reg clk_1hz,      // 1 Hz clock output
    output reg btn_press     // Flag for button press edge
);
reg last_btn = 0;
reg [19:0] debounce_cnt = 0;
reg [26:0] counter = 0;      // Counter for 1 Hz (125_000_000 cycles)
always @(posedge clk) begin
    // Clock divider
    if (counter == 125_000_000 - 1) begin
//    if (counter == 5) begin
        counter <= 0;
        clk_1hz <= 1;
    end else begin
        counter <= counter + 1;
        clk_1hz <= 0;
    end
    // Button edge detection (press flag)
    btn_press <= 0;
    if (debounce_cnt > 0) begin
        debounce_cnt <= debounce_cnt - 1;
    end else if (btn_mode && !last_btn) begin
        btn_press <= 1;     
        debounce_cnt <= 20_000_000;
    end
    last_btn <= btn_mode; 
end
endmodule

