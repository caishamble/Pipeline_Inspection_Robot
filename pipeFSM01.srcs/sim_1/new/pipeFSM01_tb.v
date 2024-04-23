`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 03/18/2024 10:08:32 AM
// Design Name:
// Module Name: instructor_tb_debug
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


module pipeFSM_tb;

    reg CLK; //clock
    reg [1:0] ONOFF; // on/off
    reg [7:0] LCN_0; //starting location
    reg [3:0] MTN_SENSOR; //maintenance sensor
    reg [3:0] CMPS; //compass
    reg [2:0] WLL; //wall locations
    
    wire [1:0] TURN;
    wire [3:0] FACINGDIR;
    wire DRIVING;
    wire [7:0] LOCATION;
    wire [2:0] ACTION;
    wire [4:0] STATE;
    
    // Clock generation
    initial begin
        CLK = 0;
        forever #2 CLK = ~CLK;
    end
    
    pipeFSM inst0(CLK,ONOFF,LCN_0,MTN_SENSOR,CMPS,WLL,TURN,DRIVING,LOCATION,ACTION,FACINGDIR,STATE);

    initial begin
    ONOFF=2'b01; LCN_0=8'b01100000; MTN_SENSOR=4'b0000; CMPS=4'b0000; WLL=3'b000;
    
//Initiate
    #10 ONOFF=2'b00; LCN_0=8'b00000000; MTN_SENSOR=4'b0000; CMPS=4'b0000; WLL=3'b000;
//block 1    
    #40 MTN_SENSOR=4'b0001; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;
    
//block2
    #40 MTN_SENSOR=4'b0100; CMPS=4'b1000; WLL=3'b011;
    #10 WLL=3'b000;
    
//block3
    #40 MTN_SENSOR=4'b0001; CMPS=4'b0001; WLL=3'b101;
    #10 WLL=3'b000;
    
//block4
    #40 MTN_SENSOR=4'b1000; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;

//block5
    #40 MTN_SENSOR=4'b0001; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;
    
//block6
    #40 MTN_SENSOR=4'b0001; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;
    
//block7
    #40 MTN_SENSOR=4'b0010; CMPS=4'b1000; WLL=3'b011;
    #10 WLL=3'b000;
    
//block8  
    #40 MTN_SENSOR=4'b0010; CMPS=4'b0001; WLL=3'b110;
    #10 WLL=3'b000;
    
//block9    
    #40 MTN_SENSOR=4'b0010; CMPS=4'b0001; WLL=3'b011;
    #10 WLL=3'b000;

//block10
    #40 MTN_SENSOR=4'b0100; CMPS=4'b0010; WLL=3'b101;
    #10 WLL=3'b000;
    
//block11
    #40 MTN_SENSOR=4'b0001; CMPS=4'b0001; WLL=3'b110;
    #10 WLL=3'b000;
    
//block12
    #40 MTN_SENSOR=4'b1000; CMPS=4'b0001; WLL=3'b101;
    #10 WLL=3'b000;
    
//block13
    #40 MTN_SENSOR=4'b0001; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;
    
//block14
    #40 MTN_SENSOR=4'b0100; CMPS=4'b1000; WLL=3'b110;
    #10 WLL=3'b000;
    
    #40 ONOFF=2'b10; MTN_SENSOR=4'b0001; CMPS=4'b1000; WLL=3'b110;
    #10 ONOFF=2'b00; WLL=3'b000;
    end


endmodule


