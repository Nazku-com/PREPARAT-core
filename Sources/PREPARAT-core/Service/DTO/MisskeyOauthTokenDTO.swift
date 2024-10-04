//
//  MisskeyOauthTokenDTO.swift
//  
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

struct MisskeyOauthTokenDTO: DTOType {
    
    public let token: String
    public let user: MisskeyActivityDataAccountDTO
    
    func toEntity() -> some EntityType {
        MisskeyOauthTokenEntity(
            token: .init(
                accessToken: token,
                createdAt: Date().timeIntervalSince1970
            ),
            user: user.toEntity() as? PRCActivityAccountData
        )
    }
}
