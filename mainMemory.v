module main_memory(input clk, rst, input read_enable, input [14:0] address, output reg [127:0] all_data_out, output [31:0] data_out);
    reg [31:0] m_memory [0:32767];

    reg [14:0] initialize_address;
    integer i;
    integer q;
    integer j;

    always@(posedge clk, posedge rst) begin
        initialize_address = {address[14:2],{2'b00}};
        q=31;
        if(rst)begin
            for(j = 1024; j < 8193; j=j+1) begin
                m_memory[j] = 32'd1; 
            end
        end
        else if (address >= 0 && address < 32767) begin
            for(i=0;i<4;i=i+1) begin
                if (i == 0) begin
                	all_data_out[31 : 0] = m_memory[initialize_address];
                end
                else if (i == 1) begin
                	all_data_out[63 : 32] = m_memory[initialize_address];
                end
                else if (i == 2) begin
                	all_data_out[95 : 64] = m_memory[initialize_address];
                end
                else if (i == 3) begin
                	all_data_out[127 : 96] = m_memory[initialize_address];
                end
                q = q+32;        
                initialize_address = initialize_address+1;
            end
        end
    end
    assign data_out = (read_enable && address >= 0 && address < 32768) ? m_memory[address] : 32'bZ;
endmodule

