//
//  Instruction.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/12/20.
//

import Foundation

struct Instruction {
    
    // o and funct = 9 is a Jump
    var OpFormatTable: [UInt8 : String] = [ 0: "C",  2: "J",  3: "J",  4: "I",  5: "I",  6: "I", 7: "I",
                                            8: "I",  9: "I", 10: "I", 11: "I", 12: "I", 13: "I",
                                           15: "I", 16: "R", 32: "I", 35: "I", 36: "I", 37: "I",
                                           40: "I", 41: "I", 43: "I" ]
    
    var functFormatTable: [UInt8 : String] = [ 0x20: "R",  0x21: "R",  0x24: "R",  0x1A: "R",  0x1B: "R",  0x09: "J", 0x08: "J",
                                               0x10: "R",  0x11: "R", 0x12: "R", 0x13: "R", 0x18: "R", 0x19: "R",
                                           0x27: "R", 0x26: "R", 0x25: "R", 0x2A: "R", 0x2B: "R", 0x00: "R",
                                           0x02: "R", 0x03: "R", 0x22: "R", 0x23: "R" ]
    
    var opCode : UInt8
    var mnemonic : String
    var formatType: String!
    var function : UInt8
    
    var machineCode : UInt32
 
    //Set up the masks for bit wise operations
    let opCodeMask : UInt32 = 0xFC000000
    let functionMask : UInt32 = 0x0000003F
    
    init(instruction : UInt32){
        opCode = 0
        mnemonic = "error"
        formatType = "X"
        function = 0xFF
        
        machineCode = instruction
        loadMachineCode(machineCode)
    }
    
    mutating func  loadMachineCode (_ machineCode : UInt32) {
        self.machineCode = machineCode
        decode(machineCode)
    }
    
    mutating func decode(_ machineCode : UInt32) {
       
        decodeOpCode(machineCode)
    }
    
    mutating func decodeOpCode (_ machineCode: UInt32) {
        var temp : UInt32
        
        // Assign the top 6 bits of the machine code to the OpCode
        temp = machineCode & opCodeMask
        temp >>= 26   // Need to shift the bits to the right by 26 to get real value
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        opCode = UInt8(clamping: temp)
        
        formatType = OpFormatTable[opCode]
        // Check if we need to look at the function code to determine format
        if formatType == "C" {
            decodeFunctCode(machineCode)
        }
    }
    
    mutating func decodeFunctCode (_ machineCode: UInt32) {
        var temp : UInt32
        
        // Assign the top 6 bits of the machine code to the OpCode
        temp = machineCode & functionMask
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        function = UInt8(clamping: temp)
        
        formatType = functFormatTable[function]
    }
    
    
    func showBinary (_ value: UInt32, noOfBits: UInt8) -> String {
        var binary = ""
        var n = value
        var i = 0
        
        while i < noOfBits {
            
            switch ( n%2 ) {
            case 0:
                binary = "0" + binary
                break
            case 1:
                binary = "1" + binary
                break
            default:
                binary = "X" + binary
                break;
            }
            
            n /= 2
            
            i += 1
        }
        return binary
    }
}
