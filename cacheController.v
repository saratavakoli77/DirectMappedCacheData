module cpu ( input clk, rst, cache_ready, output reg cache_read, cache_write, output reg [14:0] address);
	reg [13:0] successful_access;
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			address <= 15'd1024;
			successful_access <= 14'b0;
		end
		else begin
			cache_write <= 1'b0;
			cache_read  <= (successful_access < 14'd8192) ? 1'b1 : 1'b0;
			if (successful_access < 14'd8192 && cache_ready) begin	
				address <= address + 15'd1;
				successful_access <= successful_access + 14'd1;
			end
		end
	end
endmodule