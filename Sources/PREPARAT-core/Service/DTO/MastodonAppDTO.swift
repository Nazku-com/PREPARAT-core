//
//  MastodonAppDTO.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public struct MastodonAppDTO: DTOType {
    
    let clientId: String
    let clientSecret : String
    
    enum CodingKeys: String, CodingKey {
        case clientId = "client_id"
        case clientSecret = "client_secret"
    }
    
    public func toEntity() -> some EntityType {
        MastodonAppEntity(
            clientId: clientId,
            clientSecret: clientSecret
        )
    }
}
