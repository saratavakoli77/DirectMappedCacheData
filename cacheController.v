module cacheController ( input clk, rst, cache_ready, input [13 : 0] hit_count, output reg cache_read, cache_write, output reg [14:0] address);
	reg [13:0] all_attempts;
	integer hit_rate_;
	integer hit_count_;
	integer all_attempts_;
	always@(posedge clk, posedge rst) begin
		if (rst) begin
			address <= 15'd1024;
			all_attempts <= 14'b0;
		end
		else begin
			cache_write <= 1'b0;
			cache_read  <= (all_attempts < 14'd8192) ? 1'b1 : 1'b0;
			if (all_attempts < 14'd8192 && cache_ready) begin	
				address <= address + 15'd1;
				all_attempts <= all_attempts + 14'd1;
			end
		end
	end

	always@(hit_count, all_attempts) begin
		hit_count_ = hit_count;
		all_attempts_ = all_attempts;
		hit_rate_ = (hit_count_ * 100)/all_attempts_;
	end

endmodule