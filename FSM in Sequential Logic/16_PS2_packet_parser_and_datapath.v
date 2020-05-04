module top_module(
    input clk,
    input [7:0] in,
    input reset,    // Synchronous reset
    output [23:0] out_bytes,
    output done); //

    // FSM from fsm_ps2
    parameter BYTE1 = 0 , BYTE2 = 1 , BYTE3 = 2 , DONE = 3 ;
    reg[1:0] cstate , nstate ;
    reg[23:0] o_bytes ;
    reg[7:0] r_bytes ;
    assign out_bytes = o_bytes ;

    always @(posedge clk) begin
        if(reset) begin
            cstate <= BYTE1 ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate) 
            BYTE1 : nstate = in[3] ? BYTE2 : BYTE1 ;
            BYTE2 : nstate = BYTE3 ;
            BYTE3 : nstate = DONE ;
            DONE  : nstate = in[3] ? BYTE2 : BYTE1 ;
        endcase
    end
   	
    always @(*) begin
        case(cstate)
            BYTE1 : r_bytes = in ;
            BYTE2 : begin
                o_bytes[23:16] = r_bytes[7:0] ;
                o_bytes[15: 8] = in[7:0] ;
            end
            BYTE3 : o_bytes[7:0] = in[7:0] ;
            DONE : begin
                o_bytes = o_bytes ;
                r_bytes = in ;
            end
        endcase
    end

    
    assign done = (cstate == DONE) ;
          

    // New: Datapath to store incoming bytes.

endmodule