`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:43:27 09/06/2021 
// Design Name: 
// Module Name:    apbmaster 
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
module apbmaster(
input 		pclk,
input 		presetn,
input 		[1:0]add,//00-x,01-read,10-x,11-write
output reg	psel,
output reg	penable,
output 		[7:0] paddr,
output 		pwrite,
output 		[7:0]pwdata,
input  		[7:0]prdata,
input 		pready
    );


reg [7:0]cur_pwrite,nex_pwrite,cur_prdata,nex_prdata;
reg [1:0] cur_s,nex_s;
parameter idle = 2'b00,setup = 2'b01,access = 2'b10;
 
always @(posedge pclk)
begin
	if(~presetn)
	begin
		cur_s <= idle;
		cur_pwrite <= 7'b0;
		cur_prdata <= 7'b0;
		end
	else
	begin
		cur_s <= nex_s;
		cur_pwrite <= nex_pwrite;
		cur_prdata <= nex_prdata;
	end
end 

always @(cur_s or add)
begin
	case(cur_s)
	idle:begin
			if(add[0])
			begin
			nex_s = setup;
			nex_pwrite = add[1];
			end
			else
			nex_s = idle;
			end
	setup:begin
				psel = 1;
				penable = 0;
				nex_s = access;
			end
	access:begin
				psel = 1;
				penable = 1;
				if(pready)
				begin
				if(~cur_pwrite)
				begin
				nex_prdata = prdata;
				nex_s = idle;
				end
				end
				else
				nex_s = access;
			end
	default:begin
	psel = 0;
	penable = 0;
	nex_s = idle;
	nex_prdata = cur_prdata;
	nex_pwrite = cur_pwrite;
	end
	endcase
end

assign paddr = (cur_s == access)?8'h32:8'h0000;
assign pwrite = cur_pwrite;
assign pwdata = (cur_s == access)?cur_prdata:7'b0;


endmodule
