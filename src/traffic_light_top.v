`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 12:48:37 AM
// Design Name: 
// Module Name: traffic_light_4way
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
module traffic_light_top (
    input wire clk,          // 125 MHz system clock
    input wire btn_mode,     // Button for mode toggle
    input wire [1:0] sw,     // Switches [1:0]
    output wire led_r,       // RGB Red
    output wire led_g,       // RGB Green
    output wire led_b,       // RGB Yellow (blue)
    output wire [3:0] seg_tens,  // 7-seg tens BCD
    output wire [3:0] seg_units // 7-seg units BCD
);

wire clk_1hz;
wire btn_press;
wire [7:0] remaining_sec;

// Clock divider and button handler
clock_divider clk_div_inst (
    .clk(clk),
    .btn_mode(btn_mode),
    .clk_1hz(clk_1hz),
    .btn_press(btn_press)
);

// FSM traffic light
fsm_traffic fsm_inst (
    .clk(clk),
    .clk_1hz(clk_1hz),
    .btn_press(btn_press),
    .sw(sw),
    .remaining_sec(remaining_sec),
    .led_r(led_r),
    .led_g(led_g),
    .led_b(led_b)
);

// BCD to 7-segment
bcd_7seg bcd_inst (
    .count(remaining_sec),
    .seg_tens(seg_tens),
    .seg_units(seg_units)
);

endmodule