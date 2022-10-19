//
//  IFormat.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation

struct IFormat {
    // Assumes decode OpCode has already been called
    // I-Format instructions are
    // --------------------------------------
    // | opcode |  rs    |  rt    | IMM     |
    // --------------------------------------
    // | 6 bits | 5 bits | 5 bits | 16 bits |
    // --------------------------------------
    var opCode : UInt8
    var opCodeMnemonic : String = "ERR"
    var rs : UInt8 = 0xFF
    var rsMnemonic : String = "ERR"
    var rt : UInt8 = 0xFF
    var rtMnemonic : String = "ERR"
    var IMM : UInt16 = 0xFFFF
    let immMask : UInt32 = 0x0000FFFF
    let rtMask : UInt32 = 0x001F0000
    let rsMask : UInt32 = 0x03E00000
    let myRegTable = RegTable()
    
    init(_ machineCode : UInt32, _ opCode: UInt8){
        self.opCode = opCode
        
        var temp : UInt32
        

        // Set rs
        temp = machineCode & rsMask
        temp >>= 21   // Need to shift the bits to the right by 21 to get real value

        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        rs = UInt8(temp)
        rsMnemonic = myRegTable.lookUpReg(rs)
        
        // Set rt
        temp = machineCode & rtMask
        temp >>= 16   // Need to shift the bits to the right by 21 to get real value
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        rt = UInt8(temp)
        rtMnemonic = myRegTable.lookUpReg(rt)
        
        if (OpTable[opCode] == "beq") || (OpTable[opCode] == "bne")
        {
            // we have to reverse the rs and rt
            
        }
        // Set IMM
        temp = machineCode & immMask
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        IMM = UInt16(clamping: temp)

    }
    
    init(_ assemblyCode : String, _ opCode: UInt8) {
        self.opCode = opCode
        
        let assemblyArray = assemblyCode.components(separatedBy:" ")
        var temp : String? = assemblyArray[0]
        
        print("In encodeIFormat and temp value is \(String(describing: temp))")
        if  temp != nil {
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            
            
            temp = assemblyArray[1]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            rsMnemonic = temp!
            rs = myRegTable.findRegValue(rsMnemonic)
            
            temp = assemblyArray[2]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            rtMnemonic = temp!
            rt = myRegTable.findRegValue(rtMnemonic)
            
            temp = assemblyArray[3]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            IMM = UInt16(temp!, radix: 16 ) ?? 0xFFFF
                
           
            print("IMM is  %04X, imm)")
            print("The rs of value \(rsMnemonic) is \(rs)")
            print("The rt of value \(rtMnemonic) is \(rt)")
            
        }
        
    }
    
    mutating func decodeMachineCode (_ machineCode : UInt32, _ opCode: UInt8){
        self.opCode = opCode
        
        var temp : UInt32
        
        let myRegTable = RegTable()
        
        // Set rs
        temp = machineCode & rsMask
        temp >>= 21   // Need to shift the bits to the right by 21 to get real value
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        rs = UInt8(temp)
        rsMnemonic = myRegTable.lookUpReg(rs)
        
        // Set rt
        temp = machineCode & rtMask
        temp >>= 16   // Need to shift the bits to the right by 21 to get real value
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        rt = UInt8(temp)
        rtMnemonic = myRegTable.lookUpReg(rt)
        
        // Set IMM
        temp = machineCode & immMask
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        IMM = UInt16(clamping: temp)
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
