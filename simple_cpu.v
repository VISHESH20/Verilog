// simple_cpu.v
// Top-level module for the 8-bit CPU.
module simple_cpu (
    input clk,
    input rst
);

    // Program Counter
    reg  [7:0] pc;
    wire [7:0] pc_plus_1 = pc + 1;

    // Instruction Memory
    reg  [15:0] instr_mem[0:255];
    wire [15:0] instruction = instr_mem[pc];

    // Instruction Decoding
    wire [3:0] opcode = instruction[15:12];
    wire [1:0] rd_addr = instruction[11:10];
    wire [1:0] rs_addr = instruction[9:8];
    wire [7:0] imm_addr = instruction[7:0];

    // Control Unit Signals
    wire reg_write_en;
    wire mem_write_en;
    wire jump_en;
    wire alu_src_b_is_imm;
    wire [2:0] alu_op;

    // Data Memory
    reg [7:0] data_mem[0:255];
    wire [7:0] mem_read_data = data_mem[alu_result];

    // Register File Instantiation
    wire [7:0] reg_read_s, reg_read_d;
    register_file rf (
        .clk(clk), .rst(rst),
        .write_enable(reg_write_en),
        .read_addr_s(rs_addr),
        .read_addr_d(rd_addr),
        .write_addr_d(rd_addr),
        .write_data(alu_result),
        .read_data_s(reg_read_s),
        .read_data_d(reg_read_d)
    );

    // ALU Instantiation
    wire [7:0] alu_result;
    wire       alu_zero_flag;
    wire [7:0] alu_b_operand = alu_src_b_is_imm ? imm_addr : reg_read_s;
    
    alu alu_unit (
        .a(reg_read_d),
        .b(alu_b_operand),
        .alu_op(alu_op),
        .result(alu_result),
        .zero_flag(alu_zero_flag)
    );
    
    // Control Unit (combinational logic based on opcode)
    parameter HALT = 4'b0000, LOAD = 4'b0001, STORE = 4'b0010,
              ADD = 4'b0011, SUB = 4'b0100, ADDI = 4'b0101,
              JMP = 4'b0110, AND = 4'b0111;

    assign reg_write_en = (opcode == LOAD) || (opcode == ADD) || (opcode == SUB) || (opcode == ADDI) || (opcode == AND);
    assign mem_write_en = (opcode == STORE);
    assign jump_en = (opcode == JMP);
    assign alu_src_b_is_imm = (opcode == ADDI);

    assign alu_op = (opcode == ADD || opcode == ADDI) ? 3'b000 : // ADD
                    (opcode == SUB) ? 3'b001 :                   // SUB
                    (opcode == AND) ? 3'b010 :                   // AND
                    (opcode == LOAD || opcode == STORE) ? 3'b011 : // PASS B
                    3'bxxx;

    // PC Logic
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            pc <= 8'h00;
        end else if (opcode != HALT) begin
            if (jump_en) begin
                pc <= imm_addr;
            end else begin
                pc <= pc_plus_1;
            end
        end
    end

    // Data Memory Write Logic
    always @(posedge clk) begin
        if (mem_write_en) begin
            data_mem[alu_result] <= reg_read_s;
        end
    end
    
    // Initialize instruction memory with a sample program
    initial begin
        instr_mem[0] = 16'b0101_01_00_00000101; // ADDI R1, 5
        instr_mem[1] = 16'b0101_10_00_00001100; // ADDI R2, 12
        instr_mem[2] = 16'b0011_11_10_00000000; // ADD R3, R2 -> R3 is now 12
        instr_mem[3] = 16'b0100_11_01_00000000; // SUB R3, R1 -> R3 is 12-5=7
        instr_mem[4] = 16'b0010_00_11_00010000; // STORE R3, [16]
        instr_mem[5] = 16'b0001_00_00_00010000; // LOAD R0, [16]
        instr_mem[6] = 16'b0000_00_00_00000000; // HALT
    end

endmodule
