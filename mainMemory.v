module main_memory(input clk, rst, input read_enable, input [14:0] address, output reg [127:0] all_data_out, output [31:0] data_out);
    reg [127:0] m_memory [0:32767];

    reg [14:0] initialize_address;
    integer i;
    integer q;

    always@(posedge clk, posedge rst) begin
        initialize_address = {address[14:2],{2'b00}};
        q=31;
        if (address >= 0 && address < 32767) begin
            for(i=0;i<4;i=i+1) begin
                /*all_data_out[q- : 32*i] = m_memory[initialize_address];
                // $display("%b\n",all_data_out[q-:32]);
                q = q+32;        
                initialize_address = initialize_address+1;*/
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
            // $display("\n");
        end
    end
    assign data_out = (read_enable && address >= 0 && address < 32768) ? m_memory[address] : 32'b0;
endmodule

