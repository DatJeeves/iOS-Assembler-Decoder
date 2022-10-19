//
//  Assemly.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation


struct Assembly {
    
    // o and funct = 9 is a Jump
    var OpFormatTable: [UInt8 : String] = [ 0: "C",  2: "J",  3: "J",  4: "I",  5: "I",  6: "I", 7: "I",
                                            8: "I",  9: "I", 10: "I", 11: "I", 12: "I", 13: "I",
                                           15: "I", 16: "R", 32: "I", 35: "I", 36: "I", 37: "I",
                                           40: "I", 41: "I", 43: "I" ]
    
    var functFormatTable: [UInt8 : String] = [ 0x20: "R",  0x21: "R",  0x24: "R",  0x1A: "R",  0x1B: "R",  0x09: "J", 0x08: "J",
                                               0x10: "R",  0x11: "R", 0x12: "R", 0x13: "R", 0x18: "R", 0x19: "R",
                                           0x27: "R", 0x26: "R", 0x25: "R", 0x2A: "R", 0x2B: "R", 0x00: "R",
                                           0x02: "R", 0x03: "R", 0x22: "R", 0x23: "R" ]
    
    var opCode : UInt8 = 0
    var mnemonic : String = "error"
    var formatType: String! = "X"
    var function : UInt8 = 0xFF
    var myTable = OpTable()
    var assemblyCode : String
    var rsMnemonic : String = "re"
    var rs : UInt8 = 0xFF
    var rt : UInt8 = 0xFF
    var rd : UInt8 = 0xFF
    var rtMnemonic : String = "re"
    var rdMnemonic : String = "re"
    var imm : UInt16 = 0x0
    
    init(assembly : String){
        
        assemblyCode = assembly
        loadAssemblyCode(assemblyCode)
    }
    
    mutating func  loadAssemblyCode (_ assemblyCode : String) {
        self.assemblyCode = assemblyCode
        encode(assemblyCode)
    }
    
    mutating func encode(_ assemblyCode : String) {
       print("About to decode the assembly")
        encodeOpCodeAndFunct(assemblyCode)
        encodeFormatType(assemblyCode)
    }
    
    mutating func encodeOpCodeAndFunct (_ assemblyCode: String) {
        
        // Get the first word as the Op code and get the numeric value of OpCode and function
        if var temp = assemblyCode.components( separatedBy: " ").first {
            temp = temp.trimmingCharacters(in: .whitespacesAndNewlines)
            print("the value of Temp : " + temp)
            let i = myTable.getOpCodeFunct(temp)
            opCode = i.0!
            function = i.1!
            if opCode != 0xFF {
                mnemonic = temp
            }
            
            if function == 0xFF {
                formatType = OpFormatTable[opCode]
                print ("Your format op table returns \(formatType)")
            } else {
                formatType = functFormatTable[function]
                print ("Your format funct table returns \(formatType)")
            }
            
            print("\(opCode) and the function is \(function)")
            
        }
    }
    
   mutating func encodeFormatType (_ assemblyCode: String) {
        // Assumes encodeOpCodeAndFunct has been called
        
        switch formatType {
        case "I" :
            let myIType = IFormat(assemblyCode, opCode)
            
        case "R" :
            let myRType = IFormat(assemblyCode, opCode)
            
        case "J" :
            let myJType = JFormat(assemblyCode, opCode)
            
        default:
            break
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
