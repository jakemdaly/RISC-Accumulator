// Revision Date:    2020.08.05
// Design Name:    BasicProcessor
// Module Name:    TopLevel 
// CSE141L
// partial only										   
module top_level(		   // you will have the same 3 ports
    input        init,	   // init/reset, active high
			     req,    // start next program
	             clk,	   // clock -- posedge used inside design
    output logic ack	   // done flag from DUT
    );

	wire [ 9:0] PgmCtr,        // program counter
				JumpAddrOut;
	wire [ 8:0] Instruction;   // our 9-bit opcode
	wire [ 7:0] ReadA, ReadB, R11Out, R12Out;  // reg_file outputs
	wire [ 7:0] InA, InB, 	   // ALU operand inputs
	            ALU_out;       // ALU result
	wire [ 7:0] //RegWrVal, // data in to reg file
	            InputALU,
	            MemWrVal, // data in to data_memory
		   	    MemReadVal,  // data out from data_memory
		   	    MemWrAddr;
	// wire [ 7:0] JumpAddrOut    // output of JumpAddressROM to input of InstFetch
	logic [7:0] RegWrVal;
	logic [ 3:0] RegWrAddr;
	wire [ 2:0] RegWrSource;
	wire        MemWrEn,	   // data_memory write enable
				// LoadInst, 	   // use ALU_out or MemReadValue as input to RF
				RegWrEn,	   // reg_file write enable
				Zero,		   // ALU output = 0 flag
	            ALUFromReg;	       // is the ALU input from the reg file or a constant
	            // BranchEn;	   // to program counter: branch enable
	logic[15:0] CycleCt;	   // standalone; NOT PC!

	// Fetch stage = Program Counter + Instruction ROM
	InstFetch IF1 (		        // this is the program counter module
		.Reset        (init   ) ,  // reset to 0
		.Start        (req   ) ,  // start program
		.Clk          (clk     ) ,  
		.BranchOnEq   (BranchOnEq ) ,  
		.BranchOnNe   (BranchOnNe) ,
		.ALU_Zflag	  (Zero    ) ,  // 
		.Target       (JumpAddrOut) ,  // "where to?" or "how far?" during a jump or branch
		.ProgCtr      (PgmCtr  )	// program count = index to instruction memory
	);					  

	// instruction ROM -- holds the machine code pointed to by program counter
	InstROM #(.W(9)) IR1(
		.InstAddress  (PgmCtr     ) ,
		.InstOut      (Instruction)
	);

	// Jump Address ROM -- holds the machine code pointed to by program counter
	JumpAddressROM JAR1(
		.LocationIn  (Instruction[3:0]) , 
		.JumpAddressOut      (JumpAddrOut)
	);

	// Decode stage = Control Decoder + Reg_file
	// Control decoder
	Ctrl Ctrl1 (
		.Instruction  (Instruction) ,  // from instr_ROM
		// .Jump         (Jump       ) ,  // to PC to handle jump/branch instructions
		.BranchOnEq   (BranchOnEq ) ,  // to PC
		.BranchOnNe   (BranchOnNe ) ,  // to PC
		.RegWrEn      (RegWrEn    )	,  // register file write enable
		.RegWrSource  (RegWrSource) ,
		.MemWrEn      (MemWrEn ) ,  // data memory write enable
		.ALUFromReg   (ALUFromReg ) ,
		.Ack          (ack        )	   // "done" flag
	);


	always_comb begin
		case(RegWrSource)
			3'b000 : begin // ALU out --> RegFile = always accumulator
				RegWrVal = ALU_out;
				RegWrAddr  = 4'b1111;
			end
			3'b001 : begin // MemReadValue into load register
				RegWrVal = MemReadVal;
				RegWrAddr  = 4'b1011; 
			end
			3'b010 : begin // Accumulator old value will write to Inst[3:0]
				RegWrVal = ALU_out;
				RegWrAddr  = Instruction[3:0];
			end
			3'b011 : begin // LDM: Load register value will get written to Inst[3:0]
				RegWrVal = R11Out;
				RegWrAddr  = Instruction[3:0];
			end
			3'b100 : begin // STM: Store register will get written by Inst[3:0]
				RegWrVal = ReadA;
				RegWrAddr  = 4'b1100; 
			end
			// 3'b101: begin // RXR store wherever Inst[3:0] says
			// 	RegWrVal = ALU_out;
			// 	RegWrAddr  = Instruction[3:0];
			// end
			default begin
				RegWrVal = ALU_out;
				RegWrAddr  = 4'b1111;
			end
		endcase
	end

	// reg file
	RegFile #(.W(8),.D(4)) RF1 (			  // D(4) makes this 16 elements deep
		.Clk    		(clk)  ,
		.WriteEn   		(RegWrEn)    , 
		.AddrIn    		(Instruction[3:0]),        //concatenate with 0 to give us 4 bits
		// .RaddrB    		(Instruction[2:0]), 
		.Waddr     		(RegWrAddr), 	      // mux above
		.DataIn    		(RegWrVal) , 
		.DataOut  		(ReadA        ) , 
		.Accumulator  	(ReadB		 ),
		.R11Out 		(R11Out),
		.R12Out 		(R12Out)
	);

	// assign RegWriteValue = LoadInst? ALU_out : MemReadValue;  // 2:1 switch into reg_file

	assign InputALU = ALUFromReg? ReadA : Instruction[3:0];

    ALU ALU1  (
		  .InputA  (InputALU),
		  .AccumulatorIn  (ReadB), 
		  // .SC_in   ('b1),
		  .OP      (Instruction[7:4]),
		  .Out     (ALU_out),//regWriteValue),
		  .Zero		                              // status flag; may have others, if desired
	  );

    // Depending on instruction format, we'll either specify absolute address or address contained in register A
    assign MemWrAddr = Instruction[8]? {1'b0, Instruction[6:0]} : ReadA;

	data_mem DM(
		.DataAddress  (MemWrAddr)    , 
		.WriteEn      (MemWrEn), 
		.DataIn       (R12Out), 
		.DataOut      (MemReadVal)  , 
		.Clk 		  (clk)    ,
		.Reset		  (init)
	);
	
	/* count number of instructions executed
	      not part of main design, potentially useful
	      This one halts when Ack is high  
	*/
	always_ff @(posedge clk)
	  if (init == 1)	   // if(start)
	  	CycleCt <= 0;
	  else if(ack == 0)   // if(!halt)
	  	CycleCt <= CycleCt+16'b1;

endmodule