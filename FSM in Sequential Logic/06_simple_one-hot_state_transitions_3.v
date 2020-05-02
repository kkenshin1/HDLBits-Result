module top_module(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: Derive an equation for each state flip-flop.
    assign next_state[A] = (state[A] & (~in)) | (state[C] & (~in)) ;
    assign next_state[B] = in & (state[A] | state[B] | state[D]) ;
    assign next_state[C] = (state[B] & (~in)) | (state[D] & (~in)) ;
    assign next_state[D] = in & state[C] ;

    // Output logic: 
    assign out = state[D] ;

endmodule