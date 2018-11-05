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


always @* begin
	if(setUp == 1) begin
		mode <= 2'b00; //Setup mode
	end
	else begin
	case(buttons)
	4'b1110: mode<= 2'b01; //24 hour mode
	4'b1101: mode<= 2'b10; //12 hour mode
	4'b1011: mode<= 2'b11; //seconds mode
	endcase
	end
end
endmodule
