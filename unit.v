`define BLOCK_SIZE 132 //4 * 32 bit word + 3 bit tag + 1 bit valid = 
`define BLOCK_COUNT 1024 // total of 1024 blocks which makes a cache of 4K, 32 bit words
`define WORD_SIZE 32
`define WORD_COUNT 4
`define OFFSET_SIZE 2
`define TAG_SIZE 3

module unit(
	input clk,
	input rst
	);
	
	wire cacheRead, chacheReady, hit, ready, memRead, cacheWrite, currentCacheValid;
	wire [14 : 0] address;
	wire [`WORD_COUNT * `WORD_SIZE-1 : 0] cacheDataIn;
	wire [`WORD_SIZE-1 : 0] cacheDataOut, memoryDataOut;
	wire [13 : 0] hitCount;
	wire [6 : 0] hitRate;
	wire [2 : 0] currentCacheIndex;

	cacheMemory cacheMemory(
	.clk(clk),
	.rst(rst),
	.read(cacheRead),
	.address(address),
	.dataIn(cacheDataIn), 
	.dataOut(cacheDataOut),
	.hit(hit),
	.ready(cacheReady),
	.memRead(memRead),
	.hitCount(hitCount),
	.chacheTag(currentCacheIndex),
	.cacheValid(currentCacheValid)
	);

	cacheController cache_controller( 
	.clk(clk),
	.rst(rst),
	.cache_ready(chacheReady), 
	.hit_count(hitCount),
	.cache_read(cacheRead),
	.cache_write(cacheWrite), 
	.address(address),
	.hit_rate(hitRate)
	);

<<<<<<< HEAD
	main_memory main_memory(
=======
	main_memory m_memory(
>>>>>>> f1af687162b3ee59908248e76a16937b159bfb04
	.clk(clk), 
	.rst(rst),
	.read_enable(memRead),
	.address(address), 
	.all_data_out(cacheDataIn), 
	.data_out(memoryDataOut)
	);
endmodule 

