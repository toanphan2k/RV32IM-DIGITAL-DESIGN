`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/30/2026 01:14:37 PM
// Design Name: 
// Module Name: imem
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

import RV32_PKG::*;

module imem (
    input  logic [REG_SIZE - 1:0]  c_pc_f,
    output logic [INST_SIZE - 1:0] f_inst
);

    localparam int ADDR_WIDTH = $clog2(NUM_WORDS);
    logic [ADDR_WIDTH - 1:0] word_addr;

    assign word_addr = c_pc_f[ADDR_WIDTH + 1:2];

    imem_rom u_imem_rom (
        .addr(word_addr),
        .data(f_inst)
    );

endmodule
