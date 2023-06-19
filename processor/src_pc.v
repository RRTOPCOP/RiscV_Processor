module pc_src (branch, jump, jalr, funct3, zero, u_slt, s_slt, ifid_pc_out, idex_pc_out, pc_ctr);
  input  branch, jump, jalr; //from decoder
  input zero, u_slt, s_slt; //from ALU
  input[2:0] funct3; //from decoder
  input [31:0] ifid_pc_out;
  input [31:0] idex_pc_out;
  output  pc_ctr; //to mux_pcsrc

  assign pc_ctr = pcctr(branch, jump, jalr, funct3, zero, u_slt, s_slt, ifid_pc_out, idex_pc_out);

  //function for pc_ctr
  function  pcctr;

    input  branch;
    input  jump;
    input jalr;
    input [2:0] funct3;
    input  zero;
    input  u_slt;
    input  s_slt;
    input [31:0] ifid_pc_out;
    input [31:0] idex_pc_out;

    //jump or branch
    if (jump == 1) begin
      pcctr = 1;
    end else if(jalr == 1) begin
      pcctr = 1;
    end else if((branch == 1) && (ifid_pc_out != idex_pc_out)) begin

      case(funct3)
      3'b000: pcctr = zero; //beq
      3'b001: pcctr = ~zero; //bne
      3'b100: pcctr = s_slt; //blt
      3'b101: pcctr = ~s_slt; //bge
      3'b110: pcctr = u_slt; //bltu
      3'b111: pcctr = ~u_slt; //bgeu
      endcase

    end else begin
      pcctr = 0;
    end
    
  endfunction

endmodule