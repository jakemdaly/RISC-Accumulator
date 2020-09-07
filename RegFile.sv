// Description: Register File. Reads are combinational. Writes are clocked.


module RegFile #(parameter W=8, D=4)(		     // W = data path width (leave at 8); D = address pointer width
  input                Clk,
                       WriteEn,
  input        [D-1:0] AddrIn,				       // address pointers
                       // RaddrB,
                       Waddr,
  input        [W-1:0] DataIn,
  output logic [W-1:0] DataOut,			      // showing two different ways to handle DataOutX, for
  output logic [W-1:0] Accumulator,		    // R15
  output logic [W-1:0] R11Out,            // Load register
  output logic [W-1:0] R12Out             // Store register

  );

// W bits wide [W-1:0] and 2**4 registers deep 	 
logic [W-1:0] Registers[2**D];

// combinational reads 
always_comb begin
  DataOut = Registers[AddrIn];	 // 
  Accumulator = Registers[2**D-1];    // can read from addr 0, just like ARM
  R11Out = Registers[11];
  R12Out = Registers[12];
end
// sequential (clocked) writes 
always_ff @ (posedge Clk)
  if (WriteEn)	                             // works just like data_memory writes
    Registers[Waddr] <= DataIn;

endmodule
