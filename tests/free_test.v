module free;

reg [3:0] data;

initial begin 
  data = 4'b0011;

  $display(data);
end

endmodule