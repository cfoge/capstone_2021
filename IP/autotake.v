`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Robert Jordan
// 
// Create Date: 14.08.2021 17:32:18
// Design Name: 
// Module Name: autotake
// Project Name: 
// Target Devices: Arty Z7
// Tool Versions: VIVADO 2020.2
// Description: Auto take module *NOT FULLY WORKING!*
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module autotake(

    input clk, //the input clock
    
    input trigA, // trigger for the autotake to A Bus
    input trigB, // trigger for the autotake to B bus
    input rst, //reset 
    input [2:0] speed, //fade speed 0-8
    
    input [9:0] tbar, //the value of the tbar (real or virtual)
    
    output autoFadeDone,
    output [9:0] mix_val, // a generic value for mixing/whiping
    output fadeclk, // debgug to check fader is running
    output [1:0] state
    );
    
    reg [9:0] tbarTemp;
    reg [9:0] tbarVirtual;
    wire [9:0] tbarVertualWire;
    reg [9:0] fadeTo; //value to fade the auto take to
    reg dir ; // the direction to run the autotake
    reg [9:0] stepCounter; // counter to transition the 10bit interp from tbar val to min or max
    reg autoDoneFlag; // a flag which goes high when the auto take finishes, 
    reg autoTakeActive;
    wire [9:0] mix_out;
    wire [7:0] fade_clk; // the cock that drives the step counter
    
    clock_div clockDelay(
        .clk(clk),
        .rst(rst),
        .Q(fade_clk)
    );
    
    interp_10bit interpTbar(
        .clk1x(clk),
        .strm0(fadeTo),
        .strm1(tbarVertualWire),//source when mix val = 0 // should be from virtual tbar
        .alpha_strm(stepCounter),
        .blnd(mix_out)
    
    );
    assign state = State;
    assign fadeclk = stepCounter[3];
    //assign fadeclk = fadeClkTrig;
    assign tbarVertualWire = tbarVirtual;
    assign autoFadeDone = autoDoneFlag;
    assign mix_val = mix_out;
    
    
    //auto fade State Machine
    reg [1:0]State;
    localparam Start = 2'b00;
    localparam Idle = 2'b01;
    localparam Work = 2'b11;
    localparam Done = 2'b10;
    
    reg tReset;
    
    always @(posedge clk) begin
        tReset <= rst;
        if(tReset) begin
            
            State <= Start;
        end else begin
        
        case(State)
                    Start: begin                     
                        State <= Idle;
                    end
                    Idle: begin
                     if(trigA | trigB)
                        begin 
                            State <= Work;
                           
                        end
                        
                     if(trigA & !trigB)
                        begin 
                            dir <= 1'b0;
                        end
                        
                     if(!trigA & trigB)
                        begin 
                            dir <= 1'b1;
                        end
                        
                    end
                    Work: begin
                           if(autoTakeActive == 1'b0)
                            begin
                                State <= Done;
                            end else if(tbarValChange & (trigA == 0) & (trigB == 0))
                            begin
                                State <= Done;
                                
                            end
                            
                            
                    end
                    Done: begin                   
                        State <= Idle;
                    end
                    default:;
                endcase
            end
        end
        
        
        always @ (clk) begin // set auto take direction
        //State start logic
        if(State == Start)
            begin
                stepCounter <= 10'b0;
                autoTakeActive <= 1'b0;
                autoDoneFlag <= 1'b0;
                tbarVirtual <= tbar;
            end
            
        if(State == Idle)
                autoTakeActive <= 1'b0;
                
                begin
                if (dir == 1'b0) begin
                    fadeTo <= 10'd0; //min fade val
                end else if
                 (dir == 1'b1) begin
                    fadeTo <= 10'd1023; //max fade val
                end
                
                if(autoDoneFlag)
                begin
                    tbarVirtual <= mix_out;
                    autoDoneFlag <= 1'b0;
                end
                
               if(tbarValChange & !trigA & !trigB)
               begin
                    tbarVirtual <= tbar;
               end
                
               
        end
        
        if(State == Work)
        begin
        
               if(tbarValChange & !trigA & !trigB)
                begin
                    tbarVirtual <= tbar;
                    autoTakeActive <= 1'b0;
                    autoDoneFlag <= 1'b1;
                end
        
         if( stepCounter == 10'd1023 ) begin //if we have reached the end of the auto take set the done flag high        
            autoTakeActive <= 1'b0;
            autoDoneFlag <= 1'b1;
         end 
         else begin
                    if(fadeClkTrig )
                    begin
                        stepCounter <= stepCounter + 1; 
                    end
                    autoDoneFlag <= 1'b0;
                    autoTakeActive <= 1'b1;
                end
        end
        
        if(State == Done) 
        begin
            stepCounter <= 10'b0;
            autoTakeActive <= 1'b0;
            autoDoneFlag <= 1'b0;
        end
                    
                
        end
    
        always @ (posedge clk) begin 
            i_fadeTrig <= fade_clk[speed];
            o_fadeTrig <= i_fadeTrig;
            tbarTemp <= tbar;
            
            if(tbarTemp != tbar)
                begin
                    tbarValChange = 1'b1;
                end
            else
                begin
                    tbarValChange = 1'b0;
                end
        end
        
        wire fadeClkTrig;
        reg o_fadeTrig;
        reg i_fadeTrig;
        assign fadeClkTrig = (~o_fadeTrig & i_fadeTrig);
        
        reg tbarValChange;
        

         
    
endmodule
