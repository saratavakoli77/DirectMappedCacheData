module main_memory(input clk, rst, input [14:0] address, input [127:0] data_out);
    reg [127:0] m_memory [0:32000];

    reg [14:0] intialAddress;
    integer i;
    integer q;


    always@(posedge clk, posedge rst)
    begin
        intialAddress = {address[14:2],{2'b00}};
        q=31;
        if (address >= 0 and address < 32000) begin
            for(i=0;i<4;i=i+1) begin
                data_out[32*i + 31 : 32*i] = m_memory[intialAddress];
                // $display("%b\n",data_out[q-:32]);
                q = q+32;        
                intialAddress = intialAddress+1;
                
            end
            // $display("\n");
        end
    end
endmodule