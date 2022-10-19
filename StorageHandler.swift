//
//  StorageHandler.swift
//  ClassConstraints
//
//  Created by Christopher Boyd on 10/14/20.
//

import Foundation

struct StorageHandler {
    static var defaultStorage: UserDefaults = UserDefaults.standard
    
    static let defaultKey = "OpCodeCollection"
    
    static func getStorage() {
        

        if isSet(key: self.defaultKey) {
            let encodedString = UserDefaults.standard.dictionaryRepresentation()[self.defaultKey] as! String
            
            OpCodeTableViewCell.colorCollection = decodeCollection(encodedString: encodedString.data(using: .utf8)!)
        }
    }
    
    static func isSet(key: String) -> Bool {
        return UserDefaults.standard.object(forKey: key) != nil
    }
    
    static func set(value: Color) {
        ColorManager.colorCollection.append(value)
        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func set() {

        defaultStorage.set(encodeCollection(), forKey: self.defaultKey)
    }
    
    static func encodeCollection() -> String{
        //Our JSON Encoder
        let encoder = JSONEncoder()
        
        guard let encoded = try? encoder.encode(ColorManager.colorCollection)
        else{
            return ""
        }
        print(storageCount())
        guard let stringEncoded = String(data: encoded, encoding: .utf8)
        else{
            return ""
        }
        return stringEncoded
    }

    static func decodeCollection( encodedString: Data) -> [Color]{
        let decoder = JSONDecoder()
        guard let decoded = try? decoder.decode([Color].self, from: encodedString)
        else{
            let newColorCollection: [Color] = []
            return newColorCollection
        }
        return decoded
    }
    
    static func storageCount() -> Int {
        return ColorManager.colorCollection.count
        }
}


