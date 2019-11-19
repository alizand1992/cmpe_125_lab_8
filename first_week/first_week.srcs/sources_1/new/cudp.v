module cudp(
    input [3:0] dividend, divisor,
    input go, rst, clk,
    
    output [3:0] quotient, remainder,
    output done, err
);
    wire [4:0] status_signal;
    wire [3:0] control_signal;
    
    data_path dp (
        .dividend(dividend), .divisor(divisor), .clk(clk), .control_signal(control_signal),
        .status_signal(status_signal), .quotient(quotient), .remainder(remainder)
    );
    
    control_unit cu (
        .go(go), .rst(rst), .clk(clk), .status_signal(status_signal),
        .done(done), .err(err), .control_signal(control_signal)
    );
endmodule
