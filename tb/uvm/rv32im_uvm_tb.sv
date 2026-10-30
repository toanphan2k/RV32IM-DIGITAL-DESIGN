`timescale 1ns/1ps

// Pin-level view used by the UVM environment. Besides the trace port, tb_top
// ties the WB register-write port and the MEM data-memory write port in here.
interface rv32im_if(input logic clk);
    logic        rst_n;
    logic [31:0] trace_pc;
    logic [31:0] trace_inst;
    logic        wb_we;
    logic [4:0]  wb_rd;
    logic [31:0] wb_data;
    logic [3:0]  st_we;
    logic [31:0] st_addr;
    logic [31:0] st_data;

    // Sample the values that are committed on each rising edge.
    clocking monitor_cb @(posedge clk);
        default input #1step;
        input rst_n, trace_pc, trace_inst, wb_we, wb_rd, wb_data, st_we, st_addr, st_data;
    endclocking
endinterface

package rv32im_uvm_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    // =================================================================
    // Constants / types
    // =================================================================
    localparam int unsigned MEM_WORDS      = 512;
    localparam bit [31:0]   NOP            = 32'h0000_0013;
    localparam int          NO_SIGNATURE   = -1;
    localparam string       DMEM_ZERO_FILE = "uvm_dmem_zero.mem";

    localparam bit [6:0] OPC_LUI    = 7'b0110111;
    localparam bit [6:0] OPC_AUIPC  = 7'b0010111;
    localparam bit [6:0] OPC_JAL    = 7'b1101111;
    localparam bit [6:0] OPC_JALR   = 7'b1100111;
    localparam bit [6:0] OPC_BRANCH = 7'b1100011;
    localparam bit [6:0] OPC_LOAD   = 7'b0000011;
    localparam bit [6:0] OPC_STORE  = 7'b0100011;
    localparam bit [6:0] OPC_OPIMM  = 7'b0010011;
    localparam bit [6:0] OPC_OP     = 7'b0110011;

    // Random program register usage
    localparam int unsigned RAND_POOL     = 7;     // x1..x7 are data registers
    localparam bit [4:0]    RAND_BASE_REG = 5'd8;  // fixed memory base
    localparam bit [4:0]    RAND_TMP_REG  = 5'd9;  // AUIPC/JALR scratch
    localparam int          RAND_MEM_BASE = 512;   // byte 0x200 -> accesses 0x100..0x2FF

    typedef bit [31:0] rv_image_t[];

    typedef enum {
        I_LUI, I_AUIPC, I_JAL, I_JALR,
        I_BEQ, I_BNE, I_BLT, I_BGE, I_BLTU, I_BGEU,
        I_LB, I_LH, I_LW, I_LBU, I_LHU, I_SB, I_SH, I_SW,
        I_ADDI, I_SLTI, I_SLTIU, I_XORI, I_ORI, I_ANDI, I_SLLI, I_SRLI, I_SRAI,
        I_ADD, I_SUB, I_SLL, I_SLT, I_SLTU, I_XOR, I_SRL, I_SRA, I_OR, I_AND,
        I_MUL, I_MULH, I_MULHSU, I_MULHU, I_DIV, I_DIVU, I_REM, I_REMU,
        I_FENCE, I_SYSTEM, I_ILLEGAL
    } rv_mnemonic_e;

    typedef enum { P_NONE, P_ALU, P_LOAD, P_MUL, P_DIV, P_JUMP } rv_producer_e;

    typedef enum { RUN_PENDING, RUN_DONE, RUN_PASS, RUN_FAIL, RUN_TIMEOUT } rv_run_status_e;

    // Architectural effect of one instruction, produced by the ISS
    typedef struct {
        bit [31:0]    pc;
        bit [31:0]    inst;
        rv_mnemonic_e op;
        bit [4:0]     rd, rs1, rs2;
        bit           uses_rs1, uses_rs2;
        bit [31:0]    op_a, op_b;
        bit           rd_write;
        bit [31:0]    rd_value;
        bit           is_div;
        bit           is_branch;
        bit           taken;
        bit           is_store;
        bit [31:0]    mem_addr;
        bit [3:0]     st_we;
        bit [31:0]    st_data;
        bit [31:0]    next_pc;
    } rv_step_t;

    // =================================================================
    // Instruction encoders
    // =================================================================
    function automatic bit [31:0] enc_i(bit [6:0] opcode, int immediate,
                                        bit [4:0] rs1, bit [2:0] funct3, bit [4:0] rd);
        return {immediate[11:0], rs1, funct3, rd, opcode};
    endfunction

    function automatic bit [31:0] enc_r(bit [6:0] funct7, bit [4:0] rs2, bit [4:0] rs1,
                                        bit [2:0] funct3, bit [4:0] rd,
                                        bit [6:0] opcode = OPC_OP);
        return {funct7, rs2, rs1, funct3, rd, opcode};
    endfunction

    function automatic bit [31:0] enc_s(int immediate, bit [4:0] rs2, bit [4:0] rs1, bit [2:0] funct3);
        bit [11:0] imm = immediate[11:0];
        return {imm[11:5], rs2, rs1, funct3, imm[4:0], OPC_STORE};
    endfunction

    function automatic bit [31:0] enc_b(int immediate, bit [4:0] rs2, bit [4:0] rs1, bit [2:0] funct3);
        bit [12:0] imm = immediate[12:0];
        return {imm[12], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], OPC_BRANCH};
    endfunction

    function automatic bit [31:0] enc_j(int immediate, bit [4:0] rd);
        bit [20:0] imm = immediate[20:0];
        return {imm[20], imm[10:1], imm[11], imm[19:12], rd, OPC_JAL};
    endfunction

    function automatic bit [31:0] enc_u(bit [6:0] opcode, bit [19:0] imm20, bit [4:0] rd);
        return {imm20, rd, opcode};
    endfunction

    // =================================================================
    // Backdoor access. Implemented in tb_top with hierarchical references,
    // so no simulator-specific HDL/PLI access (+acc) is needed.
    // =================================================================
    virtual class rv32im_backdoor;
        pure virtual function void load_imem(rv_image_t image);
        pure virtual function void clear_dmem();
        pure virtual function logic [31:0] read_dmem(int unsigned word_index);
        pure virtual function logic [31:0] read_reg(int unsigned index);
    endclass

    // =================================================================
    // RV32IM instruction-set simulator (golden reference model)
    // Data memory decodes addr[10:2] exactly like rtl/dmem.sv, so MMIO
    // writes such as 0x80000000 alias onto word 0 in both models.
    // =================================================================
    class rv32im_iss;
        bit [31:0] regs[32];
        bit [31:0] pc;
        bit [31:0] imem[MEM_WORDS];
        bit [31:0] dmem[MEM_WORDS];

        function void reset(rv_image_t image);
            pc = '0;
            foreach (regs[i]) regs[i] = '0;
            foreach (imem[i]) imem[i] = (i < image.size()) ? image[i] : NOP;
            foreach (dmem[i]) dmem[i] = '0;
        endfunction

        static function int unsigned word_index(bit [31:0] addr);
            return (addr >> 2) % MEM_WORDS;
        endfunction

        function bit [31:0] fetch(bit [31:0] addr);
            return imem[word_index(addr)];
        endfunction

        static function bit is_div_op(rv_mnemonic_e op);
            return op inside {I_DIV, I_DIVU, I_REM, I_REMU};
        endfunction

        static function string mnemonic_name(rv_mnemonic_e op);
            string name;
            name = op.name();
            return (name.len() > 2) ? name.substr(2, name.len() - 1) : name;
        endfunction

        static function rv_mnemonic_e decode(bit [31:0] inst);
            bit [2:0] f3 = inst[14:12];
            bit [6:0] f7 = inst[31:25];
            case (inst[6:0])
                OPC_LUI:   return I_LUI;
                OPC_AUIPC: return I_AUIPC;
                OPC_JAL:   return I_JAL;
                OPC_JALR:  return (f3 == 3'b000) ? I_JALR : I_ILLEGAL;
                OPC_BRANCH:
                    case (f3)
                        3'b000: return I_BEQ;
                        3'b001: return I_BNE;
                        3'b100: return I_BLT;
                        3'b101: return I_BGE;
                        3'b110: return I_BLTU;
                        3'b111: return I_BGEU;
                        default: return I_ILLEGAL;
                    endcase
                OPC_LOAD:
                    case (f3)
                        3'b000: return I_LB;
                        3'b001: return I_LH;
                        3'b010: return I_LW;
                        3'b100: return I_LBU;
                        3'b101: return I_LHU;
                        default: return I_ILLEGAL;
                    endcase
                OPC_STORE:
                    case (f3)
                        3'b000: return I_SB;
                        3'b001: return I_SH;
                        3'b010: return I_SW;
                        default: return I_ILLEGAL;
                    endcase
                OPC_OPIMM:
                    case (f3)
                        3'b000: return I_ADDI;
                        3'b010: return I_SLTI;
                        3'b011: return I_SLTIU;
                        3'b100: return I_XORI;
                        3'b110: return I_ORI;
                        3'b111: return I_ANDI;
                        3'b001: return (f7 == 7'b0000000) ? I_SLLI : I_ILLEGAL;
                        default: return (f7 == 7'b0000000) ? I_SRLI :
                                        (f7 == 7'b0100000) ? I_SRAI : I_ILLEGAL;
                    endcase
                OPC_OP:
                    if (f7 == 7'b0000001)
                        case (f3)
                            3'b000: return I_MUL;
                            3'b001: return I_MULH;
                            3'b010: return I_MULHSU;
                            3'b011: return I_MULHU;
                            3'b100: return I_DIV;
                            3'b101: return I_DIVU;
                            3'b110: return I_REM;
                            default: return I_REMU;
                        endcase
                    else if (f7 == 7'b0000000)
                        case (f3)
                            3'b000: return I_ADD;
                            3'b001: return I_SLL;
                            3'b010: return I_SLT;
                            3'b011: return I_SLTU;
                            3'b100: return I_XOR;
                            3'b101: return I_SRL;
                            3'b110: return I_OR;
                            default: return I_AND;
                        endcase
                    else if (f7 == 7'b0100000 && f3 == 3'b000) return I_SUB;
                    else if (f7 == 7'b0100000 && f3 == 3'b101) return I_SRA;
                    else return I_ILLEGAL;
                7'b0001111: return I_FENCE;
                7'b1110011: return I_SYSTEM;
                default:    return I_ILLEGAL;
            endcase
        endfunction

        // Integer + M-extension datapath, RISC-V spec semantics (incl. /0 and overflow)
        static function bit [31:0] alu(rv_mnemonic_e op, bit [31:0] a, bit [31:0] b);
            bit [63:0] p;
            case (op)
                I_ADD, I_ADDI:   return a + b;
                I_SUB:           return a - b;
                I_SLL, I_SLLI:   return a << b[4:0];
                I_SLT, I_SLTI:   return ($signed(a) < $signed(b)) ? 32'd1 : 32'd0;
                I_SLTU, I_SLTIU: return (a < b) ? 32'd1 : 32'd0;
                I_XOR, I_XORI:   return a ^ b;
                I_SRL, I_SRLI:   return a >> b[4:0];
                I_SRA, I_SRAI:   return $signed(a) >>> b[4:0];
                I_OR, I_ORI:     return a | b;
                I_AND, I_ANDI:   return a & b;
                I_MUL: begin
                    p = $signed({{32{a[31]}}, a}) * $signed({{32{b[31]}}, b});
                    return p[31:0];
                end
                I_MULH: begin
                    p = $signed({{32{a[31]}}, a}) * $signed({{32{b[31]}}, b});
                    return p[63:32];
                end
                I_MULHSU: begin
                    p = $signed({{32{a[31]}}, a}) * $signed({32'b0, b});
                    return p[63:32];
                end
                I_MULHU: begin
                    p = {32'b0, a} * {32'b0, b};
                    return p[63:32];
                end
                I_DIV: begin
                    if (b == '0) return '1;
                    if (a == 32'h8000_0000 && b == '1) return a;
                    return $signed(a) / $signed(b);
                end
                I_DIVU: return (b == '0) ? '1 : a / b;
                I_REM: begin
                    if (b == '0) return a;
                    if (a == 32'h8000_0000 && b == '1) return '0;
                    return $signed(a) % $signed(b);
                end
                I_REMU: return (b == '0) ? a : a % b;
                default: return '0;
            endcase
        endfunction

        function rv_step_t step();
            rv_step_t  s;
            bit [31:0] a, b, imm_i, imm_s, imm_b, imm_u, imm_j, res, word, shifted;
            int unsigned idx;

            s.pc   = pc;
            s.inst = fetch(pc);
            s.op   = decode(s.inst);
            s.rd   = s.inst[11:7];
            s.rs1  = s.inst[19:15];
            s.rs2  = s.inst[24:20];
            a      = regs[s.rs1];
            b      = regs[s.rs2];
            s.op_a = a;
            s.op_b = b;

            imm_i = {{20{s.inst[31]}}, s.inst[31:20]};
            imm_s = {{20{s.inst[31]}}, s.inst[31:25], s.inst[11:7]};
            imm_b = {{19{s.inst[31]}}, s.inst[31], s.inst[7], s.inst[30:25], s.inst[11:8], 1'b0};
            imm_u = {s.inst[31:12], 12'b0};
            imm_j = {{11{s.inst[31]}}, s.inst[31], s.inst[19:12], s.inst[20], s.inst[30:21], 1'b0};

            s.next_pc = pc + 4;
            res = '0;

            case (s.op)
                I_LUI:   begin res = imm_u;      s.rd_write = 1; end
                I_AUIPC: begin res = pc + imm_u; s.rd_write = 1; end
                I_JAL: begin
                    res = pc + 4; s.rd_write = 1;
                    s.next_pc = pc + imm_j;
                end
                I_JALR: begin
                    res = pc + 4; s.rd_write = 1; s.uses_rs1 = 1;
                    s.next_pc = (a + imm_i) & ~32'd1;
                end
                I_BEQ, I_BNE, I_BLT, I_BGE, I_BLTU, I_BGEU: begin
                    s.is_branch = 1; s.uses_rs1 = 1; s.uses_rs2 = 1;
                    case (s.op)
                        I_BEQ:   s.taken = (a == b);
                        I_BNE:   s.taken = (a != b);
                        I_BLT:   s.taken = ($signed(a) <  $signed(b));
                        I_BGE:   s.taken = ($signed(a) >= $signed(b));
                        I_BLTU:  s.taken = (a <  b);
                        default: s.taken = (a >= b);
                    endcase
                    if (s.taken) s.next_pc = pc + imm_b;
                end
                I_LB, I_LH, I_LW, I_LBU, I_LHU: begin
                    s.uses_rs1 = 1; s.rd_write = 1;
                    s.mem_addr = a + imm_i;
                    word    = dmem[word_index(s.mem_addr)];
                    shifted = word >> (8 * s.mem_addr[1:0]);
                    case (s.op)
                        I_LB:    res = {{24{shifted[7]}},  shifted[7:0]};
                        I_LH:    res = {{16{shifted[15]}}, shifted[15:0]};
                        I_LBU:   res = {24'b0, shifted[7:0]};
                        I_LHU:   res = {16'b0, shifted[15:0]};
                        default: res = word;
                    endcase
                end
                I_SB, I_SH, I_SW: begin
                    s.uses_rs1 = 1; s.uses_rs2 = 1; s.is_store = 1;
                    s.mem_addr = a + imm_s;
                    case (s.op)
                        I_SB: begin
                            s.st_we   = 4'b0001 << s.mem_addr[1:0];
                            s.st_data = {4{b[7:0]}};
                        end
                        I_SH: begin
                            s.st_we   = s.mem_addr[1] ? 4'b1100 : 4'b0011;
                            s.st_data = {2{b[15:0]}};
                        end
                        default: begin
                            s.st_we   = 4'b1111;
                            s.st_data = b;
                        end
                    endcase
                    idx = word_index(s.mem_addr);
                    for (int i = 0; i < 4; i++)
                        if (s.st_we[i]) dmem[idx][8*i +: 8] = s.st_data[8*i +: 8];
                end
                I_ADDI, I_SLTI, I_SLTIU, I_XORI, I_ORI, I_ANDI, I_SLLI, I_SRLI, I_SRAI: begin
                    s.uses_rs1 = 1; s.rd_write = 1;
                    res = alu(s.op, a, imm_i);
                end
                I_ADD, I_SUB, I_SLL, I_SLT, I_SLTU, I_XOR, I_SRL, I_SRA, I_OR, I_AND,
                I_MUL, I_MULH, I_MULHSU, I_MULHU, I_DIV, I_DIVU, I_REM, I_REMU: begin
                    s.uses_rs1 = 1; s.uses_rs2 = 1; s.rd_write = 1;
                    s.is_div = is_div_op(s.op);
                    res = alu(s.op, a, b);
                end
                default: ; // FENCE / SYSTEM / ILLEGAL: no architectural effect modelled
            endcase

            s.rd_value = res;
            if (s.rd == 5'd0) s.rd_write = 0;
            if (s.rd_write) regs[s.rd] = res;
            pc = s.next_pc;
            return s;
        endfunction
    endclass

    // =================================================================
    // Transactions
    // =================================================================
    class rv32im_program_item extends uvm_sequence_item;
        string          prog_name = "program";
        rv_image_t      instructions;
        int unsigned    max_cycles      = 2000;
        int unsigned    drain_cycles    = 40;   // > divider latency + pipeline depth
        int             sig_word        = NO_SIGNATURE;
        bit [31:0]      pass_marker     = 32'h0000_0055;
        bit [31:0]      fail_marker     = 32'h0000_00EE;
        bit             has_fail_marker = 1'b1;
        rv_run_status_e status          = RUN_PENDING;
        int unsigned    cycles;

        `uvm_object_utils(rv32im_program_item)

        function new(string name = "rv32im_program_item");
            super.new(name);
        endfunction
    endclass

    class rv32im_retire_item extends uvm_sequence_item;
        bit [31:0] pc;
        bit [31:0] inst;
        bit        we;
        bit [4:0]  rd;
        bit [31:0] data;

        `uvm_object_utils(rv32im_retire_item)

        function new(string name = "rv32im_retire_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("pc=%08h inst=%08h we=%0b rd=x%0d data=%08h", pc, inst, we, rd, data);
        endfunction
    endclass

    class rv32im_store_item extends uvm_sequence_item;
        bit [31:0] addr;
        bit [3:0]  we;
        bit [31:0] data;

        `uvm_object_utils(rv32im_store_item)

        function new(string name = "rv32im_store_item");
            super.new(name);
        endfunction

        function string convert2string();
            return $sformatf("addr=%08h we=%04b data=%08h", addr, we, data);
        endfunction
    endclass

    // =================================================================
    // Agent
    // =================================================================
    class rv32im_sequencer extends uvm_sequencer #(rv32im_program_item);
        `uvm_component_utils(rv32im_sequencer)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction
    endclass

    // Loads the image through the backdoor, resets the core, then runs until
    // the signature store is seen on the bus or max_cycles expires.
    class rv32im_driver extends uvm_driver #(rv32im_program_item);
        `uvm_component_utils(rv32im_driver)

        virtual rv32im_if vif;
        rv32im_backdoor   backdoor;
        uvm_analysis_port #(rv32im_program_item) program_ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            program_ap = new("program_ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual rv32im_if)::get(this, "", "vif", vif))
                `uvm_fatal("NOVIF", "rv32im_if was not configured")
            if (!uvm_config_db#(rv32im_backdoor)::get(this, "", "backdoor", backdoor))
                `uvm_fatal("NOBACKDOOR", "rv32im_backdoor was not configured")
        endfunction

        task run_phase(uvm_phase phase);
            forever begin
                seq_item_port.get_next_item(req);

                @(negedge vif.clk);
                vif.rst_n = 1'b0;
                backdoor.load_imem(req.instructions);
                backdoor.clear_dmem();
                `uvm_info("DRIVER", $sformatf("Loaded program %s (%0d words)",
                                               req.prog_name, req.instructions.size()), UVM_LOW)
                program_ap.write(req);

                repeat (2) @(posedge vif.clk);
                @(negedge vif.clk);
                vif.rst_n = 1'b1;

                wait_for_completion(req);
                repeat (req.drain_cycles) @(posedge vif.clk);
                @(negedge vif.clk);
                seq_item_port.item_done();
            end
        endtask

        task wait_for_completion(rv32im_program_item item);
            item.cycles = 0;
            item.status = (item.sig_word == NO_SIGNATURE) ? RUN_DONE : RUN_TIMEOUT;
            while (item.cycles < item.max_cycles) begin
                @(vif.monitor_cb);
                item.cycles++;
                if (item.sig_word != NO_SIGNATURE &&
                    vif.monitor_cb.st_we == 4'b1111 &&
                    rv32im_iss::word_index(vif.monitor_cb.st_addr) == item.sig_word) begin
                    if (vif.monitor_cb.st_data == item.pass_marker) begin
                        item.status = RUN_PASS;
                        break;
                    end
                    if (item.has_fail_marker && vif.monitor_cb.st_data == item.fail_marker) begin
                        item.status = RUN_FAIL;
                        break;
                    end
                end
            end
        endtask
    endclass

    class rv32im_monitor extends uvm_monitor;
        `uvm_component_utils(rv32im_monitor)

        virtual rv32im_if vif;
        uvm_analysis_port #(rv32im_retire_item) retire_ap;
        uvm_analysis_port #(rv32im_store_item)  store_ap;

        function new(string name, uvm_component parent);
            super.new(name, parent);
            retire_ap = new("retire_ap", this);
            store_ap  = new("store_ap", this);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(virtual rv32im_if)::get(this, "", "vif", vif))
                `uvm_fatal("NOVIF", "rv32im_if was not configured")
        endfunction

        task run_phase(uvm_phase phase);
            rv32im_retire_item r;
            rv32im_store_item  s;
            forever begin
                @(vif.monitor_cb);
                if (vif.monitor_cb.rst_n !== 1'b1) continue;

                if ($isunknown({vif.monitor_cb.trace_pc, vif.monitor_cb.trace_inst,
                                vif.monitor_cb.wb_we, vif.monitor_cb.st_we}))
                    `uvm_error("X_CHECK", "Unknown value on retirement trace / write ports")

                // Flushed and reset bubbles carry inst == 0
                if (vif.monitor_cb.trace_inst != 32'h0) begin
                    r = rv32im_retire_item::type_id::create("r");
                    r.pc   = vif.monitor_cb.trace_pc;
                    r.inst = vif.monitor_cb.trace_inst;
                    r.we   = vif.monitor_cb.wb_we;
                    r.rd   = vif.monitor_cb.wb_rd;
                    r.data = vif.monitor_cb.wb_data;
                    `uvm_info("MONITOR", $sformatf("%s instruction completed (pc=%08h)",
                                                    rv32im_iss::mnemonic_name(rv32im_iss::decode(r.inst)),
                                                    r.pc), UVM_LOW)
                    retire_ap.write(r);
                end

                if (vif.monitor_cb.st_we != 4'b0000) begin
                    s = rv32im_store_item::type_id::create("s");
                    s.addr = vif.monitor_cb.st_addr;
                    s.we   = vif.monitor_cb.st_we;
                    s.data = vif.monitor_cb.st_data;
                    `uvm_info("MON", {"STORE  ", s.convert2string()}, UVM_HIGH)
                    store_ap.write(s);
                end
            end
        endtask
    endclass

    class rv32im_agent extends uvm_agent;
        `uvm_component_utils(rv32im_agent)

        rv32im_sequencer sequencer;
        rv32im_driver    driver;
        rv32im_monitor   monitor;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            sequencer = rv32im_sequencer::type_id::create("sequencer", this);
            driver    = rv32im_driver::type_id::create("driver", this);
            monitor   = rv32im_monitor::type_id::create("monitor", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            driver.seq_item_port.connect(sequencer.seq_item_export);
        endfunction
    endclass

    // =================================================================
    // Scoreboard: lock-step ISS comparison + functional coverage
    //
    // Every non-bubble WB retirement steps the ISS and is checked for PC,
    // instruction, and register write. DIV/REM retire twice in this core:
    // first as a "shell" with reg_we=0 (in order), later as the divider
    // writeback with reg_we=1; the latter is matched against a pending queue.
    // Stores are compared in order on the MEM-stage write port.
    // At program end the full register file and data memory are compared.
    // =================================================================
    `uvm_analysis_imp_decl(_program)
    `uvm_analysis_imp_decl(_retire)
    `uvm_analysis_imp_decl(_store)

    class rv32im_scoreboard extends uvm_component;
        `uvm_component_utils(rv32im_scoreboard)

        uvm_analysis_imp_program #(rv32im_program_item, rv32im_scoreboard) program_export;
        uvm_analysis_imp_retire  #(rv32im_retire_item,  rv32im_scoreboard) retire_export;
        uvm_analysis_imp_store   #(rv32im_store_item,   rv32im_scoreboard) store_export;

        rv32im_backdoor backdoor;
        rv32im_iss      iss;
        bit             active;
        string          prog_name;

        rv_step_t         pending_div_q[$];
        rv_step_t         exp_store_q[$];
        rv32im_store_item dut_store_q[$];

        // Per-program statistics
        int unsigned retired, div_writebacks, dut_stores, mismatches;
        // Whole-run statistics
        int unsigned total_programs, total_retired, total_mismatches;

        // Coverage bookkeeping
        int unsigned  retire_idx;
        int unsigned  last_write_idx[32];
        rv_producer_e last_producer[32];

        covergroup cg_commit with function sample(rv_mnemonic_e op, bit taken,
                                                  int unsigned raw_dist, rv_producer_e producer);
            option.per_instance = 1;
            cp_op: coverpoint op {
                ignore_bins unsupported = {I_FENCE, I_SYSTEM, I_ILLEGAL};
            }
            cp_taken: coverpoint taken;
            cp_raw: coverpoint raw_dist {
                bins distance_bins[] = {[1:3]};
                bins far             = {0};
            }
            cp_producer: coverpoint producer {
                ignore_bins none = {P_NONE};
            }
            x_branch: cross cp_op, cp_taken {
                ignore_bins non_branch = !binsof(cp_op) intersect {I_BEQ, I_BNE, I_BLT, I_BGE, I_BLTU, I_BGEU};
            }
            x_hazard: cross cp_producer, cp_raw {
                ignore_bins far = binsof(cp_raw.far);
            }
        endgroup

        function new(string name, uvm_component parent);
            super.new(name, parent);
            program_export = new("program_export", this);
            retire_export  = new("retire_export", this);
            store_export   = new("store_export", this);
            iss            = new();
            cg_commit      = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            if (!uvm_config_db#(rv32im_backdoor)::get(this, "", "backdoor", backdoor))
                `uvm_fatal("NOBACKDOOR", "rv32im_backdoor was not configured")
        endfunction

        function void mismatch(string id, string msg);
            mismatches++;
            `uvm_error(id, $sformatf("[%s] %s", prog_name, msg))
        endfunction

        function void write_program(rv32im_program_item p);
            iss.reset(p.instructions);
            pending_div_q.delete();
            exp_store_q.delete();
            dut_store_q.delete();
            retired        = 0;
            div_writebacks = 0;
            dut_stores     = 0;
            mismatches     = 0;
            retire_idx     = 0;
            foreach (last_write_idx[i]) begin
                last_write_idx[i] = 0;
                last_producer[i]  = P_NONE;
            end
            prog_name = p.prog_name;
            active    = 1'b1;
        endfunction

        function void write_retire(rv32im_retire_item t);
            rv_step_t     s;
            rv_mnemonic_e op;
            int unsigned  mismatches_before;
            if (!active) return;

            op = rv32im_iss::decode(t.inst);
            if (t.we && rv32im_iss::is_div_op(op)) begin
                check_div_writeback(t);
                return;
            end

            if (t.inst == NOP && t.pc != iss.pc) return;
            mismatches_before = mismatches;

            if (t.pc != iss.pc || t.inst != iss.fetch(iss.pc)) begin
                mismatch("PC_MISMATCH", $sformatf(
                    "DUT retired pc=%08h inst=%08h, ISS expected pc=%08h inst=%08h",
                    t.pc, t.inst, iss.pc, iss.fetch(iss.pc)));
                iss.pc = t.pc; // resync so later checks stay meaningful
            end

            s = iss.step();
            retired++;

            if (s.op inside {I_SYSTEM, I_ILLEGAL})
                mismatch("UNSUPPORTED", $sformatf("pc=%08h inst=%08h (%s) retired", s.pc, s.inst, s.op.name()));

            if (s.is_div) begin
                if (t.we)
                    mismatch("DIV_SHELL", $sformatf("pc=%08h %s shell retired with reg write", s.pc, s.op.name()));
                pending_div_q.push_back(s);
            end else if (s.rd_write) begin
                if (!t.we || t.rd != s.rd || t.data != s.rd_value)
                    mismatch("RD_MISMATCH", $sformatf(
                        "pc=%08h %s: DUT we=%0b x%0d=%08h, expected x%0d=%08h (a=%08h b=%08h)",
                        s.pc, s.op.name(), t.we, t.rd, t.data, s.rd, s.rd_value, s.op_a, s.op_b));
            end else if (t.we && t.rd != 5'd0) begin
                mismatch("UNEXPECTED_WRITE", $sformatf(
                    "pc=%08h %s wrote x%0d=%08h", s.pc, s.op.name(), t.rd, t.data));
            end

            if (s.is_store) begin
                exp_store_q.push_back(s);
                match_stores();
            end

            if (mismatches == mismatches_before && !s.is_store)
                `uvm_info("SCOREBOARD", $sformatf("PASS: %s %s correct",
                          rv32im_iss::mnemonic_name(s.op),
                          s.rd_write ? "result" : "instruction"), UVM_LOW)

            sample_coverage(s);
        endfunction

        function void check_div_writeback(rv32im_retire_item t);
            rv_step_t s;
            int unsigned mismatches_before = mismatches;
            if (pending_div_q.size() == 0) begin
                mismatch("DIV_UNEXPECTED", {"Divider writeback without pending DIV: ", t.convert2string()});
                return;
            end
            s = pending_div_q.pop_front();
            div_writebacks++;
            if (t.pc != s.pc || t.inst != s.inst)
                mismatch("DIV_ORDER", $sformatf("Divider wrote back pc=%08h, expected pc=%08h",
                                                 t.pc, s.pc));
            else if (t.rd != s.rd || (s.rd != 5'd0 && t.data != s.rd_value))
                mismatch("DIV_RESULT", $sformatf(
                    "pc=%08h %s a=%08h b=%08h: DUT x%0d=%08h, expected x%0d=%08h",
                    s.pc, s.op.name(), s.op_a, s.op_b, t.rd, t.data, s.rd, s.rd_value));
            if (mismatches == mismatches_before)
                `uvm_info("SCOREBOARD", $sformatf("PASS: %s result correct",
                          rv32im_iss::mnemonic_name(s.op)), UVM_LOW)
        endfunction

        function void write_store(rv32im_store_item t);
            if (!active) return;
            dut_stores++;
            dut_store_q.push_back(t);
            match_stores();
        endfunction

        function void match_stores();
            rv_step_t         e;
            rv32im_store_item d;
            bit [31:0]        mask;
            while (exp_store_q.size() != 0 && dut_store_q.size() != 0) begin
                e = exp_store_q.pop_front();
                d = dut_store_q.pop_front();
                mask = {{8{e.st_we[3]}}, {8{e.st_we[2]}}, {8{e.st_we[1]}}, {8{e.st_we[0]}}};
                if (d.addr != e.mem_addr || d.we != e.st_we || (d.data & mask) != (e.st_data & mask))
                    mismatch("STORE_MISMATCH", $sformatf(
                        "pc=%08h %s: DUT %s, expected addr=%08h we=%04b data=%08h",
                        e.pc, e.op.name(), d.convert2string(), e.mem_addr, e.st_we, e.st_data));
                else
                    `uvm_info("SCOREBOARD", $sformatf("PASS: %s store data correct",
                              rv32im_iss::mnemonic_name(e.op)), UVM_LOW)
            end
        endfunction

        function void sample_coverage(rv_step_t s);
            int unsigned  raw_dist = 0;
            int unsigned  d;
            rv_producer_e prod = P_NONE;
            retire_idx++;

            if (s.uses_rs1 && s.rs1 != 0 && last_write_idx[s.rs1] != 0) begin
                d = retire_idx - last_write_idx[s.rs1];
                if (d <= 3) begin raw_dist = d; prod = last_producer[s.rs1]; end
            end
            if (s.uses_rs2 && s.rs2 != 0 && last_write_idx[s.rs2] != 0) begin
                d = retire_idx - last_write_idx[s.rs2];
                if (d <= 3 && (raw_dist == 0 || d < raw_dist)) begin
                    raw_dist = d;
                    prod = last_producer[s.rs2];
                end
            end
            cg_commit.sample(s.op, s.taken, raw_dist, prod);

            if (s.rd_write) begin
                last_write_idx[s.rd] = retire_idx;
                case (s.op)
                    I_LB, I_LH, I_LW, I_LBU, I_LHU:   last_producer[s.rd] = P_LOAD;
                    I_MUL, I_MULH, I_MULHSU, I_MULHU: last_producer[s.rd] = P_MUL;
                    I_DIV, I_DIVU, I_REM, I_REMU:     last_producer[s.rd] = P_DIV;
                    I_JAL, I_JALR:                    last_producer[s.rd] = P_JUMP;
                    default:                          last_producer[s.rd] = P_ALU;
                endcase
            end
        endfunction

        // Called by the test after the driver has drained the pipeline
        function void finish_program();
            logic [31:0] v;
            if (!active) return;
            active = 1'b0;

            if (pending_div_q.size() != 0)
                mismatch("DIV_LOST", $sformatf("%0d DIV/REM result(s) never written back (first pc=%08h)",
                                               pending_div_q.size(), pending_div_q[0].pc));
            if (exp_store_q.size() != 0)
                mismatch("STORE_MISSING", $sformatf("%0d expected store(s) not seen (first pc=%08h)",
                                                    exp_store_q.size(), exp_store_q[0].pc));
            if (dut_store_q.size() != 0)
                mismatch("STORE_EXTRA", {"Unexpected DUT store: ", dut_store_q[0].convert2string()});

            for (int i = 1; i < 32; i++) begin
                v = backdoor.read_reg(i);
                if (v !== iss.regs[i])
                    mismatch("FINAL_REG", $sformatf("x%0d DUT=%08h ISS=%08h", i, v, iss.regs[i]));
            end
            for (int i = 0; i < MEM_WORDS; i++) begin
                v = backdoor.read_dmem(i);
                if (v !== iss.dmem[i])
                    mismatch("FINAL_DMEM", $sformatf("dmem[%0d] DUT=%08h ISS=%08h", i, v, iss.dmem[i]));
            end

            total_programs++;
            total_retired    += retired;
            total_mismatches += mismatches;
            `uvm_info("SB", $sformatf("[%s] retired=%0d stores=%0d div_writebacks=%0d mismatches=%0d",
                                      prog_name, retired, dut_stores, div_writebacks, mismatches), UVM_LOW)
        endfunction

        function void report_phase(uvm_phase phase);
            `uvm_info("SB", $sformatf(
                "SUMMARY programs=%0d retired=%0d mismatches=%0d functional_coverage=%0.2f%%",
                total_programs, total_retired, total_mismatches, cg_commit.get_inst_coverage()), UVM_NONE)
        endfunction
    endclass

    class rv32im_env extends uvm_env;
        `uvm_component_utils(rv32im_env)

        rv32im_agent      agent;
        rv32im_scoreboard scoreboard;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            agent      = rv32im_agent::type_id::create("agent", this);
            scoreboard = rv32im_scoreboard::type_id::create("scoreboard", this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            agent.driver.program_ap.connect(scoreboard.program_export);
            agent.monitor.retire_ap.connect(scoreboard.retire_export);
            agent.monitor.store_ap.connect(scoreboard.store_export);
        endfunction
    endclass

    class rv32im_program_sequence extends uvm_sequence #(rv32im_program_item);
        `uvm_object_utils(rv32im_program_sequence)

        rv32im_program_item item;

        function new(string name = "rv32im_program_sequence");
            super.new(name);
        endfunction

        task body();
            start_item(item);
            finish_item(item);
        endtask
    endclass

    // =================================================================
    // Random program generator
    // Forward-only control flow (always terminates), memory accesses through
    // a fixed base register, small register pool to maximise hazards.
    // =================================================================
    class rv32im_random_program;
        bit [31:0] code[$];

        function bit [4:0] dst();
            return 5'($urandom_range(1, RAND_POOL));
        endfunction

        function bit [4:0] src();
            return ($urandom_range(0, 9) == 0) ? 5'd0 : 5'($urandom_range(1, RAND_POOL));
        endfunction

        function int imm12();
            return $urandom_range(0, 1) ? int'($urandom_range(0, 32)) - 16
                                        : int'($urandom_range(0, 4095)) - 2048;
        endfunction

        function int mem_offset(bit [2:0] funct3);
            int off = int'($urandom_range(0, 127)) * 4 - 256;
            case (funct3[1:0])
                2'b00:   off += $urandom_range(0, 3);       // byte
                2'b01:   off += 2 * $urandom_range(0, 1);   // half
                default: ;                                  // word
            endcase
            return off;
        endfunction

        function int unsigned skip(int unsigned room_after);
            return $urandom_range(0, (room_after < 3) ? room_after : 3);
        endfunction

        function rv_image_t build(int unsigned body_len);
            int unsigned body_end;
            bit [31:0]   v;
            rv_image_t   image;
            code.delete();

            for (int r = 1; r <= RAND_POOL; r++) begin
                v = $urandom;
                code.push_back(enc_u(OPC_LUI, v[31:12], 5'(r)));
                code.push_back(enc_i(OPC_OPIMM, int'(v[11:0]), 5'(r), 3'b100, 5'(r)));
            end
            code.push_back(enc_i(OPC_OPIMM, RAND_MEM_BASE, 5'd0, 3'b000, RAND_BASE_REG));

            body_end = code.size() + body_len;
            while (code.size() < body_end) gen_one(body_end);
            code.push_back(enc_j(0, 5'd0)); // park

            image = new[code.size()];
            foreach (code[i]) image[i] = code[i];
            return image;
        endfunction

        function void gen_one(int unsigned body_end);
            int unsigned room = body_end - code.size();
            bit [2:0]    f3;
            int          imm;
            bit [2:0]    load_f3[5]   = '{3'b000, 3'b001, 3'b010, 3'b100, 3'b101};
            bit [2:0]    branch_f3[6] = '{3'b000, 3'b001, 3'b100, 3'b101, 3'b110, 3'b111};

            randcase
                25: begin // R-type integer
                    f3 = $urandom;
                    code.push_back(enc_r(((f3 == 3'b000 || f3 == 3'b101) && $urandom_range(0, 1)) ?
                                         7'b0100000 : 7'b0000000, src(), src(), f3, dst()));
                end
                18: begin // I-type integer
                    f3 = $urandom;
                    if (f3 == 3'b001)      imm = $urandom_range(0, 31);
                    else if (f3 == 3'b101) imm = $urandom_range(0, 31) | ($urandom_range(0, 1) ? 'h400 : 0);
                    else                   imm = imm12();
                    code.push_back(enc_i(OPC_OPIMM, imm, src(), f3, dst()));
                end
                8:  code.push_back(enc_r(7'b0000001, src(), src(), 3'($urandom_range(0, 3)), dst())); // MUL*
                8:  code.push_back(enc_r(7'b0000001, src(), src(), 3'($urandom_range(4, 7)), dst())); // DIV/REM*
                12: begin
                    f3 = load_f3[$urandom_range(0, 4)];
                    code.push_back(enc_i(OPC_LOAD, mem_offset(f3), RAND_BASE_REG, f3, dst()));
                end
                10: begin
                    f3 = 3'($urandom_range(0, 2));
                    code.push_back(enc_s(mem_offset(f3), src(), RAND_BASE_REG, f3));
                end
                6:  code.push_back(enc_b(4 * (1 + skip(room - 1)), src(), src(),
                                         branch_f3[$urandom_range(0, 5)]));
                3:  code.push_back(enc_j(4 * (1 + skip(room - 1)),
                                         $urandom_range(0, 3) ? dst() : 5'd0));
                2: begin // JALR, target computed from AUIPC
                    if (room < 2) begin
                        code.push_back(NOP);
                    end else begin
                        code.push_back(enc_u(OPC_AUIPC, 20'd0, RAND_TMP_REG));
                        code.push_back(enc_i(OPC_JALR, 4 * (2 + skip(room - 2)), RAND_TMP_REG,
                                             3'b000, $urandom_range(0, 3) ? dst() : 5'd0));
                    end
                end
                4:  code.push_back(enc_u($urandom_range(0, 1) ? OPC_LUI : OPC_AUIPC, 20'($urandom), dst()));
                4: begin // corner operand values
                    case ($urandom_range(0, 3))
                        0: code.push_back(enc_i(OPC_OPIMM,  0, 5'd0, 3'b000, dst()));
                        1: code.push_back(enc_i(OPC_OPIMM, -1, 5'd0, 3'b000, dst()));
                        2: code.push_back(enc_u(OPC_LUI, 20'h80000, dst()));
                        default: code.push_back(enc_i(OPC_OPIMM, 1, 5'd0, 3'b000, dst()));
                    endcase
                end
            endcase
        endfunction
    endclass

    // =================================================================
    // Tests
    // =================================================================
    class rv32im_base_test extends uvm_test;
        `uvm_component_utils(rv32im_base_test)

        rv32im_env      env;
        rv32im_backdoor backdoor;
        string          mem_dir = "../mem/";
        int unsigned    report_tests, report_passed, report_failed;
        bit             last_test_failed;

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            env = rv32im_env::type_id::create("env", this);
            if (!uvm_config_db#(rv32im_backdoor)::get(this, "", "backdoor", backdoor))
                `uvm_fatal("NOBACKDOOR", "rv32im_backdoor was not configured")
            void'($value$plusargs("MEM_DIR=%s", mem_dir));
        endfunction

        function void start_of_simulation_phase(uvm_phase phase);
            super.start_of_simulation_phase(phase);
            $display("--------------------------------------------------");
            $display("              RV32IM UVM TEST REPORT");
            $display("--------------------------------------------------");
            $display("");
            $display("[TEST]       %s", get_type_name());
            $display("[TEST]       Starting simulation...");
            $display("");
        endfunction

        function void mark_last_test_failed();
            if (report_tests != 0 && !last_test_failed) begin
                report_passed--;
                report_failed++;
                last_test_failed = 1'b1;
            end
        endfunction

        function rv32im_program_item new_program(string name, rv_image_t image,
                                                 int unsigned max_cycles = 2000);
            rv32im_program_item item = rv32im_program_item::type_id::create(name);
            item.prog_name    = name;
            item.instructions = image;
            item.max_cycles   = max_cycles;
            return item;
        endfunction

        function rv_image_t load_mem_file(string file);
            bit [31:0] words[MEM_WORDS];
            rv_image_t image;
            string     path = {mem_dir, file};
            int        fd   = $fopen(path, "r");
            if (fd == 0)
                `uvm_fatal("MEM_FILE", $sformatf("Cannot open %s (use +MEM_DIR=<dir>/)", path))
            $fclose(fd);
            foreach (words[i]) words[i] = NOP;
            $readmemh(path, words);
            image = new[MEM_WORDS];
            foreach (words[i]) image[i] = words[i];
            return image;
        endfunction

        task run_item(rv32im_program_item item);
            rv32im_program_sequence seq;
            uvm_report_server    srv;
            int                  errors_before;
            seq = rv32im_program_sequence::type_id::create({item.prog_name, "_seq"});
            seq.item = item;
            srv = uvm_report_server::get_server();
            errors_before = srv.get_severity_count(UVM_ERROR) + srv.get_severity_count(UVM_FATAL);
            `uvm_info("TEST", $sformatf("===== Running %s =====", item.prog_name), UVM_LOW)
            seq.start(env.agent.sequencer);
            env.scoreboard.finish_program();
            report_tests++;
            last_test_failed = (item.status inside {RUN_FAIL, RUN_TIMEOUT}) ||
                               (env.scoreboard.mismatches != 0) ||
                               (srv.get_severity_count(UVM_ERROR) + srv.get_severity_count(UVM_FATAL) >
                                errors_before);
            if (last_test_failed) report_failed++;
            else report_passed++;
            case (item.status)
                RUN_PASS: `uvm_info("TEST", $sformatf("%s: PASS signature after %0d cycles",
                                                      item.prog_name, item.cycles), UVM_LOW)
                RUN_DONE: `uvm_info("TEST", $sformatf("%s: ran %0d cycles",
                                                      item.prog_name, item.cycles), UVM_LOW)
                RUN_FAIL: `uvm_error("TEST", $sformatf("%s: program wrote FAIL signature %08h",
                                                       item.prog_name, item.fail_marker))
                default:  `uvm_error("TEST", $sformatf("%s: timed out after %0d cycles",
                                                       item.prog_name, item.cycles))
            endcase
        endtask

        function void expect_reg(int unsigned index, bit [31:0] expected);
            logic [31:0] v = backdoor.read_reg(index);
            if (v !== expected) begin
                mark_last_test_failed();
                `uvm_error("REG_MISMATCH", $sformatf("x%0d expected %08h, got %08h", index, expected, v))
            end
        endfunction

        function void expect_dmem(int unsigned word, bit [31:0] expected, string description);
            logic [31:0] v = backdoor.read_dmem(word);
            if (v !== expected) begin
                mark_last_test_failed();
                `uvm_error("DMEM_MISMATCH", $sformatf("%s: dmem[%0d] expected %08h, got %08h",
                                                      description, word, expected, v))
            end else
                `uvm_info("CHECK", $sformatf("%s: dmem[%0d] = %08h", description, word, v), UVM_MEDIUM)
        endfunction

        // ---------------------------------------------------------------
        // Directed program: forwarding, load-use, branch/JAL flush, MUL/DIV
        // ---------------------------------------------------------------
        task run_directed();
            rv_image_t img = new[20];
            img[0]  = enc_i(OPC_OPIMM, 20, 0, 3'b000, 1);   // x1 = 20
            img[1]  = enc_i(OPC_OPIMM, 6,  0, 3'b000, 2);   // x2 = 6
            img[2]  = enc_i(OPC_OPIMM, 1,  1, 3'b000, 3);   // forwarding: x3 = 21
            img[3]  = enc_r(7'b0000000, 2, 3, 3'b000, 4);   // x4 = 27
            img[4]  = enc_r(7'b0100000, 1, 4, 3'b000, 5);   // x5 = 7
            img[5]  = enc_r(7'b0000000, 1, 4, 3'b111, 6);   // x6 = 16
            img[6]  = enc_r(7'b0000000, 1, 4, 3'b110, 7);   // x7 = 31
            img[7]  = enc_r(7'b0000000, 1, 4, 3'b100, 8);   // x8 = 15
            img[8]  = enc_s(0, 4, 0, 3'b010);               // sw x4, 0(x0)
            img[9]  = enc_i(OPC_LOAD, 0, 0, 3'b010, 10);    // lw x10, 0(x0)
            img[10] = enc_r(7'b0000000, 1, 10, 3'b000, 11); // load-use: x11 = 47
            img[11] = enc_b(8, 0, 11, 3'b001);              // bne x11,x0,+8
            img[12] = enc_i(OPC_OPIMM, 99, 0, 3'b000, 12);  // flushed
            img[13] = enc_j(8, 13);                         // x13 = 56
            img[14] = enc_i(OPC_OPIMM, 77, 0, 3'b000, 14);  // flushed
            img[15] = enc_i(OPC_OPIMM, 42, 0, 3'b000, 15);  // jump target
            img[16] = enc_r(7'b0000001, 2, 1, 3'b000, 16);  // mul x16 = 120
            img[17] = enc_r(7'b0000001, 2, 1, 3'b100, 17);  // div x17 = 3
            img[18] = enc_i(OPC_OPIMM, 1, 17, 3'b000, 18);  // DIV consumer x18 = 4
            img[19] = enc_j(0, 0);                          // park

            run_item(new_program("directed", img, 120));

            expect_reg(1,  32'd20);  expect_reg(2,  32'd6);
            expect_reg(3,  32'd21);  expect_reg(4,  32'd27);
            expect_reg(5,  32'd7);   expect_reg(6,  32'd16);
            expect_reg(7,  32'd31);  expect_reg(8,  32'd15);
            expect_reg(10, 32'd27);  expect_reg(11, 32'd47);
            expect_reg(12, 32'd0);   expect_reg(13, 32'd56);
            expect_reg(14, 32'd0);   expect_reg(15, 32'd42);
            expect_reg(16, 32'd120); expect_reg(17, 32'd3);
            expect_reg(18, 32'd4);
        endtask

        // ---------------------------------------------------------------
        // Program images from tb/mem (same checks as tb_riscv_programs.sv)
        // ---------------------------------------------------------------
        task run_mem_programs();
            rv32im_program_item item;

            item = new_program("basic_instructions", load_mem_file("basic_instructions_test.mem"));
            item.sig_word = 64;
            run_item(item);
            expect_dmem(64, 32'h0000_0055, "Basic instruction PASS signature");

            item = new_program("pipeline_hazard", load_mem_file("pipeline_harzard_test.mem"));
            item.sig_word = 67;
            item.pass_marker = 32'd20;
            item.has_fail_marker = 1'b0;
            run_item(item);
            expect_dmem(64, 32'd30, "Pipeline result x3");
            expect_dmem(65, 32'd50, "Load-use result x7");
            expect_dmem(66, 32'd7,  "Taken-branch target result x9");
            expect_dmem(67, 32'd20, "Pipeline completion store");
            expect_dmem(68, 32'd0,  "Wrong-path store was flushed");
            if (env.scoreboard.dut_stores != 4) begin
                mark_last_test_failed();
                `uvm_error("STORE_COUNT", $sformatf("Pipeline test expected 4 stores, observed %0d",
                                                    env.scoreboard.dut_stores))
            end

            item = new_program("load_store_subsystem", load_mem_file("load_store_subsystem_test.mem"));
            item.sig_word = 128;
            run_item(item);
            expect_dmem(64,  32'h80FF_8001, "Seed word and byte address");
            expect_dmem(65,  32'h4433_2211, "SB byte lanes and strobes");
            expect_dmem(66,  32'h0456_0123, "SH halfword lanes and strobes");
            expect_dmem(68,  32'h89AB_C123, "SW/LW word address");
            expect_dmem(128, 32'h0000_0055, "Load/store PASS signature");

            item = new_program("control_flow_corner_cases", load_mem_file("control_flow_corner_cases_test.mem"));
            item.sig_word = 64;
            run_item(item);
            expect_dmem(64, 32'h0000_0055, "Control-flow PASS signature");

            // PASS goes to MMIO 0x80000000, which aliases to dmem word 0
            item = new_program("soc_all", load_mem_file("test_soc_all.mem"));
            item.sig_word = 0;
            run_item(item);
            expect_dmem(0,  32'h0000_0055, "SoC all PASS signature (MMIO alias)");
            expect_dmem(64, 32'd10,        "SoC all SW/LW RAM word");
        endtask

        // ---------------------------------------------------------------
        // Constrained-random programs, checked entirely by the ISS
        // ---------------------------------------------------------------
        task run_random(int unsigned num_programs, int unsigned body_len);
            rv32im_random_program gen = new();
            int unsigned max_len = MEM_WORDS - (2 * RAND_POOL + 2);
            if (body_len > max_len) body_len = max_len;
            for (int unsigned n = 0; n < num_programs; n++)
                run_item(new_program($sformatf("random_%0d", n), gen.build(body_len),
                                     body_len * 16 + 200));
        endtask

        function void report_phase(uvm_phase phase);
            uvm_report_server srv = uvm_report_server::get_server();
            super.report_phase(phase);
            $display("");
            $display("--------------------------------------------------");
            $display("                  TEST SUMMARY");
            $display("--------------------------------------------------");
            $display("Total Tests  : %0d", report_tests);
            $display("Passed       : %0d", report_passed);
            $display("Failed       : %0d", report_failed);
            $display("");
            $display("UVM_INFO     : %0d", srv.get_severity_count(UVM_INFO));
            $display("UVM_WARNING  : %0d", srv.get_severity_count(UVM_WARNING));
            $display("UVM_ERROR    : %0d", srv.get_severity_count(UVM_ERROR));
            $display("UVM_FATAL    : %0d", srv.get_severity_count(UVM_FATAL));
            $display("--------------------------------------------------");
        endfunction
    endclass

    class rv32im_directed_test extends rv32im_base_test;
        `uvm_component_utils(rv32im_directed_test)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            run_directed();
            phase.drop_objection(this);
        endtask
    endclass

    // Runs every program in tb/mem with its signature + expected-word checks
    class rv32im_mem_regression_test extends rv32im_base_test;
        `uvm_component_utils(rv32im_mem_regression_test)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            phase.raise_objection(this);
            run_mem_programs();
            phase.drop_objection(this);
        endtask
    endclass

    // Single image: +MEM_FILE=<file> [+SIG_WORD=<n>] [+PASS_MARKER=<hex>]
    //               [+FAIL_MARKER=<hex>] [+MAX_CYCLES=<n>]
    class rv32im_mem_file_test extends rv32im_base_test;
        `uvm_component_utils(rv32im_mem_file_test)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            rv32im_program_item item;
            string       file;
            int          sig_word = NO_SIGNATURE;
            int unsigned max_cycles = 2000;
            bit [31:0]   marker;

            phase.raise_objection(this);
            if (!$value$plusargs("MEM_FILE=%s", file))
                `uvm_fatal("PLUSARG", "rv32im_mem_file_test needs +MEM_FILE=<file>")
            void'($value$plusargs("SIG_WORD=%d", sig_word));
            void'($value$plusargs("MAX_CYCLES=%d", max_cycles));

            item = new_program(file, load_mem_file(file), max_cycles);
            item.sig_word = sig_word;
            if ($value$plusargs("PASS_MARKER=%h", marker)) item.pass_marker = marker;
            if ($value$plusargs("FAIL_MARKER=%h", marker)) item.fail_marker = marker;
            run_item(item);
            phase.drop_objection(this);
        endtask
    endclass

    // +NUM_PROGRAMS=<n> (default 10) +PROG_LEN=<n> (default 200); seed via simulator
    class rv32im_random_test extends rv32im_base_test;
        `uvm_component_utils(rv32im_random_test)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            int unsigned num_programs = 10;
            int unsigned prog_len     = 200;
            phase.raise_objection(this);
            void'($value$plusargs("NUM_PROGRAMS=%d", num_programs));
            void'($value$plusargs("PROG_LEN=%d", prog_len));
            run_random(num_programs, prog_len);
            phase.drop_objection(this);
        endtask
    endclass

    class rv32im_full_regression_test extends rv32im_base_test;
        `uvm_component_utils(rv32im_full_regression_test)

        function new(string name, uvm_component parent);
            super.new(name, parent);
        endfunction

        task run_phase(uvm_phase phase);
            int unsigned num_programs = 10;
            int unsigned prog_len     = 200;
            phase.raise_objection(this);
            void'($value$plusargs("NUM_PROGRAMS=%d", num_programs));
            void'($value$plusargs("PROG_LEN=%d", prog_len));
            run_directed();
            run_mem_programs();
            run_random(num_programs, prog_len);
            phase.drop_objection(this);
        endtask
    endclass
endpackage

module rv32im_uvm_tb;
    import uvm_pkg::*;
    import rv32im_uvm_pkg::*;

    logic clk = 1'b0;
    rv32im_if vif(clk);

    always #5 clk = ~clk;

    riscv dut (
        .clk        (clk),
        .rst_n      (vif.rst_n),
        .trace_pc   (vif.trace_pc),
        .trace_inst (vif.trace_inst)
    );

    assign vif.wb_we   = dut.u_datapath.reg_we_w;
    assign vif.wb_rd   = dut.u_datapath.rd_w;
    assign vif.wb_data = dut.u_datapath.d_rd_w;
    assign vif.st_we   = dut.store_we_dmem;
    assign vif.st_addr = dut.store_addr_dmem;
    assign vif.st_data = dut.d_store_dmem_m;

    class tb_backdoor extends rv32im_backdoor;
        function void load_imem(rv_image_t image);
            for (int i = 0; i < MEM_WORDS; i++)
                dut.u_memorypath.u_imem.iram[i] = (i < image.size()) ? image[i] : NOP;
        endfunction

        // dram is written by always_ff in dmem, so reload it instead of assigning
        function void clear_dmem();
            $readmemh(DMEM_ZERO_FILE, dut.u_memorypath.u_dmem.dram);
        endfunction

        function logic [31:0] read_dmem(int unsigned word_index);
            return dut.u_memorypath.u_dmem.dram[word_index];
        endfunction

        function logic [31:0] read_reg(int unsigned index);
            return dut.u_datapath.u_id.u_rf.mem[index];
        endfunction
    endclass

    initial begin
        bit [31:0]  zeros[MEM_WORDS];
        tb_backdoor bd;

        $writememh(DMEM_ZERO_FILE, zeros);
        vif.rst_n = 1'b0;
        bd = new();
        uvm_config_db#(virtual rv32im_if)::set(null, "*", "vif", vif);
        uvm_config_db#(rv32im_backdoor)::set(null, "*", "backdoor", bd);
        run_test();
    end
endmodule
