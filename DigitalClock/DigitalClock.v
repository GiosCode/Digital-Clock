`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    04:10:10 10/30/2018 
// Design Name: 
// Module Name:    DigitalClock 
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
module DigitalClock(input clk,
							input [3:0] PB,
							input [7:0] DSW,
							output reg setupMode,
							output reg [3:0]hourUpper,
							output reg [3:0]hourLower,
							output reg [3:0]minuteUpper,
							output reg [3:0]minuteLower,
							output reg [5:0]secondCounter,
							output reg [1:0]loc);
	//Second and half second clock parameters
	parameter HALFSEC = 24999999;
	parameter SECOND  = 49999999;
	
	//Setup parameters
	parameter FIRSTDIGIT  = 3'b000;
	parameter SECONDDIGIT = 3'b001;
	parameter THIRDDIGIT  = 3'b010;
	parameter FOURTHDIGIT = 3'b011;
	parameter SETTIME     = 3'b100;
	reg [3:0] selectDigit = FIRSTDIGIT;
	
	//First Time setup variable
	reg timeSetup = 0;//Flag for first time setup, might change this into a reset input
	
	reg [3:0] hourUpperTMP;
	reg [3:0] hourLowerTMP;
	reg [3:0] minuteUpperTMP;
	reg [3:0] minuteLowerTMP;
	
	//Time keeping registers
	//reg [5:0]     secondCounter;
	integer secTicks = 0;	
	
	//Increase by 1 every second, this is the scaled clock.
	always @(posedge clk) begin
	
		if(secTicks == SECOND) begin
			secTicks <= 0;
			if(secondCounter == 60) begin
				secondCounter <= 1;
				if(minuteLower == 9) begin
					minuteLower <= 1;
					if(minuteUpper == 5) begin
						minuteUpper <= 1;
						if(hourLower == 4)begin
							hourLower <= 1;
							if(hourUpper == 2) begin
								hourUpper   <= 0;
								hourLower   <= 0;
								minuteLower <= 0;
								minuteUpper <= 0;
							end
							else hourUpper <= hourUpper +1;
						end
						else hourLower <= hourLower + 1;
					end
					else minuteUpper <= minuteUpper +1;
				end
				else minuteLower <= minuteLower + 1;
			end
			else secondCounter <= secondCounter + 1;
		end
		else secTicks <= secTicks + 1;
		
		//First time setup
		if(timeSetup == 0) begin//Clock is not origionally set up
		setupMode <= 1;//Signal to dislay driver
			//Case statement for setting up each digit
			case(selectDigit)
			///////////////////////////////////////////////////////////
				FIRSTDIGIT: begin //MAX value is 2
				loc <= 2'b00;
				if(DSW[3:0] > 2) begin hourUpperTMP <= 4'b0010; end
				else hourUpperTMP <= DSW[3:0];
				if(~PB[0]) selectDigit <= SECONDDIGIT;
				end
				////////////////////////////////////////////////////////
				SECONDDIGIT: begin//Max value is 4
				loc <= 2'b01;
				if(DSW[3:0] > 4) begin hourLowerTMP <= 4'b0100; end
				else hourLowerTMP <= DSW[3:0];
				if(~PB[1]) selectDigit <= THIRDDIGIT;
				end
				///////////////////////////////////////////////
				THIRDDIGIT: begin //MAX VALUE IS 5
				loc <= 2'b10;
				if(DSW[3:0] > 5) begin minuteUpperTMP <= 4'b0101; end
				else minuteUpperTMP <= DSW[3:0];
				if(~PB[2]) selectDigit <= FOURTHDIGIT;			
				end
				////////////////////////////////////////////////////
				FOURTHDIGIT: begin// MAX VALUE IS 9
				loc <= 2'b11;
				if(DSW[3:0] > 9) begin minuteLowerTMP <= 4'b1001; end
				else minuteLowerTMP <= DSW[3:0];
				if(~PB[3]) selectDigit <= SETTIME;
				end
				//////////////////////////////////////////////////
				SETTIME    : begin
				hourUpper   <= hourUpperTMP;
				hourLower   <= hourLowerTMP;
				minuteUpper <= minuteUpperTMP;
				minuteLower <= minuteLowerTMP;
				secondCounter <=0; //Reset all time keeping registers
				timeSetup <= 1;//Set up complete
				end
			////////////////////////////////////////////////////
			endcase
		end
		
	end

endmodule
