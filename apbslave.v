`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   23:02:51 09/06/2021
// Design Name:   apbmaster
// Module Name:   C:/Users/sidhant priyadarshi/OneDrive/Desktop/xilinx/apb4/apbslave.v
// Project Name:  apb4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: apbmaster
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module apbslave;

	// Inputs
	reg pclk;
	reg presetn;
	reg [7:0] prdata;
	reg pready;
	reg [1:0]add;

	// Outputs
	wire psel;
	wire penable;
	wire [7:0] paddr;
	wire pwrite;
	wire [7:0] pwdata;

	// Instantiate the Unit Under Test (UUT)
	apbmaster uut (
		.pclk(pclk), 
		.add(add),
		.presetn(presetn), 
		.psel(psel), 
		.penable(penable), 
		.paddr(paddr), 
		.pwrite(pwrite), 
		.pwdata(pwdata), 
		.prdata(prdata), 
		.pready(pready)
	);

	initial begin
		pclk = 0;
		#100;
	end
	
	always 
	begin
	#5 pclk = ~pclk;
	end
     
initial
begin
presetn = 1'b0;
add = 2'b00;
pready = 1'b0;
prdata = 8'h32;
repeat(10) @(posedge pclk)
pready = 1'b1;
presetn = 1'b1;
repeat(10) @(posedge pclk)
add = 2'b01;
repeat(20) @(posedge pclk)
add = 2'b11;
end

	  
endmodule

