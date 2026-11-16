`timescale 1ns / 1ps

import RV32_PKG::*;

module imem_rom (
    input  logic [$clog2(NUM_WORDS) - 1:0] addr,
    output logic [INST_SIZE - 1:0]         data
);

    logic [INST_SIZE - 1:0] iram [0:NUM_WORDS - 1];

    initial begin
        $readmemh("imem.mem", iram);
    end

    assign data = iram[addr];

endmodule
