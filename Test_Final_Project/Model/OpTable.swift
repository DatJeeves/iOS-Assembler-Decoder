//
//  OpTable.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation
struct OpTable {
    
    var OpTable: [String : (String, String)] = ["0020": ("add","Assembly is addi"),
                                                "08FF": ("addi","Assembly is addi"),
                                                "09FF": ("addiu","Assembly is addiu"),
                                                "0021": ("addu","Assembly is addu"),
                                                "0024": ("and","Assembly is and"),
                                                "0CFF": ("andi","Assembly is andi"),
                                                "04FF": ("beq","Assembly is beq"),
                                                "06FF": ("blez","Assembly is blez"),
                                                "05FF": ("bne","Assembly is bneq"),
                                                "07FF": ("bgt","Assembly is bgt"),
                                                "001A": ("div","Assembly is div"),
                                                "001B": ("divu","Assembly is divu"),
                                                "02FF": ("j","Assembly is j"),
                                                "03FF": ("jal","Assembly is jal"),
                                                "0009": ("jalr","Assembly is jalr"),
                                                "0008": ("jr","Assembly is jr"),
                                                "20FF": ("lb","Assembly is lb"),
                                                "24FF": ("lbu","Assembly is lbu"),
                                                "25FF": ("lhu","Assembly is lhu"),
                                                "0FFF": ("lui","Assembly is lui"),
                                                "23FF": ("lw","Assembly is lw"),
                                                "0010": ("mfhi","Assembly is mfhi"),
                                                "0011": ("mthi","Assembly is mthi"),
                                                "0012": ("mflo","Assembly is mflo"),
                                                "0013": ("mtlo","Assembly is mtlo"),
                                                "10FF": ("mfc0","Assembly is mfc0"),
                                                "0018": ("mul","Assembly is mult"),
                                                "0019": ("multu","Assembly is multu"),
                                                "0027": ("nor","Assembly is nor"),
                                                "0026": ("xor","Assembly is xor"),
                                                "0025": ("or","Assembly is or"),
                                                "0DFF": ("ori","Assembly is ori"),
                                                "28FF": ("sb","Assembly is sb"),
                                                "29FF": ("sh","Assembly is sh"),
                                                "002A": ("slt","Assembly is slt"),
                                                "0AFF": ("slti","Assembly is slti"),
                                                "0BFF": ("sltiu","Assembly is sltiu"),
                                                "002B": ("sltu","Assembly is sltu"),
                                                "0000": ("sll","Assembly is sll"),
                                                "0002": ("srl","Assembly is srl"),
                                                "0003": ("sra","Assembly is sra"),
                                                "0022": ("sub","Assembly is sub"),
                                                "0023": ("subu","Assembly is beq"),
                                                "2BFF": ("sw","Assembly is sw")]
    
    init () {
        
    }
    
    func getAssembly (_ op : UInt8, _ funct : UInt8) -> (String,String) {
        
        
        let Index = String(format : "%02X", op) + String(format : "%02X", funct)
        
        let output = OpTable[Index] ?? ("Error", "Error")
        
        return output
    }
    
    func getOpCodeFunct (_ op : String) -> (UInt8?,UInt8?) {
        
        var output : (UInt8?, UInt8?) = (0xFF,0xFF)
        
        for key in OpTable.keys {
            let value = OpTable[key]

            if value?.0 == op {
                let opstr = String(key.prefix(2))
                let funcstr = String(key.suffix(2))
                let opCode = UInt8(opstr, radix: 16)
                let function = UInt8(funcstr, radix: 16)
                
                output = (opCode, function)
                break
            }
        }
        return output
    }
}
