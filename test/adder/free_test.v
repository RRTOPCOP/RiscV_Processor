
module adder(dataA, dataB, dataC)

input [31:0] dataA;
input [31:0] dataB;
output [31:0] dataC;

assign dataC = dataA + dataB;

endmodule