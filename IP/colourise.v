`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: CFOGE
// Engineer: Robert D Jordan 
// 
// Create Date: 26.06.2021 17:36:42
// Design Name: 
// Module Name: colourise
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2 
// Description: Coloursises video luma data, giving false colour
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module colourise(
        input [23:0] vid_pData_in, //video data in
        input [2:0] mode,
        output [23:0] vid_pData_out //colour pixel data out
    );
    
    wire [7:0] luma;
    reg [23:0] vid;
    reg [7:0] red;
    reg [7:0] green;
    reg [7:0] blue;
    
    rgb_2_luma lumaData(
        .vid_pData_in(vid_pData_in),
        .en(1'b1),
        .vid_pData_out(luma)
    );

    always @ (vid_pData_in, mode) begin
      case (mode)
        3'b001 : //false colour 1
        begin 
         if ((luma >=0) && (luma<=50))
            begin
            red = 252; //colour red
            green = 3;
            blue = 3;
            vid = {blue, green, red};
            end
            
        if ((luma >=51) && (luma<=100))
            begin
            red = 252; //colour yellow
            green = 240;
            blue = 3;
            vid = {blue, green, red};
            end
            
        if ((luma >=101) && (luma<=150))
            begin
            red = 3; //colour green
            green = 252;
            blue = 107;
            vid = {blue, green, red};
            end
            
        if ((luma >=151) && (luma<=200))
            begin
            red = 3; //colour blue
            green = 198;
            blue = 252;
            vid = {blue, green, red};
            end
            
        if ((luma >=201) && (luma<=255))
            begin
            red = 219; //colour purple
            green = 3;
            blue = 252;
            vid = {blue, green, red};
            end
        end
          
       
          
        default :
            begin
                vid = vid_pData_in;
            end
                  
      endcase
            
    end
    
    assign vid_pData_out = vid;
    
endmodule
