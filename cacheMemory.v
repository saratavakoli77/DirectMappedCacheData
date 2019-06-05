`define BLOCK_SIZE 132 //4 * 32 bit word + 3 bit tag + 1 bit valid = 
`define BLOCK_COUNT 1024 // total of 1024 blocks which makes a cache of 4K, 32 bit words
`define WORD_SIZE 32
`define WORD_COUNT 4
`define OFFSET_SIZE 2
`define TAG_SIZE 3


module cacheMemory (
	input clk,
	input rst,
	input read,
	input[14 : 0] address,
	input[`WORD_COUNT * `WORD_SIZE-1 : 0] dataIn, 
	output [`WORD_SIZE-1 : 0] dataOut,
	output hit,
	output ready,
	output reg memRead,
	output [13 : 0] hitCount,
	output [2 : 0] chacheTag,
	output cacheValid
	);

	reg [`BLOCK_SIZE-1 : 0] cache [0 : `BLOCK_COUNT-1];
	reg [13 : 0] hitNum = 0;
	reg [14 : 0] oldAddress;
	reg [31 : 0] hitData;
	reg [1023 : 0] validVlues;
	wire [`BLOCK_SIZE-1 : 0] cacheIndex;

	wire [1 : 0] offset;
	wire [9 : 0] index;
	wire [2 : 0] tag;

	integer i;

	assign offset = address[1 : 0];
	assign index = address[11 : 2];
	assign tag = address[14 : 12];

	integer tag_;
	integer offset_;
	integer index_;
	always @(tag)
    	tag_ = tag;
	always @(index)
    	index_ = index;
    always@(offset)
    	offset_ = offset;

	always@(posedge clk, posedge rst) begin

		if(rst)begin
			hitNum <= 13'b0;
			memRead <= 1'b0;
			for(i = 0; i < 1024; i = i + 1)begin
				cache[i] <= 132'd0;
				validVlues[i] <= 1'b1;
			end
		end
		else begin

			oldAddress <= address;
			if(read) begin
				if(hit) begin
					hitNum <= (oldAddress != address) ? hitNum + 1 : hitNum;
					case(offset_)
						0: hitData <= cache[index_][35 : 4];
						1: hitData <= cache[index_][67 : 36];
						2: hitData <= cache[index_][99 : 68];
						3: hitData <= cache[index_][131 : 100];
					endcase
				end
				else if(~hit) begin
					memRead <= 1'b1;
					cache[index_] <= {dataIn, tag, 1'b1}; 
				end
			end
		end
	end
	assign hit = (cache[index_][0] == 1'b1 && cache[index_][3 : 1] == tag) ? 1'b1 : 1'b0;
	assign dataOut = (hit) ? hitData : 32'bZ;
	assign ready = (hit) ? 1'b1 : 1'b0;
	assign hitCount = hitNum;
endmodule
