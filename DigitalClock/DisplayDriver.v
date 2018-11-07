`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:12:58 11/04/2018 
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
module DisplayDriver(input clk,
							input [1:0]mode,
							input [3:0]secondsLower,
							input [3:0]secondsUpper,
							input [3:0]minutesLower,
							input [3:0]minutesUpper,
							input [3:0]hoursLower,
							input [3:0]hoursUpper,
							input [1:0] location,
							output reg [7:0] SSEG,
							output reg [3:0] SSEGD,
							output reg SSEG_COL);
	//Parameters for selecting display mode of operation.
	parameter SETUP   = 2'b00;
	parameter TIME24  = 2'b01;
	parameter SECONDS = 2'b10;
	parameter TIME12  = 2'b11;
	//Parameters for digit being displayed since only one can be displayed
	parameter FIRSTDIGIT = 2'b00;
	parameter SECONDDIGIT = 2'b01;
	parameter THIRDDIGIT = 2'b10;
	parameter FOURTHDIGIT = 2'b11;
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
	
	//traveling through digits
	reg [1:0] currentDigit = FIRSTDIGIT;
	
	always@(posedge clk) begin
		case(mode)
		//Setup mode: blink digit being set.
		SETUP: begin
		SSEG_COL <= 0;
			case(currentDigit)
			FIRSTDIGIT: begin
				if(location == FIRSTDIGIT) begin
					if(clk== 24999999) begin SSEGD[0] <= ~SSEGD[0]; end
				end
				else begin
				SSEGD <= 4'b1110;
				end
					case(hoursUpper)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					endcase
				currentDigit <= SECONDDIGIT;
			end
			///////////////
			SECONDDIGIT: begin
				if(location == SECONDDIGIT) begin
					if(clk== 24999999) begin SSEGD[1] <= ~SSEGD[1]; end
				end
				else begin
				SSEGD <= 4'b1101;
				end
					case(hoursLower)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					3: SSEG <= THREE;
					4: SSEG <= FOUR;
					endcase
				currentDigit <= THIRDDIGIT; 
			end
			///////////////
			THIRDDIGIT: begin
				if(location == THIRDDIGIT) begin
					if(clk== 24999999) begin SSEGD[2] <= ~SSEGD[2]; end
				end
				else begin
				SSEGD <= 4'b1011;
				end
				case(minutesUpper)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					3: SSEG <= THREE;
					4: SSEG <= FOUR;
					5: SSEG <= FIVE;
				endcase
				currentDigit <= FOURTHDIGIT;
			end
			///////////////
			FOURTHDIGIT: begin
				if(location == FOURTHDIGIT) begin
					if(clk== 24999999) begin SSEGD[3] <= ~SSEGD[3]; end
				end
				else begin
				SSEGD <= 4'b0111;
				end
				case(minutesLower)
					0:SSEG <= ZERO;
					1:SSEG <= ONE;
					2:SSEG <= TWO;
					3:SSEG <= THREE;
					4:SSEG <= FOUR;
					5:SSEG <= FIVE;
					6:SSEG <= SIX;
					7:SSEG <= SEVEN;
					8:SSEG <= EIGHT;
					9:SSEG <= NINE;
				endcase
				currentDigit <= FIRSTDIGIT;
			end
			///////////////
			default: SSEG <= 8'b00000000;//ERROR for Setup display
			endcase
		end
		///////////////////////////////////////////////////////
		TIME24: begin
		SSEG_COL <= 0;
			case (currentDigit)
			FIRSTDIGIT: begin
			SSEGD <= 4'b1110;
				case(hoursUpper)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					endcase
			currentDigit <= SECONDDIGIT;
			end
			SECONDDIGIT: begin
			SSEGD <= 4'b1101;
				case(hoursLower)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					3: SSEG <= THREE;
					4: SSEG <= FOUR;
					endcase
			currentDigit <= THIRDDIGIT;
			end
			THIRDDIGIT: begin
			SSEGD <= 4'b1011;
				case(minutesUpper)
					0: SSEG <= ZERO;
					1: SSEG <= ONE;
					2: SSEG <= TWO;
					3: SSEG <= THREE;
					4: SSEG <= FOUR;
					5: SSEG <= FIVE;
				endcase
				currentDigit <= FOURTHDIGIT;
			end
			FOURTHDIGIT: begin
			SSEGD <= 4'b0111;
			//Blink minutes decimal point once a second
				if(clk == 24999999) begin
					case(minutesLower)
						0:SSEG <= ZERO;
						1:SSEG <= ONE;
						2:SSEG <= TWO;
						3:SSEG <= THREE;
						4:SSEG <= FOUR;
						5:SSEG <= FIVE;
						6:SSEG <= SIX;
						7:SSEG <= SEVEN;
						8:SSEG <= EIGHT;
						9:SSEG <= NINE;
					endcase
				end
				else begin
					case(minutesLower)
						0:SSEG <= ZERO;
						1:SSEG <= ONE;
						2:SSEG <= TWO;
						3:SSEG <= THREE;
						4:SSEG <= FOUR;
						5:SSEG <= FIVE;
						6:SSEG <= SIX;
						7:SSEG <= SEVEN;
						8:SSEG <= EIGHT;
						9:SSEG <= NINE;
					endcase
				end
			currentDigit <= FIRSTDIGIT;
			end
			default: SSEG <= 8'b00000000;//ERROR for 24 hour display
			endcase
		end
		/////////////////////////////////////////////////////// Display Seconds on rightmost 7 Segment Display
		//SECONDS: begin
		
		//end
		///////////////////////////////////////////////////////
		//TIME12: begin
		
		//end
		default: SSEG <= 8'b00000000;//ERROR for mode selecct
		endcase
	end
endmodule
