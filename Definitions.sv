//This file defines the parameters used in the alu
// CSE141L
//	Rev. 2020.5.27
// import package into each module that needs it
//   packages very useful for declaring global variables
package definitions;
    
// Instruction map
    const logic [3:0] kLDR = 4'b0000;
    const logic [3:0] kLDM = 4'b0001;
    const logic [3:0] kSTR = 4'b0010;
    const logic [3:0] kSTM = 4'b0011;
    const logic [3:0] kACM = 4'b0100;
    const logic [3:0] kSUB = 4'b0101;
    const logic [3:0] kADD = 4'b0110;
    const logic [3:0] kAND = 4'b0111;
    const logic [3:0] kXOR = 4'b1000;
    const logic [3:0] kRXR = 4'b1001;
    const logic [3:0] kLSL = 4'b1010;
    const logic [3:0] kCMP = 4'b1011;
    const logic [3:0] kBEQ = 4'b1100;
    const logic [3:0] kBNE = 4'b1101;
    const logic [3:0] kCLR = 4'b1110;
    const logic [3:0] kDUN = 4'b1111;
    const logic       kLDA = 1'b0;
    const logic       kSTA = 1'b1;

// enum names will appear in timing diagram
    typedef enum logic[3:0] {
        LDR, LDM, STR, STM, ACM, SUB, ADD, AND, XOR, RXR, LSL, CMP, BEQ, BNE, CLR, DUN } op_mne;

endpackage // definitions
