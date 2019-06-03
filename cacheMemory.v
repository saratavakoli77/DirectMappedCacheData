`define BLOCK_SIZE 133 //4 * 32 bit word + 4 bit tag + 1 bit valid = 
`define BLOCK_COUNT 1024 // total of 1024 blocks which makes a cache of 4K, 32 bit words
`define WORD_SIZE 32
`define WORD_COUNT 4


module cacheMemory (input clk, input[14 : 0] address, input[`WORD_COUNT * `WORD_SIZE-1 : 0] dataIn, output reg [`WORD_SIZE-1 : 0] dataOut, output reg hit);
	reg [`BLOCK_COUNT-1 : 0] cache [0 : `BLOCK_SIZE -1];
	reg [`WORD_COUNT*(`WORD_SIZE+4)] buffer;
	reg [1 : 0] offset;
	reg [9 : 0] index;
	reg [2 : 0] tag;

	always@(posedge clk) begin
		index = address[12 : 3];
		tag = address[2 : 0];
		offset = address[14 : 13];

	end
endmodule
