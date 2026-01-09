interface alu_if #(parameter DIM = 32);
    logic add, subtract, multiply, divide;
    logic signed [DIM-1:0] d1, d2;
    logic signed [DIM-1:0] q;
endinterface