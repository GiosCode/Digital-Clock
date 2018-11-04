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
module DigitalClock(input M_CLOCK,
							input [3:0] IO_PB,
							input [7:0] IO_DSW,
							output reg [7:0] IO_SSEG,
							output reg [3:0] IO_SSEGD,
							output reg IO_SSEG_COL,
							output reg [7:0] IO_LED);
	//Second and half second clock parameters
	parameter HALFSEC = 24999999;
	parameter SECOND  = 49999999;
	
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
	
	//7 SEG Display Display Mode State machine variables & parameters:
	parameter NORMALMODE = 2'b00;
	parameter SECONDMODE = 2'b01;
	parameter MINUTEMODE = 2'b10;
	parameter HOURMODE   = 2'b11;
	reg [2:0] displayMode = NORMALMODE; 
	
	//Setup parameters
	parameter FIRSTDIGIT  = 3'b000;
	parameter SECONDDIGIT = 3'b001;
	parameter THIRDDIGIT  = 3'b010;
	parameter FOURTHDIGIT = 3'b011;
	parameter SETTIME     = 3'b100;
	reg [3:0] selectDigit = FIRSTDIGIT;
	
	//First Time setup variable
	reg timeSetup = 0;//Flag for first time setup
	reg [3:0] hourUpper;
	reg [3:0] hourLower;
	reg [3:0] minuteUpper;
	reg [3:0] minuteLower;
	
	reg [3:0] hourUpperTMP;
	reg [3:0] hourLowerTMP;
	reg [3:0] minuteUpperTMP;
	reg [3:0] minuteLowerTMP;
	
	//Time keeping registers
	reg [5:0]     secondCounter;
	//reg [5:0]     minuteCounter = 0;
	//reg [5:0]     hourCounter   = 0;
	integer secTicks = 0;	
	
	//Display registers
	reg [1:0] displayDigit = FIRSTDIGIT; 
	
	//Increase by 1 every second, this is the scaled clock.
	always @(posedge M_CLOCK) begin
		if(secTicks == SECOND) begin
		secTicks <= 0;
			if(secondCounter > 60) begin
				secondCounter <= 1;
				if(minuteLower > 9) begin
				minuteLower <= 0;
				if(minuteUpper > 5) begin
					minuteUpper <= 0;
					if(hourLower > 4)begin
						hourLower <= 0;
						if(hourUpper > 2) begin
						hourUpper   <= 0;
						hourLower   <= 0;
						minuteLower <= 0;
						minuteUpper <= 0;
						end
							else hourUpper <= hourUpper +1;
					end
						else hourLower <=hourLower + 1;
				end
					else minuteUpper <= minuteUpper +1;
			end
				else minuteLower <= minuteLower + 1;
		end
			else secondCounter <= secondCounter + 1;
		end
			else secTicks <= secTicks + 1;
	end
	
	//Clock Setup, do once on power or                             IMPLEMENT: when two buttons are pressed
	always @(posedge M_CLOCK) begin
		if(timeSetup == 0) begin//Clock is not origionally set up
			//Case statement for setting up each digit
			case(selectDigit)
			///////////////////////////////////////////////////////////
			FIRSTDIGIT: begin //MAX value is 2
			IO_SSEGD <= 4'b1110;                                  //MIGHT HAVE TO CHANGE THIS FOR THE OTHER ONES TOO
			if(IO_DSW[3:0] > 2) begin
			hourUpperTMP <= 4'b0010;
			end
			else hourUpperTMP <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[0] <= ~IO_SSEGD[0];
				case(hourUpper)
					0:IO_SSEG = ZERO;
					1:IO_SSEG = ONE;
					2:IO_SSEG = TWO;
					3:IO_SSEG = THREE;
					4:IO_SSEG = FOUR;
					5:IO_SSEG = FIVE;
					6:IO_SSEG = SIX;
					7:IO_SSEG = SEVEN;
					8:IO_SSEG = EIGHT;
					9:IO_SSEG = NINE;
				endcase
			if(IO_PB[0]) selectDigit <= SECONDDIGIT;
			end
			////////////////////////////////////////////////////////
			SECONDDIGIT: begin//Max value is 4
			IO_SSEGD <= 4'b1101;
			if(IO_DSW[3:0] > 4) begin
			hourLowerTMP <= 4'b0100;
			end
			else hourLowerTMP <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[1] <= ~IO_SSEGD[1];
				case(hourLower)
					0:IO_SSEG = ZERO;
					1:IO_SSEG = ONE;
					2:IO_SSEG = TWO;
					3:IO_SSEG = THREE;
					4:IO_SSEG = FOUR;
					5:IO_SSEG = FIVE;
					6:IO_SSEG = SIX;
					7:IO_SSEG = SEVEN;
					8:IO_SSEG = EIGHT;
					9:IO_SSEG = NINE;
				endcase
			if(IO_PB[1]) selectDigit <= THIRDDIGIT;
			end
			///////////////////////////////////////////////
			THIRDDIGIT: begin //MAX VALUE IS 5
			IO_SSEGD <= 4'b1011;
			if(IO_DSW[3:0] > 5) begin
			minuteUpperTMP <= 4'b0101;
			end
			else minuteUpperTMP <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[2] <= ~IO_SSEGD[2];
				case(minuteUpper)
					0:IO_SSEG = ZERO;
					1:IO_SSEG = ONE;
					2:IO_SSEG = TWO;
					3:IO_SSEG = THREE;
					4:IO_SSEG = FOUR;
					5:IO_SSEG = FIVE;
					6:IO_SSEG = SIX;
					7:IO_SSEG = SEVEN;
					8:IO_SSEG = EIGHT;
					9:IO_SSEG = NINE;
				endcase
				if(IO_PB[2]) selectDigit <= FOURTHDIGIT;			
			end
			////////////////////////////////////////////////////
			FOURTHDIGIT: begin// MAX VALUE IS 9
			IO_SSEGD <= 4'b0111;
			if(IO_DSW[3:0] > 9) begin
			minuteLowerTMP <= 4'b1001;
			end
			else minuteUpperTMP <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[3] <= ~IO_SSEGD[3];
				case(minuteLower)
					0:IO_SSEG = ZERO;
					1:IO_SSEG = ONE;
					2:IO_SSEG = TWO;
					3:IO_SSEG = THREE;
					4:IO_SSEG = FOUR;
					5:IO_SSEG = FIVE;
					6:IO_SSEG = SIX;
					7:IO_SSEG = SEVEN;
					8:IO_SSEG = EIGHT;
					9:IO_SSEG = NINE;
				endcase
				if(IO_PB[3]) selectDigit <= SETTIME;
			end
			//////////////////////////////////////////////////
			SETTIME    : begin
			hourUpper   <= hourUpperTMP;
			hourLower   <= hourLowerTMP;
			minuteUpper <= minuteUpperTMP;
			minuteLower <= minuteLowerTMP;
			//Reset all time keeping registers
			secondCounter <=0;
			//minuteCounter <=0;
			//hourCounter <=0;
			timeSetup <= 1;//Set up complete
			end			
			endcase
		end
		if(timeSetup == 1 && (IO_PB[0] && IO_PB[3])) begin//User wants to overwrite clock/timer/etc
		timeSetup <= 0;
		end	
	end
	
	//Data Output: Always display time if clock setup , 5 state machines (Normal, Seconds, Minutes, Hours)
	always @(posedge M_CLOCK) begin
		if(timeSetup == 1) begin//Clock has been set
			case (displayMode)
			NORMALMODE: begin //Display time in HH:MM.
				case(displayDigit)
				FIRSTDIGIT:begin
					IO_SSEGD <= 4'b1110;
					case(hourUpper)
					0: IO_SSEG <= ZERO;
					1: IO_SSEG <= ONE;
					2: IO_SSEG <= TWO;
					default: IO_SSEG <= 8'b00000000;//ERROR
					endcase
					displayDigit <= SECONDDIGIT;
				end
				SECONDDIGIT:begin
					IO_SSEGD <= 4'b1101;
					case(hourLower)
					0: IO_SSEG <= ZERO;
					1: IO_SSEG <= ONE;
					2: IO_SSEG <= TWO;
					3: IO_SSEG <= THREE;
					4: IO_SSEG <= FOUR;
					default: IO_SSEG <= 8'b00000000;//ERROR
					endcase
					displayDigit <= THIRDDIGIT;
				end
				THIRDDIGIT:begin
					IO_SSEGD <= 4'b1011;
					case(minuteUpper)
					0: IO_SSEG <= ZERO;
					1: IO_SSEG <= ONE;
					2: IO_SSEG <= TWO;
					3: IO_SSEG <= THREE;
					4: IO_SSEG <= FOUR;
					5: IO_SSEG <= FIVE;
					default: IO_SSEG <= 8'b00000000;//ERROR
					endcase
					displayDigit <= FOURTHDIGIT;
				end
				FOURTHDIGIT:begin
					IO_SSEGD <= 4'b0111;
					case(minuteLower)
					0: IO_SSEG <= ZERO;
					1: IO_SSEG <= ONE;
					2: IO_SSEG <= TWO;
					3: IO_SSEG <= THREE;
					4: IO_SSEG <= FOUR;
					5: IO_SSEG <= FIVE;
					6: IO_SSEG <= SIX;
					7: IO_SSEG <= SEVEN;
					8: IO_SSEG <= EIGHT;
					9: IO_SSEG <= NINE;
					default: IO_SSEG <= 8'b00000000;//ERROR
					endcase
					displayDigit <= FIRSTDIGIT;
				end
				endcase
			end
			//SECONDMODE: //Display ~~~SS
			//MINUTEMODE: //Display ~~~MM
			//HOURMODE  : //Display ~~~HH
			endcase
		end
	end

endmodule
