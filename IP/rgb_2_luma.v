`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Robert D Jordan
// 
// Create Date: 24.06.2021 17:24:01
// Design Name: 
// Module Name: rgb_2_luma
// Project Name: 
//Target Devices: Arty Z7
// Tool Versions: Vivado 2020.2
// Description: Converts RGB channels to luma channel
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module rgb_2_luma(
        input [23:0] vid_pData_in,
        input en,
        output [23:0] vid_pData_out
    );
    
    
    reg [23:0] vid;
    reg [7:0] luma;
    wire [7:0] blue =  vid_pData_in[7:0];
    wire [7:0] green =  vid_pData_in[15:8];
    wire [7:0] red =  vid_pData_in[23:16];
    
    always @(en or vid_pData_in)
    if(en)
        begin
        vid <= {3{luma}};
        end
        else begin
        vid <= vid_pData_in;
        end
        
    always @ (vid_pData_in) begin
        luma = ((red+green+blue)/3); //Arethmatic mean
    end
    
    assign vid_pData_out = vid;
    

endmodule
