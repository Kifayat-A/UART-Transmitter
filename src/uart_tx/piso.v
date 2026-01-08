module piso (
    input clk,
    input        bd_clk,
    input        rst_n,
    input  [7:0] data_in,
    input        parity,
    input        fifo_empty,

    output reg   tx,
    output reg   active,
    output reg fifo_rd_en
);

    localparam IDLE   = 1'b0,
               ACTIVE = 1'b1;

    reg        state;
    reg [3:0]  count;
    reg [10:0] frame;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state  <= IDLE;
            count  <= 0;
            frame  <= 11'b0;
            tx     <= 1'b1;
            active <= 1'b0;
            fifo_rd_en <= 1'b0;
        end else begin
            fifo_rd_en <= 0;
            case (state)
                IDLE: begin
                    tx     <= 1'b1;
                    active <= 1'b0;
                    count  <= 0;
                    if (!fifo_empty   && !active) begin
                        frame <= {1'b1, parity, data_in, 1'b0};
                        fifo_rd_en <= 1;
                        state <= ACTIVE;
                        active <= 1'b1;
                    end
                end
                ACTIVE: begin
                    if (bd_clk) begin
                        tx     <= frame[0];
                        frame <= frame >> 1;
                        count <= count + 1'b1;


                        if (count == 4'd10) begin
                            state  <= IDLE;
                            active <= 1'b0;   // AFTER stop bit
                        end
                    end
                end
            endcase
        end
    end

    


endmodule
