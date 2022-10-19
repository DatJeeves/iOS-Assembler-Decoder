//
//  RFormat.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation

struct RFormat {
    // Assumes decode OpCode has already been called
    // R-Format instructions are
    // -------------------------------------------------------
    // | opcode |  rs    |  rt    | rd    |  shamt  | funct  |
    // -------------------------------------------------------
    // | 6 bits | 5 bits | 5 bits | 5 bits | 5 bits | 6 bits |
    // -------------------------------------------------------
    let opCode : UInt8
    let rs : UInt8
    let rsMnemonic : String
    let rt : UInt8
    let rtMnemonic : String
    let rd : UInt8
    let rdMnemonic : String
    let shamt : UInt8
    let funct : UInt8
    let shamtMask : UInt32 = 0x000007C0
    let rdMask : UInt32 = 0x0000F800
    let rtMask : UInt32 = 0x001F0000
    let rsMask : UInt32 = 0x03E00000
    
    let myRegTable = RegTable()
    
    init(_ machineCode : UInt32, _ opCode: UInt8, _ funct: UInt8){
        self.opCode = opCode
        self.funct = funct

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
        
        // Set rd
        temp = machineCode & rdMask
        temp >>= 11   // Need to shift the bits to the right by 21 to get real value
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        rd = UInt8(temp)
        rdMnemonic = myRegTable.lookUpReg(rd)
        
        // Set shamt
        temp = machineCode & shamtMask
        
        // Utilize the clamping to ensure we do not throw an error if its more than allowed
        shamt = UInt8(clamping: temp)

    }
    
    init(_ assemblyCode : String, _ opCode: UInt8) {
        self.opCode = opCode
        
        let assemblyArray = assemblyCode.components(separatedBy:" ")
        var temp : String? = assemblyArray[0]
        
        print("In encodeRFormat and temp value is \(String(describing: temp))")
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
            rdMnemonic = temp!
            rd = myRegTable.findRegValue(rdMnemonic)
            
            temp = assemblyArray[4]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            shamt = UInt8(temp!, radix: 16 ) ?? 0x1F
                
            temp = assemblyArray[4]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            funct = UInt8(temp!, radix: 16 ) ?? 0x1F
            
            print("shamt is  %04X, shamt)")
            print("The rs of value \(rsMnemonic) is \(rs)")
            print("The rt of value \(rtMnemonic) is \(rt)")
            print("The rd of value \(rdMnemonic) is \(rd)")
        } else {
            rs = 0x01F
            rsMnemonic =  "re"
            rt = 0x01F
            rtMnemonic =  "re"
            rd = 0x01F
            rdMnemonic =  "re"
            shamt = 0x01F
            funct = 0x03F
        }
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
