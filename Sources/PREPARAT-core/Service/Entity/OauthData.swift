//
//  OauthData.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

@available(macOS 13.3, *)
public struct OauthData: Equatable, Codable, Identifiable {
    
    public var id = UUID()
    public let url: URL
    public let nodeType: NodeType
    public let token: OauthTokenEntity
    public let user: PRCActivityAccountData?
    
    
    public init(url: URL, nodeType: NodeType, token: OauthTokenEntity, user: PRCActivityAccountData?) {
        self.url = url
        self.nodeType = nodeType
        self.token = token
        self.user = user
    }
}
