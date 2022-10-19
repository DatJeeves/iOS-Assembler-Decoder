//
//  RegTable.swift
//  Test_Final_Project
//
//  Created by cpsc on 12/13/20.
//

import Foundation

struct RegTable {
    
    // o and funct = 9 is a Jump
    var regTable: [UInt8 : String] = [ 0: "$0",  1: "$at (Reserved)",  2: "$v0", 3: "$v1",
                                       4: "$a0",  5: "$a1",  6: "$a2", 7: "$a3",
                                       8: "$t0",  9: "$t1", 10: "$t2", 11: "$t3", 12: "$t4", 13: "$5",
                                      14: "$t6", 15: "$t7", 16: "$s0", 17: "$s1", 18: "$s2", 19: "$s3",
                                      20: "$s4", 21: "$s5", 22: "$s6", 23: "$s7", 24: "$t8", 25: "$t9",
                                      26: "$k0 (Reserved)", 27: "$k1 (Reserved)", 28: "$gp", 29: "$sp",
                                      30: "$fp", 31: "$ra"
                                    ]
    
    init(){
        // this is where we can set or change the regTable
        var regTable: [UInt8 : String] = [ 0: "$zero",  1: "$at (Reserved)",  2: "$v0", 3: "$v1",
                                           4: "$a0",  5: "$a1",  6: "$a2", 7: "$a3",
                                           8: "$t0",  9: "$t1", 10: "$t2", 11: "$t3", 12: "$t4", 13: "$5",
                                          14: "$t6", 15: "$t7", 16: "$s0", 17: "$s1", 18: "$s2", 19: "$s3",
                                          20: "$s4", 21: "$s5", 22: "$s6", 23: "$s7", 24: "$t8", 25: "$t9",
                                          26: "$k0 (Reserved)", 27: "$k1 (Reserved)", 28: "$gp", 29: "$sp",
                                          30: "$fp", 31: "$ra"
                                        ]
    }
    
    func  lookUpReg (_ regValue : UInt8) -> String{
        return regTable[regValue] ?? "Error"
    }
    
    func findRegValue (_ reg : String) -> UInt8 {
        var regValue : UInt8 = 0xFF
       
        if reg == "" {
            return regValue
        }
        
        var tempString : String
        for key in regTable.keys {
            
            tempString = regTable[key]!
            if tempString == reg {
                regValue = key
                break
            }
        }
        return regValue
    }
}
