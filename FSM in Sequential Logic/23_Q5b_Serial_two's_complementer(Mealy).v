module top_module (
    input clk,
    input areset,
    input x,
    output z
); 

    parameter A = 0 , B = 1 ;
    reg [1:0] cstate , nstate ;
    
    always @(posedge clk or posedge areset) begin
        if(areset) begin
            cstate <= A ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            A : nstate = x ? B : A ;
            B : nstate = B ;
        endcase
    end
     
    assign z = (cstate == A) ? x : ~x ;
    
    
endmodule