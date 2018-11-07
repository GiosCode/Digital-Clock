`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:48:31 11/04/2018 
// Design Name: 
// Module Name:    top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module top(input M_CLOCK,
				input [3:0] IO_PB,
				input [7:0] IO_DSW,
				output [7:0]IO_SSEG,
				output [3:0]IO_SSEGD,
				output IO_SSEG_COL);
				

wire setupflag;//
wire [1:0] dmode;
wire [1:0] dloc; //from dc to dd
wire w5;//For colon::::

wire [7:0] displayValue;


	DigitalClock DC0(.clk(M_CLOCK),.PB(IO_PB),.DSW(IO_DSW[7:0]),.setupMode(setupflag),.hourUpper(hourupper),.hourLower(hourlower),.minuteUpper(minuteupper),.minuteLower(minutelower),.secondCounter(seconds),.loc(dloc));
	ModeSelect MS0(.setUp(setupflag),.buttons(IO_PB),.mode(dmode));
	DisplayDriver D0(.clk(M_CLOCK),.mode(dmode),.minutesLower(minuteslower),.minutesUpper(minutesupper),.hoursLower(hourslower),.hoursUpper(hoursupper),.location(dloc),.SSEG(IO_SSEG),.SSEGD(IO_SSEGD),.SSEG_COL(IO_SSEG_COL));

//assign IO_SSEG = displayValue;
endmodule
