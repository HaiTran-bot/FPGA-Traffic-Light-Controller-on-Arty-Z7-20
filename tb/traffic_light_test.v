`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2025 12:49:01 AM
// Design Name: 
// Module Name: traffic_light_4way_tb
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
module traffic_light_test;

    // Inputs
    reg clk;
    reg btn_mode;
    reg [1:0] sw;

    // Outputs
    wire led_r;
    wire led_g;
    wire led_b;
    wire [3:0] seg_tens;
    wire [3:0] seg_units;

    // Instantiate the Unit Under Test (UUT)
    traffic_light_top uut (
        .clk(clk),
        .btn_mode(btn_mode),
        .sw(sw),
        .led_r(led_r),
        .led_g(led_g),
        .led_b(led_b),
        .seg_tens(seg_tens),
        .seg_units(seg_units)
    );

    // Clock generation (125 MHz, period 8 ns)
    always #4 clk = ~clk;  // Toggle every 4 ns for 125 MHz

    initial begin
        // Initialize inputs
        clk = 0;
        btn_mode = 0;
        sw = 2'b00;

        // Wait for initial state (RED)
        #100;

        // Toggle to switch mode (press btn_mode)
        btn_mode = 1;
        #10;
        btn_mode = 0;
        #50;

        // Test switch[0]: reset to red
        sw[0] = 1;
        #50;
        sw[0] = 0;
        #50;

        // Test switch[1] ON: red
        sw[1] = 1;
        #50;

        // Test switch[1] OFF: green
        sw[1] = 0;
        #50;

        // Toggle back to normal mode (press btn_mode again)
        btn_mode = 1;
        #10;
        btn_mode = 0;
        #50;

        // Let normal FSM run (with small counter in sim, assume modified for fast test)
        #500;  // Observe transitions: RED -> GREEN -> YELLOW -> RED...

        // Toggle to switch mode again
        btn_mode = 1;
        #10;
        btn_mode = 0;
        #50;

        // More switch tests
        sw = 2'b10;  // sw[1]=1, red
        #50;
        sw = 2'b00;  // green
        #50;

        $finish;  // End simulation
    end

    // Monitor outputs (optional for debugging)
    initial begin
        $monitor("Time=%0t | mode=%b | state=%b | remaining_sec=%d | led_r=%b | led_g=%b | led_b=%b",
                 $time, uut.fsm_inst.mode, uut.fsm_inst.state, uut.remaining_sec, led_r, led_g, led_b);
    end

endmodule