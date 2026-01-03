module piso(
    input bd_clk,rst_n,
    input [7:0] data_in,
    input parity,
    output reg tx,
    output reg active
);

reg state;
reg [3:0]count;
reg [10:0] frame;

localparam IDLE = 1'b0,
           ACTIVE = 1'b1;


always @(posedge bd_clk or negedge rst_n ) begin
    if(!rst_n) begin
        state <= 0 ;
        count <= 0 ;
        frame <= 11'h7F;
        tx <= 1; //default state
        active <= 0;
    end 

    else begin
        case(state)
            IDLE: begin
                count <= 0;
                tx <= 1;
                active <= 0;

                frame <= {1'b1,parity,data_in,1'b0} ;
                state <= ACTIVE;

            end

            ACTIVE: begin
                
                if(count == 4'd10)
                    state <= IDLE;
                else
                    count <= count +1 ;

                tx <= frame[0];
                frame <= frame>>1;
                active <= 1;

            end

        endcase
    end
end

endmodule