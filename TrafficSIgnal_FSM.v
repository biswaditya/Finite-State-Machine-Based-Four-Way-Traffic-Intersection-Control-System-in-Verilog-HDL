`timescale 1ns / 1ps

module TrafficSignal_FSM(input clock_300MHz,
input reset,
input enable,
output reg R_road1,Y_road1,G_road1,
output reg R_road2,Y_road2,G_road2
);

parameter idle=3'd0,SRG=3'd1,SRY=3'd2,SGR=3'd3,SYR=3'd4;

reg [2:0] state;
reg [2:0] next_state;
reg [34:0] c;

initial
begin
state = idle;
next_state = idle;
c=0;
end

always@(posedge clock_300MHz)
begin
if(reset)
state<=idle;
else
state<=next_state;
end

always@(posedge clock_300MHz)
begin
    if(enable)
    begin
    case(state)
        idle : begin c<=0; next_state<=SRG; end
        SRG   : begin if(c<300000000*60-1)
                     begin
                     next_state<=SRG;
                     c<=c+1;
                     end
                     else
                     begin
                     c<=0;
                     next_state<=SRY;
                     end
               end
        SRY   : begin if(c<300000000*3-1) 
                     begin
                     next_state<=SRY;
                     c<=c+1;
                     end
                     else
                     begin
                     c<=0;
                     next_state<=SGR;
                     end
               end
        SGR   : begin if(c<300000000*60-1) 
                      begin
                      next_state<=SGR;
                      c<=c+1;
                      end
                      else
                      begin
                      c<=0;
                      next_state<=SYR;
                      end
                end      
        SYR   : begin if(c<300000000*3-1) 
                      begin
                      next_state<=SYR;
                      c<=c+1;
                      end
                      else
                      begin
                      c<=0;
                      next_state<=SRG;
                      end              
               end
       default : begin c=0; next_state<=idle; end
    endcase
    end
end

always @(posedge clock_300MHz)
begin
    case(state)
        idle : begin R_road1=0;Y_road1=0;G_road1=0;
                     R_road2=0;Y_road2=0;G_road2=0;
               end
        SRG :  begin R_road1=1;Y_road1=0;G_road1=0;
                     R_road2=0;Y_road2=0;G_road2=1;
               end       
        SRY :  begin R_road1=1;Y_road1=0;G_road1=0;
                     R_road2=0;Y_road2=1;G_road2=0;
               end
        SGR :  begin R_road1=0;Y_road1=0;G_road1=1;
                     R_road2=1;Y_road2=0;G_road2=0;
               end
        SYR :  begin R_road1=0;Y_road1=1;G_road1=0;
                     R_road2=1;Y_road2=0;G_road2=0;
               end                      
     default : begin R_road1=0;Y_road1=0;G_road1=0;
                     R_road2=0;Y_road2=0;G_road2=0;
               end                                     
    endcase
end
 
endmodule
