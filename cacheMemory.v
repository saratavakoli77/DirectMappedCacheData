`define BLOCK_SIZE 132 //4 * 32 bit word + 3 bit tag + 1 bit valid = 
`define BLOCK_COUNT 1024 // total of 1024 blocks which makes a cache of 4K, 32 bit words
`define WORD_SIZE 32
`define WORD_COUNT 4
`define OFFSET_SIZE 2
`define TAG_SIZE 3


module cacheMemory (input clk, input[14 : 0] address, input read, input[`WORD_COUNT * `WORD_SIZE-1 : 0] dataIn, output reg [`WORD_SIZE-1 : 0] dataOut, output reg hit);
	reg [`BLOCK_COUNT-1 : 0] cache [0 : `BLOCK_SIZE -1];
	reg [`WORD_COUNT*`WORD_SIZE + 4 : 0] buffer; //
	reg [1 : 0] offset;
	reg [9 : 0] index;
	reg [2 : 0] tag;

	always@(posedge clk) begin
		index = address[11 : 2];
		tag = address[14 : 12];
		offset = address[1 : 0];
		if(read)begin
			if(cache[index][0] && cache[index][3 : 1] == tag) begin
				hit = 1'b1;
			end
			else begin
				hit = 1'b0;
				dataOut <= 32'b0;
			end
		end
		else if(read == 0) begin
			hit = 1'b1;
			buffer[0] = 1'b1; //valid = 1
			buffer[4 : 2] = tag;
			buffer[`WORD_COUNT*`WORD_SIZE + 4 : 5] = dataIn;
			cache[index] = buffer;
			dataOut = cache[index][`BLOCK_SIZE-1 : `OFFSET_SIZE + `TAG_SIZE - 1];
		end

	end
endmodule
