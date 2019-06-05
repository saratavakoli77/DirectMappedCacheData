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
	output [13 : 0] hitCount
	);

	reg [`BLOCK_COUNT-1 : 0] cache [0 : `BLOCK_SIZE-1];
	reg [`BLOCK_SIZE-1 : 0] buffer; // 4*32 bit data0, data1, data2, data3 + 3 bit tag and 1 bit valid = 132
	reg [13 : 0] hitNum = 0;
	reg [14 : 0] oldAddress;
	reg [31 : 0] hitData;

	wire [1 : 0] offset;
	wire [9 : 0] index;
	wire [2 : 0] tag;

	integer i;

	assign offset = address[1 : 0];
	assign index = address[11 : 2];
	assign tag = address[14 : 12];

	always@(posedge clk, posedge rst) begin

		if(rst)begin
			hitNum <= 13'b0;
			for(i = 0; i < 1024; i = i + 1)begin
				cache[index][0] <= 1'b0;
			end
		end
		else begin
			oldAddress <= address;
			if(read) begin
				if(hit) begin
					hitNum <= (oldAddress != address) ? hitNum + 1 : hitNum;
					case(index)
						0: hitData <= cache[index][35 : 4];
						1: hitData <= cache[index][67 : 36];
						2: hitData <= cache[index][99 : 68];
						3: hitData <= cache[index][131 : 100];
					endcase
				end
				else if(~hit) begin
					memRead <= 1'b1;
					cache[index] <= {dataIn, tag, 1'b1}; 
				end
			end
			// else if(read == 0) begin
			// 	hit = 1'b1;
			// 	buffer[0] = 1'b1; //valid = 1
			// 	buffer[4 : 2] = tag;
			// 	buffer[`WORD_COUNT*`WORD_SIZE + 4 : 5] = dataIn;
			// 	cache[index] = buffer;
			// 	dataOut = cache[index][`BLOCK_SIZE-1 : `OFFSET_SIZE + `TAG_SIZE - 1];
			// end
		end
	end
	assign hit = (cache[index][3 : 1] == tag) ? 1'b1 : 1'b0;
	assign dataOut = (hit) ? hitData : 32'bZ;
	assign ready = (hit) ? 1'b1 : 1'b0;
	assign hitCount = hitNum;
endmodule
