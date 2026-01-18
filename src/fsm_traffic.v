`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/30/2025 01:35:57 AM
// Design Name: 
// Module Name: fsm_traffic
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
module fsm_traffic (
    input wire clk,         
    input wire clk_1hz,      
    input wire btn_press,   
    input wire [1:0] sw,
    output reg [7:0] remaining_sec,
    output reg led_r,
    output reg led_g,
    output reg led_b
);

    // State definitions
    localparam [1:0] GREEN = 2'b00, YELLOW = 2'b01, RED = 2'b10;
    // Durations
    localparam [7:0] RED_DUR = 8'd5, GREEN_DUR = 8'd3, YEL_DUR = 8'd2;
    
    reg [1:0] state = RED;
    reg mode = 0; // 0: normal, 1: switch control

    initial remaining_sec = RED_DUR;

    always @(posedge clk) begin
        if (btn_press) begin
            mode <= ~mode;
            if (mode == 1) begin // Đang ở mode 1 chuyển về 0 (Normal)
                state <= RED;
                remaining_sec <= RED_DUR;
            end else begin       // Đang ở mode 0 chuyển sang 1 (Manual)
                remaining_sec <= 0;
                if (sw[0]) state <= YELLOW;
                else if (sw[1]) state <= GREEN;
                else state <= RED;
            end
        end 
        
        else begin
            if (mode == 0) begin // Normal mode
                if (clk_1hz) begin
                    if (remaining_sec == 0) begin
                        case (state)
                            GREEN: begin state <= YELLOW; remaining_sec <= YEL_DUR; end
                            YELLOW: begin state <= RED; remaining_sec <= RED_DUR; end
                            RED: begin state <= GREEN; remaining_sec <= GREEN_DUR; end
                            default: state <= RED;
                        endcase
                    end else begin
                        remaining_sec <= remaining_sec - 1;
                    end
                end
            end 
            else begin
                if (sw[0]) begin state <= YELLOW; remaining_sec <= 0; end
                else if (sw[1]) begin state <= GREEN; remaining_sec <= 0; end
                else begin state <= RED; remaining_sec <= 0; end
            end
        end
    end

    // Output logic
    always @(*) begin
        led_r = 0; led_g = 0; led_b = 0;
        case (state)
            GREEN: led_g = 1;
            YELLOW: led_b = 1;
            RED: led_r = 1;
        endcase
    end
endmodule
