`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 01:34:18 AM
// Design Name: 
// Module Name: bcd_7seg
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
module bcd_7seg (
    input [7:0] count,       // Binary count (0-99)
    output [3:0] seg_tens,   // BCD for tens digit
    output [3:0] seg_units   // BCD for units digit
);
assign seg_tens = count / 10;
assign seg_units = count % 10;

endmodule
