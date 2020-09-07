// Create Date:    2020.08.22
// Module Name:    InstROM
// Project Name:   CSE141L
//
// Engineer: Jake Daly
//
// Description: Instruction ROM.
//

module InstROM #(parameter A=10, W=9) (
  input       [A-1:0] InstAddress,
  output logic[W-1:0] InstOut);

  logic[W-1:0] inst_rom[2**A];
  always_comb InstOut = inst_rom[InstAddress];
 
  initial begin		                  // load from external text file
  	$readmemb("/home/jakemdaly/Documents/UCSD/courses/cse141-141l/141L/lab1/basic_processor/MODELSIM/machine_code_p1.txt",inst_rom);
  end 
  
endmodule
