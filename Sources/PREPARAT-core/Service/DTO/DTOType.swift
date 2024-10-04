//
//  DTOType.swift
//  
//
//  Created by 김수환 on 4/7/24.
//

import SwiftUI

public protocol DTOType: Decodable {
    associatedtype EntityType: Codable
    func toEntity() -> EntityType
}

extension Array: DTOType where Element: DTOType {
    
    public func toEntity() -> some EntityType {
        compactMap { $0.toEntity() }
    }
}
