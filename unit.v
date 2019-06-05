`define WORD_SIZE 32
`define WORD_COUNT 4

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
	.cache_ready(cacheReady), 
	.hit_count(hitCount),
	.cache_read(cacheRead),
	.cache_write(cacheWrite), 
	.address(address)
	);

	main_memory m_memory(
	.clk(clk), 
	.rst(rst),
	.read_enable(memRead),
	.address(address), 
	.all_data_out(cacheDataIn), 
	.data_out(memoryDataOut)
	);
endmodule 

