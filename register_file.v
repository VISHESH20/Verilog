// register_file.v
// Contains four 8-bit general-purpose registers (R0-R3).
module register_file (
    input         clk,
    input         rst,
    input         write_enable,
    input  [1:0]  read_addr_s,
    input  [1:0]  read_addr_d,
    input  [1:0]  write_addr_d,
    input  [7:0]  write_data,
    output [7:0]  read_data_s,
    output [7:0]  read_data_d
);
    // Array of four 8-bit registers
    reg [7:0] registers[0:3];

    // Asynchronous read for simplicity
    assign read_data_s = registers[read_addr_s];
    assign read_data_d = registers[read_addr_d];
    
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset all registers to zero
            for (i=0; i<4; i=i+1) begin
                registers[i] <= 8'h00;
            end
        end else begin
            if (write_enable) begin
                registers[write_addr_d] <= write_data;
            end
        end
    end
endmodule
