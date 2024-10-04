//
//  NodeInfoDTO.swift
//  
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

@available(macOS 13.3, *)
struct NodeInfoDTO: DTOType {
    let version: String
    let software: NodeSoftwareInfoDTO
    
    func toEntity() -> some EntityType {
        NodeInfoEntity(
            version: version,
            nodeType: .init(rawValue: software.name.lowercased()),
            softwareVersion: software.version
        )
    }
}

struct NodeSoftwareInfoDTO: Codable {
    let name: String
    let version: String
}
