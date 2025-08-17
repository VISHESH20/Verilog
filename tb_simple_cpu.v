// tb_simple_cpu.v
// Testbench for the simple_cpu module.
`timescale 1ns / 1ps

module tb_simple_cpu;

    // Inputs to the DUT
    reg clk;
    reg rst;

    // Instantiate the Unit Under Test (UUT)
    simple_cpu uut (
        .clk(clk), 
        .rst(rst)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns period, 100MHz clock
    end

    // Test sequence
    initial begin
        // Initialize Inputs
        rst = 1;
        #15; // Hold reset for a short period
        rst = 0;

        #200; // Run simulation for 200ns to allow program to finish
        $finish;
    end
    
    // Monitor key signals to observe execution
    initial begin
        $monitor("Time=%0t PC=%d, Instr=%h, R0=%d, R1=%d, R2=%d, R3=%d, Mem[16]=%d",
                 $time, uut.pc, uut.instruction, 
                 uut.rf.registers[0], uut.rf.registers[1], uut.rf.registers[2], uut.rf.registers[3],
                 uut.data_mem[16]);
    end
      
endmodule
