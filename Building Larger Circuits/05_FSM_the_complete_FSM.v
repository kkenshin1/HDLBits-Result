module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output shift_ena,
    output counting,
    input done_counting,
    output done,
    input ack );
    
    parameter IDLE = 0 , SEQ_0 = 1 , SEQ_1 = 2 , SEQ_2 = 3 ;
    parameter SHIFT = 4 , COUNT = 5 , DONE = 6 ;
    reg [2:0] cstate , nstate ;
    reg shift_end ;
    reg [2:0] cnt ; 
    
    
    always @(posedge clk) begin
        if(reset) begin
            cstate <= IDLE ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            IDLE  : nstate = data ? SEQ_0 : IDLE  ;
            SEQ_0 : nstate = data ? SEQ_1 : IDLE  ;
            SEQ_1 : nstate = data ? SEQ_1 : SEQ_2 ;
            SEQ_2 : nstate = data ? SHIFT : IDLE  ;
            SHIFT : nstate = shift_end ? COUNT : SHIFT ;
            COUNT : nstate = done_counting ? DONE : COUNT ;
            DONE  : nstate = ack ? IDLE : DONE ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            cnt <= 3'b000 ;
            shift_end <= 0 ;
        end
        else begin
            if(shift_ena) begin
                if(cnt == 2) begin
                    shift_end <= 1 ;
                end
                else begin
                    cnt <= cnt + 1 ;
                end
            end
            else begin
                shift_end <= 0 ;
                cnt <= 3'b000 ;
            end
        end
    end
    
    assign shift_ena = (cstate == SHIFT) ;
    assign counting = (cstate == COUNT) ;
    assign done = (cstate == DONE) ;

endmodule