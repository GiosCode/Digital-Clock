`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:15:30 11/05/2018 
// Design Name: 
// Module Name:    ModeSelect 
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
module ModeSelect(input setUp,
						input [3:0]buttons,
						output reg [1:0]mode);

//reg [3:0]mode;

//Parameters for modes
parameter SETUP   = 2'b00;
parameter TIME24  = 2'b01;
parameter SECONDS = 2'b10;
parameter TIME12  = 2'b11;

always @* begin
	if(setUp == 1) begin
		//mode <= SETUP; //Setup mode
	mode <= SETUP;
	end
	else begin
	case(buttons)
	4'b1110:  mode <= TIME24; //24 hour mode
	//4'b1101: prevMode<= SECONDS; //
	//4'b1011: prevMode<= TIME12; //
	endcase
	end
end
endmodule
