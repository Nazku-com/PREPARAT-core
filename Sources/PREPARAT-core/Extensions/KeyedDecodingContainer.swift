//
//  KeyedDecodingContainer.swift
//
//
//  Created by 김수환 on 8/30/24.
//

import Foundation

extension KeyedDecodingContainer {
    
    enum ParsingError:Error {
        case noKeyFound
    }
    
    func decode<T>(_ type:T.Type, forKeys keys:[K]) throws -> T where T:Decodable {
        for key in keys {
            if let val = try? self.decode(type, forKey: key) {
                return val
            }
        }
        throw ParsingError.noKeyFound
    }
}
