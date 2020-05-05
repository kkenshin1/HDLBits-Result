module top_module (
    input clk,
    input resetn,    // active-low synchronous reset
    input [3:1] r,   // request
    output [3:1] g   // grant
); 
    
    parameter A = 0 , B = 1 , C = 2 , D = 3 ;
    reg [1:0] cstate , nstate ;
    
    always @(posedge clk) begin
        if(!resetn) begin
            cstate <= A ;
        end
        else begin
            cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case (cstate) 
            A : begin
                casex(r)
                    3'bxx1 : nstate = B ;
                    3'bx10 : nstate = C ;
                    3'b100 : nstate = D ;
                    default : nstate = A ;
                endcase
            end
            B : nstate = r[1] ? B : A ;
            C : nstate = r[2] ? C : A ;
            D : nstate = r[3] ? D : A ;
        endcase
    end

    assign g = {cstate == D , cstate == C ,cstate == B} ;
    
endmodule
