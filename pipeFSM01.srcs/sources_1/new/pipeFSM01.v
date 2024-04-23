`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/14/2024 05:18:35 PM
// Design Name:
// Module Name: pipeFSM
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


module pipeFSM(
    input clk,
    input [1:0] onoff, // [off,on]
    input [7:0] strt_lcn, // Assuming 4-bit for each x and y
    input [3:0] mtn_sensor, // Encoding Fzn, Hot, Jamm, Free
    input [3:0] cmps,  // Compass direction  [N,E,S,W]
    input [2:0] wll, // Wall location [L, R, F]
   
    output reg [1:0] turn, // Turn Left, Turn Right
    output reg driving, // Drive
    output reg [7:0] location, // Current location
    output reg [2:0] action,// Fire, Cool, Plunge
    output reg [3:0] facing_dir, // facing turn, [N,E,S,W]
    
    output reg [4:0] State
    );
   
    parameter Off       = 0;
    parameter Idle      = 1;
    parameter Turn_Left = 2;
    parameter Turn_Right= 3;
    parameter Comp_Lshift=4;
    parameter Comp_pass= 5;
    parameter Comp_Rshift=6;
    parameter Move      = 7;
    parameter Hot0      = 8;
    parameter Hot1      = 9;
    parameter Hot2      = 10;
    parameter Plg0      = 11;
    parameter Plg1      = 12;
    parameter Plg2      = 13;
    parameter Plg3      = 14;
    parameter Fzn0      = 15;
    parameter Fzn1      = 16;
    parameter Fzn2      = 17;
    parameter Fzn3      = 18;
    parameter Fzn4      = 19;

                   
      
      
      initial begin State = Idle; end
     
      always @(posedge clk) begin
         
              // State transitions
           case (State)
             
                 Off: if ((onoff == 2'b10) && (strt_lcn != 0))  State = Idle;
             
                 Idle:  begin
                       if (onoff == 2'b10) State = Off;
                       else if (wll == 3'b000) State = Idle;
                       else if (wll == 3'b011) State = Turn_Left;
                       else if (wll == 3'b110) State = Comp_pass;
                       else if (wll == 3'b101) State = Turn_Right;
                  end
                       
                
                 
                  Turn_Left: State = Comp_Lshift;                  
                  Turn_Right: State = Comp_Rshift;                
                  Comp_Lshift: State = Move;
                  Comp_pass: State = Move;               
                  Comp_Rshift: State = Move;
                
                  Move: begin
                        if (mtn_sensor == 4'b1000) State = Fzn0;
                        else if (mtn_sensor == 4'b0010) State = Plg0;
                        else if (mtn_sensor == 4'b0100) State = Hot0;
                        else if (mtn_sensor == 4'b0001) State = Idle; 
                  end                   
                 
                  Hot0: State = Hot1;               
                  Hot1: State = Hot2;                 
                  Hot2: State = Idle;
                 
                  Plg0: State = Plg1;                
                  Plg1: State = Plg2;                
                  Plg2: State = Plg3;                
                  Plg3: State = Fzn4;
                                  
                  Fzn0: State = Fzn1;              
                  Fzn1: State = Fzn2;                
                  Fzn2: State = Fzn3;                
                  Fzn3: State = Fzn4;
                  Fzn4: State = Idle;                 

              endcase
      end
      
      always @(State) begin
         // State actions
         case (State)
            Idle:begin
            if (onoff == 2'b01) begin
                 location = strt_lcn; end
                 action = 3'b000;
                 driving = 0;
            end
             
             Turn_Left: turn = 2'b10;
             Turn_Right: turn = 2'b01;
             
             Comp_Lshift:begin
                 turn = 2'b00;
                 facing_dir = (cmps << 1) + cmps[3];
             end
             
             Comp_pass: facing_dir = cmps;
             
             Comp_Rshift: begin
                  turn = 2'b00;
                  facing_dir = (cmps >> 1) +(cmps[0] << 3);  
             end
             
             Move: begin
                driving = 1;
                if (facing_dir == 4'b0001) begin
                    location = location - 16;
                end else if (facing_dir == 4'b0010) begin
                    location = location - 1;
                end else if (facing_dir == 4'b0100) begin
                    location = location + 16;
                end else if (facing_dir == 4'b1000) begin
                    location = location + 1;
                end
             end
            
             
             Hot0:begin
                 action = 3'b010;
                 driving = 0;
             end
             
             Hot1: action = 3'b010;             
             Hot2: action = 3'b010; 
             
             Plg0:begin
                 action = 3'b001;
                 driving = 0;
             end
             
             Plg1: action = 3'b000;            
             Plg2: action = 3'b001;             
             Plg3: action = 3'b000;
             
             Fzn0:begin
                 action = 3'b100;
                 driving = 0;
             end
             
             Fzn1: action = 3'b100;            
             Fzn2: action = 3'b000;             
             Fzn3: action = 3'b100;          
             Fzn4: action = 3'b100;

         endcase
     end
                 
endmodule