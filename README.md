# FPGA Traffic Light Controller (Arty Z7-20)


##  Overview

This project implements a **Traffic Light Control System** on the **Digilent Arty Z7-20** FPGA board. The system features a Finite State Machine (FSM) that manages traffic signals in two distinct modes: **Automatic (Timer-based)** and **Manual (Switch-based)**.

The design utilizes the Arty Z7's onboard 125 MHz clock, RGB LEDs for traffic signals, and external/Pmod interfaces for 7-segment countdown displays.

---

##  Key Features

* **Hardware Platform:** Designed specifically for the Xilinx XC7Z020 (Arty Z7-20).
* **Dual Operation Modes:**
    * **Auto Mode:** Cycles through Red, Green, and Yellow based on predefined timers (Red: 5s, Green: 3s, Yellow: 2s).
    * **Manual Mode:** Allows user control via onboard switches to force specific traffic lights.
* **Robust Input Handling:** Includes a **Debounce Logic** circuit for the mode toggle button to prevent mechanical noise.
* **Precise Timing:** Features a **Clock Divider** that converts the board's 125 MHz system clock down to a precise 1 Hz pulse for the countdown timer.
* **Display Output:** Provides BCD (Binary-Coded Decimal) outputs for interfacing with 7-segment displays to show remaining time.

---

##  Architecture Design

The system is modularized into four main components:

### 1. Clock Divider & Debouncer (`clock_divider.v`)
* **Input:** 125 MHz System Clock.
* **Function:**
    * Generates a 1 Hz enable signal for the FSM timer.
    * Filters the `btn_mode` input to eliminate mechanical bounce, ensuring clean mode transitions.

### 2. Finite State Machine (`fsm_traffic.v`)
The core logic controls the traffic lights based on the current mode:
* **State Encoding:** `GREEN (00)`, `YELLOW (01)`, `RED (10)`.
* **Auto Mode:** Transitions states when `remaining_sec` reaches 0.
* **Manual Mode:**
    * `sw[1] ON`: Force **GREEN**.
    * `sw[0] ON`: Force **YELLOW**.
    * `Default`: Force **RED**.

### 3. BCD Logic (`bcd_7seg.v`)
* Converts the 8-bit binary timer value (`remaining_sec`) into two 4-bit BCD signals (`seg_tens`, `seg_units`) for easy interfacing with 7-segment display drivers.

### 4. Top Module (`traffic_light_top.v`)
* Integrates all sub-modules and maps signals to the Arty Z7 I/O ports (RGB LEDs, Switches, Buttons).

---

##  Controls & IO Mapping

| Signal | Board Component | Description |
| :--- | :--- | :--- |
| `clk` | System Clock | 125 MHz Oscillator |
| `btn_mode` | Button (e.g., BTN0) | Toggle between Auto and Manual modes |
| `sw[1:0]` | Switches (SW1, SW0) | Control lights in Manual Mode |
| `led_r` | RGB LED (Red Channel) | Traffic Light Red |
| `led_g` | RGB LED (Green Channel)| Traffic Light Green |
| `led_b` | RGB LED (Blue Channel) | Traffic Light Yellow (mapped to Blue/Yellow) |
| `seg_tens/units`| Pmod / External Pins | Output to 7-Segment Display |

---
##  Simulation Results
The design was verified using Vivado. The waveform demonstrates the system switching between modes:

Manual Mode: Switches control the state directly.

Auto Mode: The timer decrements, and states transition automatically (Red -> Green -> Yellow).


##  How to Run on Arty Z7-20
Create Project: Open Vivado and create a new project targeting the Arty Z7-20 board.

Add Sources: Import all .v files from the src folder.

Add Constraints: Create a .xdc file to map pins. Example mapping:

Tcl

-Clock Signal:

set_property -dict { PACKAGE_PIN H16 IOSTANDARD LVCMOS33 } [get_ports { clk }]; 

-RGB LEDs (Example for RGB0):

set_property -dict { PACKAGE_PIN G17 IOSTANDARD LVCMOS33 } [get_ports { led_g }]; 

set_property -dict { PACKAGE_PIN L15 IOSTANDARD LVCMOS33 } [get_ports { led_b }]; # Using Blue for Yellow

set_property -dict { PACKAGE_PIN N15 IOSTANDARD LVCMOS33 } [get_ports { led_r }]; 

-Switches & Buttons:

set_property -dict { PACKAGE_PIN M20 IOSTANDARD LVCMOS33 } [get_ports { sw[0] }];

set_property -dict { PACKAGE_PIN M19 IOSTANDARD LVCMOS33 } [get_ports { sw[1] }];

set_property -dict { PACKAGE_PIN D19 IOSTANDARD LVCMOS33 } [get_ports { btn_mode }];

Generate Bitstream: Run Synthesis, Implementation, and Generate Bitstream.

-Program: Connect the Arty Z7 via USB and program the device.
