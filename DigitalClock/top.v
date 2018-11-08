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
				output IO_SSEG_COL,
				output prob);
				

//wire setupflag;//
//wire [1:0] dmode;
//wire [1:0] dloc; //from dc to dd
//wire w5;//For colon::::
//
//wire [7:0] displayValue;

wire DCsetupMode;
wire [3:0]DChourUpper;
wire [3:0]DChourLower;
wire [3:0]DCminuteUpper;
wire [3:0]DCminuteLower;
wire [5:0]DCsecondCounter;
wire [1:0]DClocation;

wire [1:0]MSmode;

wire [7:0] DDSSEG;
wire [3:0] DDSSEGD;
wire DDSSEG_COL;
	///////////////////////////////////////
	DigitalClock DC0(.clk(M_CLOCK),
		.PB(IO_PB),
		.DSW(IO_DSW),
		.setupMode(DCsetupMode),
		.hourUpper(DChourUpper),
		.hourLower(DChourLower),
		.minuteUpper(DCminuteUpper),
		.minuteLower(DCminuteLower),
		.secondCounter(DCsecondCounter),
		.loc(DClocation));
	////////////////////////////////////////
	ModeSelect MS0(.setUp(DCsetupMode),
		.buttons(IO_PB),
		.mode(MSmode));
	///////////////////////////////////////
	DisplayDriver DD0(.clk(M_CLOCK),
		.mode(MSmode),
		.minutesLower(DCminuteLower),
		.minutesUpper(DCminuteUpper),
		.hoursLower(DChourLower),
		.hoursUpper(DChourUpper),
		.location(DClocation),
		.SSEG(DDSSEG),
		.SSEGD(DDSSEGD),
		.SSEG_COL(DDSSEG_COL));
	///////////////////////////////////////
	assign IO_SSEG = DDSSEG;
	assign IO_SSEGD = DDSSEGD;
	assign IO_SSEG_COL = DDSSEG_COL;
	assign  prob = DCsecondCounter;
	//DigitalClock DC0(.clk(M_CLOCK),.PB(IO_PB),.DSW(IO_DSW[7:0]),.setupMode(setupflag),.hourUpper(hourupper),.hourLower(hourlower),.minuteUpper(minuteupper),.minuteLower(minutelower),.secondCounter(seconds),.loc(dloc));
	//ModeSelect MS0(.setUp(setupflag),.buttons(IO_PB),.mode(dmode));
	//DisplayDriver D0(.clk(M_CLOCK),.mode(dmode),.minutesLower(minuteslower),.minutesUpper(minutesupper),.hoursLower(hourslower),.hoursUpper(hoursupper),.location(dloc),.SSEG(IO_SSEG),.SSEGD(IO_SSEGD),.SSEG_COL(IO_SSEG_COL));

//assign IO_SSEG = displayValue;
endmodule
