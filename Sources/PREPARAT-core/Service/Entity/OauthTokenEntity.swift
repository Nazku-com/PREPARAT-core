//
//  OauthTokenEntity.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public struct OauthTokenEntity: EntityType, Hashable, Sendable {
    
    public let accessToken: String
    public let createdAt: Double
}
