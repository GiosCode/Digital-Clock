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
				output reg [7:0] IO_SSEG,
				output reg [3:0] IO_SSEGD,
				output reg IO_SSEG_COL);
				
wire [3:0] w1;//For buttons
wire [7:0] w2;//For DSW
wire [7:0] w3;//For SSEG
wire [3:0] w4;//For SSEGD
wire w5;//For colon::::
wire w6;//for clock




endmodule
