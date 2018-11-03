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
	reg timeSetup = 0;
	reg [3:0] tempBuffer1;
	reg [3:0] tempBuffer2;
	reg [3:0] tempBuffer3;
	reg [3:0] tempBuffer4;
	//Time keeping registers
	reg [5:0]     secondCounter = 0;
	reg [5:0]     minuteCounter = 0;
	reg [5:0]     hourCounter   = 0;
	integer secTicks                   = 0;	
	
	//Increase by 1 every second, this is the scaled clock, breka it down into a nest upon nest of if statements where you check each ones,tends,hundrethds, thousndsa and increament each one seperately.
	always @(posedge M_CLOCK) begin
	if(secTicks == 49999999) begin
		if(secondCounter < 60) secondCounter = secondCounter + 1;//Tracking seconds
		else secondCounter = 0;
		
		if(minuteCounter < 60) minuteCounter = minuteCounter + 1;
		else minuteCounter = 0;
		
		if(hourCounter < 24) hourCounter = hourCounter + 1;
		else hourCounter = 0;
	end
	else secTicks = secTicks + 1;
	end
	
	//Clock Setup, do once on power or when two buttons are pressed
	always @(posedge M_CLOCK) begin
		if(timeSetup == 0) begin//Clock is not origionally set up
			//Case statement for setting up each digit
			case(selectDigit)
			FIRSTDIGIT: begin //MAX value is 2
			if(IO_DSW[3:0] > 2) begin
			tempBuffer1 <= 4'b0010;
			end
			else tempBuffer1 <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[0] <= ~IO_SSEGD[0];
				case(tempBuffer1)
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
			//Turn
				if(IO_PB[0]) selectDigit <= SECONDDIGIT;
			//Blink leftmost digit with dipsw value
			//Put 0 on all other digits
			//if button is pressed stop blinking and set that number to display and save it to temp buffer 1
			end
			SECONDDIGIT: begin//Max value is 4
			if(IO_DSW[3:0] > 4) begin
			tempBuffer2 <= 4'b0100;
			end
			else tempBuffer2 <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[1] <= ~IO_SSEGD[1];
				case(tempBuffer2)
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
			//Blink 2nd digit with dipsw value
			//put 3rd and 4th to 0
			//if button is pressed stop blinking and set that number to display and save it to temp buffer 2
			end
			THIRDDIGIT: begin //MAX VALUE IS 5
			if(IO_DSW[3:0] > 5) begin
			tempBuffer3 <= 4'b0101;
			end
			else tempBuffer3 <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[2] <= ~IO_SSEGD[2];
				case(tempBuffer3)
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
			//Blink 3rd digit with dipsw value
			//put 4th to 0
			//if button is pressed stop blinking and set that number to display and save it to temp buffer 3
			
			end
			FOURTHDIGIT: begin// MAX VALUE IS 9
			if(IO_DSW[3:0] > 9) begin
			tempBuffer4 <= 4'b1001;
			end
			else tempBuffer3 <= IO_DSW[3:0];
			if(secTicks == HALFSEC) IO_SSEGD[3] <= ~IO_SSEGD[3];
				case(tempBuffer4)
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
			//blink 4th digit with dipsw value
			//if button is pressed stop blinking and set that number to display and save it to temp buffer 4
			end
			SETTIME    : begin
			hourCounter <= {tempBuffer1,tempBuffer2};
			minuteCounter <= {tempBuffer3, tempBuffer4};
			secondCounter <= 0;
			timeSetup <= 1;//Set up complete
			
			//concatonate buffer 1 & 2 into hourCounter
			//Concatonate buffer 3 & 4 into minuteCounter
			//Set secondCounter to 1
			end			
			endcase
		end
		if(timeSetup == 1 && (IO_PB[0] && IO_PB[3])) begin//User wants to overwrite clock/timer/etc
		timeSetup <= 0;
		end	
	end
	
	//Data Output: Always display time if clock setup , 5 state machines (Normal, Seconds, Minutes, Hours)
	//always @(posedge M_CLOCK) begin
		//if(timeSetup == 1) begin//Clock has been set
			//case (displayMode)
			//NORMALMODE: //Display time in HH:MM.
			//SECONDMODE: //Display ~~~SS
			//MINUTEMODE: //Display ~~~MM
			//HOURMODE  : //Display ~~~HH
			//endcase
		//end
		//end
	
	//end

endmodule
