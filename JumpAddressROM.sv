// Create Date:    2020.08.22
// Module Name:    InstROM
// Project Name:   CSE141L
//
// Engineer: Jake Daly
//
// Description: JumpAddressROM. Assembler (at assemble time) will look at the labels of the branch statements, determine what address they infer, and store as a 4'b address
//

module JumpAddressROM #(parameter A=4, W=10) (
  input       [A-1:0] LocationIn,
  output logic[W-1:0] JumpAddressOut);
	

// another (usually recommended) alternative expression
//   need $readmemh or $readmemb to initialize all of the elements
// declare 2-dimensional array, W bits wide, 2**A words deep
  logic[W-1:0] jump_address_rom[2**A];
  always_comb JumpAddressOut = jump_address_rom[LocationIn];
 
  initial begin		                  // load from external text file
  	$readmemb("/home/jakemdaly/Documents/UCSD/courses/cse141-141l/141L/lab1/basic_processor/MODELSIM/jump_addresses_p1.txt",jump_address_rom);
  end 
  
endmodule
