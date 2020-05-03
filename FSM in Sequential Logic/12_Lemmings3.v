module top_module(
    input clk,
    input areset,    // Freshly brainwashed Lemmings walk left.
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging ); 

    parameter LEFT = 0 , RIGHT = 1 , DOWN_L = 2 , DOWN_R = 3 , DIG_L = 4, DIG_R = 5;
    reg [2:0] cstate , nstate ;
    
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
            LEFT : nstate = ground ? (dig ? DIG_L : (bump_left ? RIGHT : LEFT)) : DOWN_L ; 
            RIGHT : nstate = ground ? (dig ? DIG_R : (bump_right ? LEFT : RIGHT)) : DOWN_R ; 
            DOWN_L : nstate = ground ? LEFT : DOWN_L ;
            DOWN_R : nstate = ground ? RIGHT : DOWN_R ;
            DIG_L : nstate = ground ? DIG_L : DOWN_L ;
            DIG_R : nstate = ground ? DIG_R : DOWN_R ;
        endcase
    end
    
    assign walk_left = (cstate == LEFT) ;
    assign walk_right = (cstate == RIGHT) ;
    assign aaah = (cstate == DOWN_L || cstate == DOWN_R) ;
    assign digging = (cstate == DIG_L || cstate == DIG_R) ;
    
    
endmodule
