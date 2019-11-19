module cudp_fpga(
    input clk_btn, clk100MHz, rst_btn, go_sw,
    input [3:0] a, b,
    
    output [7:0] q_led_l, q_led_r, r_led_l, r_led_r, LEDOUT,
    output [3:0] LEDSEL, 
    output err, done
);
    
    wire clk, clk_5KHz, rst, DONT_USE;
    wire [3:0] q, r;
    
    cudp calc (
        .dividend(a), .divisor(b), .go(go_sw), .clk(clk), .rst(rst),
        .quotient(q), .remainder(r), .err(err), .done(done) 
    );
    
    clk_gen cgen (
        .clk100MHz(clk100MHz), .rst(rst), 
        .clk_4sec(DONT_USE), .clk_5KHz(clk_5KHz)
    );
    
    button_debouncer c_db (
        .clk(clk_5KHz), .button(clk_btn), .debouncer_button(clk)
    );
    
    button_debouncer r_db (
        .clk(clk_5KHz), .button(rst_btn), .debouncer_button(rst)
    );
    
    bcd_to_7seg QLEDL (.BCD(q / 10), .s(q_led_l));
    bcd_to_7seg QLEDR (.BCD(q % 10), .s(q_led_r));
    
    bcd_to_7seg RLEDL (.BCD(r / 10), .s(r_led_l));
    bcd_to_7seg RLEDR (.BCD(r % 10), .s(r_led_r));
    
    led_mux lm (
        .clk(clk_5KHz), .rst(rst),
        .LED3(q_led_l), .LED2(q_led_1), .LED1(r_led_l), .LED0(r_led_r)
        .LEDOUT(LEDOUT), .LEDSEL(LEDSEL)
    );
endmodule
