module top_module(
    input clk,
    input in,
    input reset,    // Synchronous reset
    output [7:0] out_byte,
    output done
); //

    // Use FSM from Fsm_serial
    parameter IDLE  = 5'b00001 ;
    parameter START = 5'b00010 ;
    parameter DATA  = 5'b00100 ;
    parameter WAIT  = 5'b01000 ;
    parameter STOP  = 5'b10000 ;
    
    reg [4:0] cstate ;
    reg [4:0] nstate ;
    reg [3:0] data_cnt ;
    reg [7:0] o_byte ;
    reg data_ena ;
    reg data_end ;
    reg o_done ;
    
    assign data_ena = (cstate == DATA) ;
    assign done = o_done ;
    assign out_byte = o_byte ;
    
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
            DATA  : nstate = data_end ? (in ? STOP : WAIT) : DATA;
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
            if(nstate == STOP) begin
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

endmodule