module free;

wire [5:0] line;
wire [2:0] line2;

assign line = 6'b000111;
assign line2 = line[2:0];

initial begin 

  $display("%b", line2);
  
end

endmodule