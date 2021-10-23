`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Robert Jordan
// 
// Create Date: 18.08.2021 12:19:09
// Design Name: 
// Module Name: testPatternGen
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: A 12 patterns RGB test patern generator
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module testPatternGen

   //Paramiters set the frame and active frame size for the counter, this needs to match the system frame size, or at least the test pattern frame size

  #(parameter VIDEO_WIDTH = 3)
   
   
  (input       i_Clk, //pixel clock

   input [3:0] i_Pattern,
   input       i_HSync,
   input       i_VSync,
   output reg [VIDEO_WIDTH-1:0] o_Red_Video, //RGB OUTPUTS
   output reg [VIDEO_WIDTH-1:0] o_Grn_Video,
   output reg [VIDEO_WIDTH-1:0] o_Blu_Video
    );



//   Frame out size driven my external sync.
// Pattern is chosen with i_Pattern signal, 

// Patterns:
//  0: No Output


  
  wire w_VSync;
  wire w_HSync;
  
  
  // Patterns have 16 indexes (0 to 15) and can be g_Video_Width bits wide
  wire [VIDEO_WIDTH-1:0] Pattern_Red[0:15];
  wire [VIDEO_WIDTH-1:0] Pattern_Grn[0:15];
  wire [VIDEO_WIDTH-1:0] Pattern_Blu[0:15];
  
  // Make these unsigned counters (always positive)
  wire [10:0] w_Col_Count;
  wire [10:0] w_Row_Count;

  wire [6:0] w_Bar_Width; // test pattern bar width
  wire [2:0] w_Bar_Select;
  
  
  Sync_To_Count sync (.i_Clk      (i_Clk),
       .i_HSync    (i_HSync),
       .i_VSync    (i_VSync),
       .o_Col_Count(w_Col_Count),
       .o_Row_Count(w_Row_Count)
      );
	  

  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 0: Disables the Test Pattern Generator
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[0] = 0;
  assign Pattern_Grn[0] = 0;
  assign Pattern_Blu[0] = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 1: All White
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[1] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Grn[1] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Blu[1] = {VIDEO_WIDTH{1'b1}};
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 2: All Grey
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[2] = 1'b1;
  assign Pattern_Grn[2] = 1'b1;
  assign Pattern_Blu[2] = 1'b1;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 3: All Red
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[3] = {VIDEO_WIDTH{1'b1}} ; // 1 is replicated the width of the video width variable, change this to make it an 8 bit buss? for more complex images?
  assign Pattern_Grn[3] = 0;
  assign Pattern_Blu[3] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 4: All Green
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[4] = 0;
  assign Pattern_Grn[4] =  {VIDEO_WIDTH{1'b1}};
  assign Pattern_Blu[4] = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 5: All Blue
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[5] = 0;
  assign Pattern_Grn[5] = 0;
  assign Pattern_Blu[5] = {VIDEO_WIDTH{1'b1}};
  
   ////////////////////////////////////////////////////////////////////////////
  // Pattern 6: All Magenta
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[6] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Grn[6] = 0;
  assign Pattern_Blu[6] = {VIDEO_WIDTH{1'b1}};
  
   /////////////////////////////////////////////////////////////////////////////
  // Pattern 7: All Yellow
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[7] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Grn[7] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Blu[7] = 0;
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 8: All Cyan
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[8] = 0;
  assign Pattern_Grn[8] = {VIDEO_WIDTH{1'b1}};
  assign Pattern_Blu[8] = {VIDEO_WIDTH{1'b1}};
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 9: Checkerboard white/black
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[9] = w_Col_Count[8] ^ w_Row_Count[8] ? {VIDEO_WIDTH{1'b1}} : 0;
  assign Pattern_Grn[9] = Pattern_Red[9];
  assign Pattern_Blu[9] = Pattern_Red[9];
  
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 10: Color Bars
  // Divides active area into 8 Equal Bars and colors them accordingly
  // Colors Each According to this Truth Table:
  // R G B  w_Bar_Select  Ouput Color
  // 0 0 0       0        Black
  // 0 0 1       1        Blue
  // 0 1 0       2        Green
  // 0 1 1       3        Turquoise
  // 1 0 0       4        Red
  // 1 0 1       5        Purple
  // 1 1 0       6        Yellow
  // 1 1 1       7        White
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[10] = 0;
  assign Pattern_Red[10] = 0;
  assign Pattern_Red[10] = 0;

  /////////////////////////////////////////////////////////////////////////////
  // Pattern 11: Geometric Pattern 1
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[11] = ((w_Col_Count&60)==0) | ((w_Row_Count&60)==0);
  assign Pattern_Grn[11] = w_Row_Count[7];
  assign Pattern_Blu[11] = w_Col_Count[7];
  
  /////////////////////////////////////////////////////////////////////////////
  // Pattern 12: Geometric Pattern 2
  /////////////////////////////////////////////////////////////////////////////
  assign Pattern_Red[12] = ((w_Col_Count&60)==0) | ((w_Row_Count&60)==0);
  assign Pattern_Grn[12] = ((w_Col_Count&32)==0) & ((w_Row_Count&32)==0);
  assign Pattern_Blu[12] = ((w_Col_Count&40)==0) ^ ((w_Row_Count&40)==0);
  
  

//// Pattern Selection
  always @(posedge i_Clk)
  begin
    case (i_Pattern)
      4'h0 : 
      begin
	    o_Red_Video <= Pattern_Red[0];
        o_Grn_Video <= Pattern_Grn[0];
        o_Blu_Video <= Pattern_Blu[0];
      end
      4'h1 :
      begin
        o_Red_Video <= Pattern_Red[1];
        o_Grn_Video <= Pattern_Grn[1];
        o_Blu_Video <= Pattern_Blu[1];
      end
      4'h2 :
      begin
        o_Red_Video <= Pattern_Red[2];
        o_Grn_Video <= Pattern_Grn[2];
        o_Blu_Video <= Pattern_Blu[2];
      end
      4'h3 :
      begin
        o_Red_Video <= Pattern_Red[3];
        o_Grn_Video <= Pattern_Grn[3];
        o_Blu_Video <= Pattern_Blu[3];
      end
      4'h4 :
      begin
        o_Red_Video <= Pattern_Red[4];
        o_Grn_Video <= Pattern_Grn[4];
        o_Blu_Video <= Pattern_Blu[4];
      end
      4'h5 :
      begin
        o_Red_Video <= Pattern_Red[5];
        o_Grn_Video <= Pattern_Grn[5];
        o_Blu_Video <= Pattern_Blu[5];
      end
      4'h6 :
      begin
        o_Red_Video <= Pattern_Red[6];
        o_Grn_Video <= Pattern_Grn[6];
        o_Blu_Video <= Pattern_Blu[6];
      end
      4'h7 :
      begin
        o_Red_Video <= Pattern_Red[7];
        o_Grn_Video <= Pattern_Grn[7];
        o_Blu_Video <= Pattern_Blu[7];
      end
      4'h8 :
      begin
        o_Red_Video <= Pattern_Red[8];
        o_Grn_Video <= Pattern_Grn[8];
        o_Blu_Video <= Pattern_Blu[8];
      end
      4'h9 :
      begin
        o_Red_Video <= Pattern_Red[9];
        o_Grn_Video <= Pattern_Grn[9];
        o_Blu_Video <= Pattern_Blu[9];
      end
      4'ha :
      begin
        o_Red_Video <= Pattern_Red[9];
        o_Grn_Video <= Pattern_Grn[3];
        o_Blu_Video <= Pattern_Blu[2];
      end
      4'hb :
      begin
        o_Red_Video <= Pattern_Red[11];
        o_Grn_Video <= Pattern_Grn[11];
        o_Blu_Video <= Pattern_Blu[11];
      end
      4'hc :
      begin
        o_Red_Video <= Pattern_Red[12];
        o_Grn_Video <= Pattern_Grn[12];
        o_Blu_Video <= Pattern_Blu[12];
      end
      default:
      begin
        o_Red_Video <= Pattern_Red[0];
        o_Grn_Video <= Pattern_Grn[0];
        o_Blu_Video <= Pattern_Blu[0];
      end
    endcase
  end
endmodule

//Module generates visible pixel row and collum values 
module Sync_To_Count 
  (input            i_Clk,
  input             rst,
   input            i_HSync,
   input            i_VSync,
   output reg       o_HSync = 0, 
   output reg       o_VSync = 0,
   output reg [10:0] o_Col_Count = 0,
   output reg [10:0] o_Row_Count = 0);
   
   wire w_Frame_Start;
   
    // Register syncs to align with output data.
  always @(posedge i_Clk)
  begin
    o_VSync <= i_VSync;
    o_HSync <= i_HSync;
  end
  

   

  // Keep track of Row/Column counters.
  always @(posedge i_Clk)
    begin
    
        
        
        if(w_Frame_Start) begin
            o_Row_Count <= 0;
        end else begin
        
        if(h_Frame_Start) begin
            o_Col_Count <= 0;
            o_Row_Count <= o_Row_Count + 1;
        end else begin
            o_Col_Count <= o_Col_Count + 1;
        end
        
            
            
            
            
        end
    
    end
  

  
  // Vertical sync resets the module
  assign w_Frame_Start = (~o_VSync & i_VSync);
  assign h_Frame_Start = (~o_HSync & i_HSync);
  


  
endmodule