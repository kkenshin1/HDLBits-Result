module top_module(
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out); //

    parameter A=0, B=1, C=2, D=3;

    // State transition logic: next_state = f(state, in)
    
    assign next_state = in ? ((state == C) ? D : B) : (((state == C) |(state == A)) ? A : C) ;

    // Output logic:  out = f(state) for a Moore state machine
    assign out = (state == D) ;

endmodule