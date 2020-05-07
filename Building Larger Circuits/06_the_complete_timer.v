module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output [3:0] count,
    output counting,
    output done,
    input ack );
    
    parameter IDLE = 0 , SEQ_0 = 1 , SEQ_1 = 2 , SEQ_2 = 3 ;
    parameter SHIFT = 4 , COUNT = 5 , DONE = 6 ;
    
    reg [2:0] cstate , nstate ;
    
    reg shift_end ;
    reg count_end ;
    reg shift_ena ;
    reg [2:0] shift_cnt ;
    reg [3:0] o_count ;
    reg [9:0] count_cnt ;
    
    assign count = o_count ;
    
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
            COUNT : nstate = count_end ? DONE : COUNT ;
            DONE  : nstate = ack ? IDLE : DONE ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            shift_cnt <= 3'b000 ;
            shift_end <= 0 ;
        end
        else begin
            if(shift_ena) begin
                if(shift_cnt == 2) begin
                    shift_end <= 1 ;
                end
                else begin
                    shift_cnt <= shift_cnt + 1 ;
                end
            end
            else begin
                shift_end <= 0 ;
                shift_cnt <= 3'b000 ;
            end
        end
    end
    
    always @(posedge clk) begin
        if(reset) begin
            o_count <= 4'b000 ;
            count_cnt <= 10'b0 ;
            count_end <= 0 ;
        end
        else begin
            if(shift_ena) begin
                o_count <= {o_count[2:0] , data} ;
            end
            else begin
                if(counting) begin
                    if(count_cnt == 999-1 && o_count == 0) begin
                        count_end <= 1 ;
                    end
                    else begin
                        if(count_cnt == 999) begin
                            count_cnt <= 10'b0 ;
                            o_count <= o_count - 1 ;
                        end
                        else begin
                            count_cnt <= count_cnt + 1 ;
                        end
                    end
                end
                else begin
                    count_cnt <= 10'b0 ;
                    count_end <= 0 ;
                end
            end
        end
    end
   
    
    
    assign shift_ena = (cstate == SHIFT) ;
    assign counting = (cstate == COUNT) ;
    assign done = (cstate == DONE) ;

endmodule
