`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Robert Jordan
// 
// Create Date: 14.08.2021 19:56:23
// Design Name: 
// Module Name: clock_div
// Project Name: 
// Target Devices: Arty Z7
// Tool Versions: VIVADO 2020.2
// Description: 8-bit clock devider based on shift register
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module clock_div(

    input clk,
    input rst,
    output reg [7:0] Q
    );
 
always @ (posedge(clk), posedge(rst))   // When will Always Block Be Triggered
begin
    if (rst == 1'b1)
        // How Output reacts when Reset Is Asserted
        Q <= 8'b0;
    else
        // How Output reacts when Rising Edge of Clock Arrives?
        Q <= Q + 1'b1;
end
 

endmodule
