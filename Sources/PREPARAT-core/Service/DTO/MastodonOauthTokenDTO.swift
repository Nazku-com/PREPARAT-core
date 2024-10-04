//
//  OauthTokenDTO.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

struct MastodonOauthTokenDTO: DTOType {
    
    public let accessToken: String
    public let tokenType: String
    public let scope: String
    public let createdAt: Double
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case scope
        case createdAt = "created_at"
    }
    
    public func toEntity() -> some EntityType {
        OauthTokenEntity(
            accessToken: accessToken,
            createdAt: createdAt
        )
    }
}
