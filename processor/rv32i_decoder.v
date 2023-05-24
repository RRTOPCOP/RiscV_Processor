module decoder (instruction, opcode, funct3, rd, rs1, rs2, funct7, imm, alu_op, reg_write, alu_src, jump, mem_to_reg, mem_read, mem_write, branch, jalr);
  input [31:0] instruction;
  output [6:0] opcode;
  output [2:0] funct3;
  output [6:0] funct7;
  output [4:0] rd;
  output [4:0] rs1;
  output [4:0] rs2;
  output [31:0] imm;  
  output [2:0] alu_op; 
  output  reg_write; // whether write in register
  output  alu_src; // immidiate or not
  output  jump; // is true when jal 
  output  mem_to_reg; // whether write memory to register
  output  mem_read; // whether road memory
  output  mem_write; // whether write in memory
  output  branch; //is true when Bformat
  output  jalr; // is true when jalr
  // output  isload; //is true when lw

//field
  assign opcode = instruction[6:0];
  assign funct3 = instruction[14:12];
  assign funct7 = instruction[31:25];
  assign rd = instruction[11:7];
  assign rs1 = instruction[19:15];
  assign rs2 = instruction[24:20];

//controll signal
  assign alu_op = alu_ctr(opcode, funct3, funct7);
  assign imm = immidiate(opcode, instruction);
  assign reg_write = regwrite(opcode);
  assign alu_src = alusrc(opcode);
  assign jump = (opcode == 7'b1101111); //jal
  assign mem_to_reg = memtoreg(opcode);
  assign mem_read = memread(opcode);
  assign mem_write = memwrite(opcode);
  assign branch = (opcode == 7'b1100011); //Bformat only
  assign jalr = (opcode == 7'b1100111);
  // assign isload = (opcode == 7'b0000011);



//function for imm
  function [32:0] immidiate;

  input [6:0] opcode;
  input [31:0] instruction;

  case(opcode)
    //Iformat
    7'b0000011,                                     //lw
    7'b0010011,                                     //immidiate
    7'b1100111: immidiate = $signed(instruction[31:20]);      //jalr
    7'b1101111: immidiate = $signed({instruction[31], instruction[19:12], instruction[20], instruction[30:21], 1'b0});     //jal
    //Uformat
    7'b0110111,
    7'b0010111: immidiate = {instruction[31:12], 12'b0};
    //Bformat,Sformat
    7'b0100011: immidiate = $signed({instruction[31:25], instruction[11:7]});
    7'b1100011: immidiate = $signed({instruction[31], instruction[7], instruction[30:25], instruction[11:8], 1'b0});

  endcase

  endfunction

 
//function for alu_op
  function [2:0] alu_ctr;
    input [6:0] opcode;
    input [2:0] funct3;
    input [6:0] funct7;

    case(opcode)
      7'b0110011: //Rformat
        case(funct3)
          3'b000:
          case(funct7)
            7'b0: alu_ctr = 3'b0;//ADD
            7'b0100000: alu_ctr = 3'b001;//SUB
          endcase
          3'b001: alu_ctr = 3'b111;//SLL
          3'b010: alu_ctr = 3'b001;//SLT,ALU->SUB
          3'b011: alu_ctr = 3'b001;//SLTU,ALU->SUB
          3'b100: alu_ctr = 3'b011;//XOR
          3'b101: 
          case(funct7)
            7'b0: alu_ctr = 3'b110;//SRL
            7'b0100000: alu_ctr = 3'b101;//SRA
          endcase        
          3'b110: alu_ctr = 3'b010;//OR
          3'b111: alu_ctr = 3'b100;//AND
        endcase
      
      7'b0010011://Iformat(immidiate)
        case(funct3)
          3'b000: alu_ctr = 3'b0;//ADDI
          3'b010: alu_ctr = 3'b001;//SLTI
          3'b011: alu_ctr = 3'b001;//SLTIU
          3'b100: alu_ctr = 3'b011;//XORI
          3'b110: alu_ctr = 3'b010;//ORI
          3'b111: alu_ctr = 3'b100;//ANDI
          3'b001: alu_ctr = 3'b111;//SLLI
          3'b101:
            case(funct7)
              7'b0: alu_ctr = 3'b110;//SRLI
              7'b0100000: alu_ctr = 3'b101;//SRAI
            endcase
        endcase

      7'b0110111,                     //Uformat(lui)
      7'b0010111: alu_ctr = 3'b111;   //Uformat(auipc)
      7'b1100011: alu_ctr = 3'b001; //Bformat
      7'b1101111,                     //jal
      7'b1100111: alu_ctr = 3'b000;   //jalr
      7'b0000011,                     //lw
      7'b0100011: alu_ctr = 3'b000;   //sw



    endcase

  endfunction


//function for reg_write
  function  regwrite;

  input [6:0] opcode;

    case(opcode)
    7'b0110011,                   //Rformat
    7'b0010011,                   //Iformat(immidiate)
    7'b0000011,                   //Iformat(lw)
    7'b1101111,                   //jal
    7'b1100111,                   //jalr
    7'b0110111,                   //lui
    7'b0010111: regwrite = 1;     //auipc
    default: regwrite = 0;
    endcase

  endfunction


//function for alu_src
  function  alusrc;

  input [6:0] opcode;

    case(opcode)
    7'b0100011,                 //Sformat
    7'b0010011,                 //Iformat(immidiate)
    7'b0000011: alusrc = 1;     //Iformat(lw)
    default: alusrc = 0;
    endcase

  endfunction


//function for mem_to_reg
  function  memtoreg;

  input [6:0] opcode;

    case(opcode)
    7'b0000011: memtoreg = 1;   //Iformat(lw)
    7'b0110011: memtoreg = 0;   //Rformat
    default: memtoreg = 0;
    endcase

  endfunction


//function for mem_read
 function  memread;

  input [6:0] opcode;

    case(opcode)
    7'b0000011: memread = 1;   //Iformat(lw)
    default: memread = 0;
    endcase

  endfunction


//function for mem_write
 function  memwrite;

  input [6:0] opcode;

    case(opcode)
    7'b0100011: memwrite = 1;   //Sformat
    default: memwrite = 0;
    endcase

  endfunction


endmodule