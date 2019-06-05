module testBench ();
	reg clk = 1'b0, rst;
	unit directMappedCacheData(
	.clk(clk),
	.rst(rst)
	);

	always #50 clk = ~clk;
	initial
	begin
		rst = 0;
		#30;
		rst = 1;
		#30;
		rst = 0;
	end

endmodule
