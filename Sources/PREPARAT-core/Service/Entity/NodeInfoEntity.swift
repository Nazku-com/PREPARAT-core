//
//  NodeSoftwareInfoEntity.swift
//  
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

@available(macOS 13.3, *)
struct NodeInfoEntity: EntityType {
    let version: String
    let nodeType: NodeType?
    let softwareVersion: String
}
