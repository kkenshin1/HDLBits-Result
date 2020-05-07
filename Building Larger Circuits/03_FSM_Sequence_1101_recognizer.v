module top_module (
    input clk,
    input reset,      // Synchronous reset
    input data,
    output start_shifting);
    
    parameter IDLE = 3'b000 ;
    parameter S0   = 3'b001 ;
    parameter S1   = 3'b010 ;
    parameter S2   = 3'b011 ;
    parameter S3   = 3'b100 ;
    
    reg [2:0] cstate , nstate ;
    
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
            IDLE : nstate = data ? S0 : IDLE ;
            S0   : nstate = data ? S1 : IDLE ;
            S1   : nstate = data ? S1 : S2   ;
            S2   : nstate = data ? S3 : IDLE ;
            S3   : nstate = S3 ;
        endcase
    end
    
    assign start_shifting = (cstate == S3) ;

endmodule