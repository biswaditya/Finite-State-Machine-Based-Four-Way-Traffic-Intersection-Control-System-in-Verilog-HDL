`timescale 1ns / 1ps

module TrafficSignal_FSM_Testing_TB();
reg clock,reset,enable;
wire R_road1,Y_road1,G_road1;
wire R_road2,Y_road2,G_road2;

TrafficSignal_FSM_Testing test1(clock,reset,enable,R_road1,Y_road1,G_road1,R_road2,Y_road2,G_road2);

always #1 clock=~clock;
initial
begin
clock=1;
reset=0;
enable=1;
#500;
enable=0;
#100;
enable=1;
#300;
reset=1;
#100;
$finish;
end

endmodule
