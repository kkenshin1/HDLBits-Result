module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Modify FSM and datapath from Fsm_serialdata
    parameter IDLE  = 6'b000001 ;
    parameter START = 6'b000010 ;
    parameter DATA  = 6'b000100 ;
    parameter CHECK = 6'b001000 ;
    parameter WAIT  = 6'b010000 ;
    parameter STOP  = 6'b100000 ;
    
    reg [5:0] cstate ;
    reg [5:0] nstate ;
    reg [3:0] data_cnt ;
    reg [7:0] o_byte ;
    reg data_ena ;
    reg data_end ;
    reg o_done ;
    reg o_odd ;
    reg parity_ena ;
    
    parity p(.clk(clk) ,
             .reset(reset | parity_ena) ,
             .in(in) ,
             .odd(o_odd)
    );
    
    assign data_ena = (cstate == DATA) ;
    assign done = o_done ;
    assign out_byte = o_byte ;
    assign parity_ena = (nstate != DATA && nstate != CHECK) ;
    
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
            IDLE  : nstate = in ? IDLE : START ;
            START : nstate = DATA ;
            DATA  : nstate = data_end ? CHECK : DATA;
            CHECK : nstate = in ? STOP : WAIT ;
            WAIT  : nstate = in ? IDLE : WAIT ;
            STOP  : nstate = in ? IDLE : START ;
        endcase
    end
    
    always @(posedge clk) begin
        if(reset) begin
            data_cnt <= 4'b0000 ;
            data_end <= 1'b0 ;
        end
        else begin
            if(data_ena) begin
                if(data_cnt == 6) begin
                    data_end <= 1'b1 ;
                end
                else begin
                    data_cnt <= data_cnt + 1'b1 ;
                end
            end
            else begin
                data_cnt <= 4'b0000 ;
                data_end <= 1'b0 ;
            end
        end
    end
    
    always @(posedge clk) begin
        if(reset) begin
            o_done <= 1'b0 ;
        end
        else begin
            if(nstate == STOP && o_odd) begin
                o_done <= 1'b1 ;
            end
            else begin
                o_done <= 1'b0 ;
            end
        end
    end

    always @(posedge clk) begin
        if(reset) begin
            o_byte <= 8'b0 ;
        end
        else begin
            if(nstate == DATA) begin
                o_byte <= {in, o_byte[7:1]} ;
            end
        end
    end
   

    // New: Add parity checking.

endmodule