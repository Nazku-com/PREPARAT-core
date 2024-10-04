//
//  MisskeyOauthTokenEntity.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

struct MisskeyOauthTokenEntity: EntityType {
    
    public let token: OauthTokenEntity
    public let user: PRCActivityAccountData?
}
