import RV32_PKG::*;
module imem_rom (
    input logic [$clog2(NUM_WORDS) - 1:0] addr,
    output logic [INST_SIZE - 1:0] data
);
    always_comb begin
        case (addr)
            0: data = 32'h00000013;
            default: data = '0;
        endcase
    end
endmodule
