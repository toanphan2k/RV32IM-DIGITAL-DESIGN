`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/27/2026 03:06:40 PM
// Design Name: 
// Module Name: divu_1iter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module divu_1iter (
    input logic [31:0] i_dividend,
    input logic [31:0] i_divisor,
    input logic [31:0] i_remainder,
    output logic [31:0] o_dividend,
    output logic [31:0] o_remainder
);

    logic [31:0] partial_rem;
    logic [32:0] difference_with_borrow;

    assign partial_rem = {i_remainder[30:0], i_dividend[31]};
    assign difference_with_borrow = {1'b0, partial_rem} - {1'b0, i_divisor};

    always @(*) begin
        o_dividend = {i_dividend[30:0], !difference_with_borrow[32]};
        
        if (!difference_with_borrow[32]) begin
            o_remainder = difference_with_borrow[31:0];
        end else begin
            o_remainder = partial_rem;
        end
    end

endmodule