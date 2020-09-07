// Create Date:    2020.08.22
// Module Name:    Ctrl
// Project Name:   CSE141L
//
// Engineer: Jake Daly
//
// Description: Coambinational control block. Inputs from InstrRom, ALU flags. Outputs to Program Counter


import definitions::*;

module Ctrl (
  input[8:0]    Instruction,	     // machine code
  output logic  [2:0]  RegWrSource,  //000 = ALU_out, 001 = MemReadValue, 010 = ACM (R15), 011 = LDM (R11), 100 = STM (R12)
  output logic  //Jump,
                // LoadInst,
                BranchOnEq,
                BranchOnNe,
		            RegWrEn,	         // write to reg_file (common)
		            MemWrEn,	         // write to mem (store only)
                ALUFromReg,
		            Ack		             // "done w/ program"
  );

// jump on right shift that generates a zero
// equiv to simply: assign Jump = Instrucxtion[2:0] == kRSH;
always_comb begin

    // Default cases
    // RegWrSource = 3'b000;
    // BranchOnEq  = 0;
    // BranchOnNe  = 0;
    // RegWrEn     = 0;
    // MemWrEn     = 0;
    // Ack         = 0;
    case (Instruction[8])
      {1'b0} : begin
              case(Instruction[7:4])
                {kLDR} : begin 
                              RegWrSource = 3'b001;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kLDM} : begin 
                              RegWrSource = 3'b011;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kSTR} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 0;
                              MemWrEn     = 1;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kSTM} : begin 
                              RegWrSource = 3'b100;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kACM} : begin 
                              RegWrSource = 3'b010;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kSUB} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end                  
                {kADD} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kAND} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kXOR} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kRXR} : begin  // same control logic as ACM, difference is that case statement in ALU hits non-default value (default==Accumulator==R15)
                              RegWrSource = 3'b010; 
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kLSL} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 0;
                              Ack         = 0;
                            end
                {kCMP} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kBEQ} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 1;
                              BranchOnNe  = 0;
                              RegWrEn     = 0;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kBNE} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 1;
                              RegWrEn     = 0;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kCLR} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 1;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 0;
                            end
                {kDUN} : begin 
                              RegWrSource = 3'b000;
                              BranchOnEq  = 0;
                              BranchOnNe  = 0;
                              RegWrEn     = 0;
                              MemWrEn     = 0;
                              ALUFromReg  = 1;
                              Ack         = 1;
                            end
                endcase
              end
      {1'b1} :  begin

              case(Instruction[7])
                  {kLDA} : begin 
                                RegWrSource = 3'b001;
                                BranchOnEq  = 0;
                                BranchOnNe  = 0;
                                RegWrEn     = 1;
                                MemWrEn     = 0;
                                ALUFromReg  = 1;
                                Ack         = 0;
                              end
                  {kSTA} : begin 
                                RegWrSource = 3'b000;
                                BranchOnEq  = 0;
                                BranchOnNe  = 0;
                                RegWrEn     = 0;
                                MemWrEn     = 1;
                                ALUFromReg  = 1;
                                Ack         = 0;
                              end
              endcase

                end
    endcase

end

endmodule

