// Create Date:    2017.01.25
// Design Name:
// Module Name:    DataMem
// single address pointer for both read and write
// CSE141L
module data_mem(
  input              Clk,
                     Reset,
                     WriteEn,
  input [7:0]        DataAddress,   // 8-bit-wide pointer to 256-deep memory
                     DataIn,		// 8-bit-wide data path, also
  output logic[7:0]  DataOut);

  logic [7:0] core[256];			// 8x256 two-dimensional array -- the memory itself

  always_comb                    // reads are combinational
    DataOut = core[DataAddress];

/* optional way to plant constants into DataMem at startup
    initial 
      $readmemh("dataram_init.list", core);
*/
  always_ff @ (posedge Clk)		 // writes are sequential
/*( Reset response is needed only for initialization (see inital $readmemh above for another choice)
  if you do not need to preload your data memory with any constants, you may omit the if(Reset) and the else,
  and go straight to if(WriteEn) ...
*/
//     if(Reset) begin
// // you may initialize your memory w/ constants, if you wish
//       for(int i=0;i<256;i++)
// 	    core[i] <= 0;
// 	end
//     else 
  if(WriteEn) 
      core[DataAddress] <= DataIn;

endmodule
