// Create Date:    2020.08.22
// Module Name:    ALU
// Project Name:   CSE141L
//
// Engineer: Jake Daly
//
// Description: Accumulator ALU


import definitions::*;			         	// includes package "definitions"
module ALU(
  input        	[7:0] 	InputA,             // data inputs
                     	AccumulatorIn,
  input        	[3:0] 	OP,		         	// ALU opcode, part of microcode
  output logic 	[7:0] 	Out,		        // or:  output reg [7:0] OUT,
  output logic       	Zero                // output = zero flag

    );								    
	 
  op_mne op_mnemonic;			         	// type enum: used for convenient waveform viewing
	
  always_comb begin
    
    Out = AccumulatorIn;                               // No Op = default

    case(OP)
		kSUB : Out = AccumulatorIn - InputA;  	// subtract 
		kADD : Out = AccumulatorIn + InputA; 	// add
		kAND : Out = AccumulatorIn & InputA;	// bitwise AND
		kXOR : Out = AccumulatorIn ^ InputA;	// bitwise XOR
		kRXR : Out = ^(AccumulatorIn[6:0]); 			// redux XOR of lowest 7
		kLSL : Out = AccumulatorIn << InputA;	// logical shift left
		kCMP : Out = (AccumulatorIn - InputA) ? 8'b1 : 8'b0; 	//   AccumulatorIn;       //
		kCLR : Out = 'b0;
    endcase
  
  end

  always_comb							  // assign Zero = !Out;
    case(Out)
      'b0     : Zero = 1'b1;
	  default : Zero = 1'b0;
    endcase

  always_comb
    op_mnemonic = op_mne'(OP);			 // displays operation name in waveform viewer

endmodule