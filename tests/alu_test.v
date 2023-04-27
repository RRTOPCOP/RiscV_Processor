`include "../alu32_func.v"

module alu_test;
  reg [31:0] dataA, dataB;
  reg [2:0] alu_op;
  wire [31:0] alu_out_data;
  wire zero, overflow, u_slt, s_slt;
  integer i;

  //test_data
  reg [2:0] test_aluOp [7:0];
  reg [31:0] ans [7:0];

  //instance of ALU
  alu test_alu(
    .dataA(dataA), 
    .dataB(dataB), 
    .alu_op(alu_op),
    .alu_out_data(alu_out_data), 
    .zero(zero), 
    .overflow(overflow), 
    .u_slt(u_slt), 
    .s_slt(s_slt)
    );
  
  //test_aluOp data
  initial begin
    test_aluOp[0] = 3'b000;//ADD
    test_aluOp[1] = 3'b001;//SUB
    test_aluOp[2] = 3'b010;//OR
    test_aluOp[3] = 3'b100;//AND
    test_aluOp[4] = 3'b011;//XOR
    test_aluOp[5] = 3'b101;//shift A right by B
    test_aluOp[6] = 3'b110;//logical shift A right by B
    test_aluOp[7] = 3'b111;//logical shift A left byB
  end


  initial begin 
    i = 0;
    dataA = 12;
    dataB = 10;
    ans[0] = dataA + dataB;
    ans[1] = dataA - dataB;
    ans[2] = dataA | dataB;
    ans[3] = dataA & dataB;
    ans[4] = dataA ^ dataB;
    ans[5] = dataA >>> dataB;
    ans[6] = dataA >> dataB;
    ans[7] = dataA << dataB;

    repeat (8) begin
      alu_op = test_aluOp[i];
      #10;
      $display("alu=%b\nans=%b\nzero=%d u_slt=%d s_slt=%d",alu_out_data, ans[i], zero, u_slt, s_slt);
      i = i + 1;
    end

    #10 $finish;
  end

endmodule