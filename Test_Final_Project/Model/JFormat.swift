//
//  JFormat.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation

struct JFormat {
    // Assumes decode OpCode has already been called
    // I-Format instructions are
    // --------------------------------------
    // | opcode |  address offset           |
    // --------------------------------------
    // | 6 bits |     26 bits               |
    // --------------------------------------
    let opCode : UInt8
    
    let offset : UInt32
    let offsetMask : UInt32 = 0x03FFFFFF
    
    init(_ machineCode : UInt32, _ opCode: UInt8){
        self.opCode = opCode
        
        // Set offset
        offset = machineCode & offsetMask

    }
    
    init(_ assemblyCode : String, _ opCode: UInt8) {
        self.opCode = opCode
        
        let assemblyArray = assemblyCode.components(separatedBy:" ")
        var temp : String? = assemblyArray[0]
        
        print("In encodeJFormat and temp value is \(String(describing: temp))")
        if  temp != nil {
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            
            
            temp = assemblyArray[1]
            temp = temp!.trimmingCharacters(in: .whitespacesAndNewlines)
            temp = temp!.trimmingCharacters(in: .punctuationCharacters)
            offset = UInt32(temp!, radix: 16)!
           
            print("offset is  %06X, offset)")
            
        } else {
            offset = 0xFF
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

