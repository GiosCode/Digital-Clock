`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:58:48 11/04/2018 
// Design Name: 
// Module Name:    DisplayDriver 
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
module DisplayDriver(input [1:0] location,
							input [3:0] digit,
							input [1:0] mode,
							input M_CLOCK,
							output reg [7:0] IO_SSEG,
							output reg [3:0] IO_SSEGD,
							output reg IO_SSEG_COL,
							output reg [7:0] IO_LED);
							
	parameter NORMALMODE = 2'b00;
	parameter SECONDMODE = 2'b01;
	parameter MINUTEMODE = 2'b10;
	parameter HOURMODE   = 2'b11;
	
	//Look up table for 7seg display
	parameter ZERO  = 8'b11000000;
	parameter ONE   = 8'b11111001;
	parameter TWO   = 8'b10100100;
	parameter THREE = 8'b10110000;
	parameter FOUR  = 8'b10011001;
	parameter FIVE  = 8'b10010010;
	parameter SIX   = 8'b10000010;
	parameter SEVEN = 8'b11111000;
	parameter EIGHT = 8'b10000000;
	parameter NINE  = 8'b10011000;

	always@(posedge M_CLOCK) begin
		case(mode)
		NORMALMODE:
			case(location)
			
			
			
			default:           //ERROR
			endcase
		default: IO_SSEG = 8'b00000000; //ERROR
		endcase
	end
endmodule
