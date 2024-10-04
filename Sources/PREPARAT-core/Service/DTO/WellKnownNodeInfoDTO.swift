//
//  WellKnownNodeInfoURLDTO.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

struct WellKnownNodeInfoDTO: DTOType {
    
    let links: [WellKnownNodeInfoURLDTO]
    
    func toEntity() -> some EntityType {
        WellKnownNodeInfoEntity(rel: URL(string: links.first?.rel ?? ""), href: URL(string: links.first?.href ?? ""))
    }
}

struct WellKnownNodeInfoURLDTO: Codable {
    let rel: String
    let href: String
}
