module uart_tx(
    input clk,rst_n,
    input [1:0] parity_type,
    input [1:0] baud_rate,
    input [7:0] data_in,
    input wr_en,

    output reg bd_clk_out,
    output reg active,
    output reg tx,
    output fifo_full,
    output fifo_emp
);


wire [7:0] fifo2piso;
wire bd_clk_temp;
wire parity_temp;
wire fifo_empty;
wire fifo_rd_en;


baud_gen bd_gen(
    .clk(clk),
    .rst_n(rst_n),
    .baud_rate(baud_rate),
    .bd_clk(bd_clk_temp)
);
assign bd_clk_out = bd_clk_temp;

assign fifo_emp = fifo_empty;

parity_in parity_uut(
    .rst_n(rst_n),
    .parity_type(parity_type),
    .data_in(fifo2piso),
    .parity(parity_temp)
);

fifo_sync #(.WIDTH(8),.ADDR(4),.DEPTH(16))  tx_fifo(

    .clk(clk),
    .rst_n(rst_n),
    .data_in(data_in),
    .wr_en(wr_en),
    .rd_en(fifo_rd_en),
    .data_out(fifo2piso),
    .full(fifo_full),
    .empty(fifo_empty)

);


piso piso_uut(
    .clk(clk),
    .bd_clk(bd_clk_temp),
    .rst_n(rst_n),
    .fifo_empty(fifo_empty),
    .data_in(fifo2piso),
    .parity(parity_temp),
    .tx(tx),
    .active(active),
    .fifo_rd_en(fifo_rd_en)
);






endmodule