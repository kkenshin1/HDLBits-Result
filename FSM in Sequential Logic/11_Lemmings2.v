module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah ); 
    
    parameter LEFT = 0 , RIGHT = 1 , DOWN_L = 2 , DOWN_R = 3 ;
    reg [1:0] cstate , nstate ;
    
    always @(posedge clk or posedge areset) begin
        if(areset) begin
        	cstate <= LEFT ;
        end
        else begin
        	cstate <= nstate ;
        end
    end
    
    always @(*) begin
        case(cstate)
            LEFT : begin
                if(!ground) nstate = DOWN_L ;
                else if(ground && bump_left) nstate = RIGHT ;
                else nstate = LEFT ;
            end
            RIGHT : begin
                if(!ground) nstate = DOWN_R ;
                else if(ground && bump_right) nstate = LEFT ;
                else nstate = RIGHT ;
            end
            DOWN_L : begin
                if(!ground) nstate = DOWN_L ;
                else nstate = LEFT ;
            end
            DOWN_R : begin
                if(!ground) nstate = DOWN_R ;
                else nstate = RIGHT ;
            end
        endcase
    end

    assign walk_left = (cstate == LEFT) ;
    assign walk_right = (cstate == RIGHT) ;
    assign aaah = (cstate == DOWN_L || cstate == DOWN_R) ;
    

endmodule