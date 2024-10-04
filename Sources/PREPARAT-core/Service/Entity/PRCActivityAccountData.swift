//
//  PRCActivityAccountData.swift
//
//
//  Created by 김수환 on 9/17/24.
//

import Foundation

public struct PRCActivityAccountData: EntityType, Equatable { // 추후 개선
    
    public let id: String
    public let name: String?
    public let username: String?
    public let host: String? // mastodon의 경우 직접 작성 필요 // "haze.social"
    public let handle: String? // misskey의 경우 직접 작성 필요 // "tkgka@haze.social"
    public let locked: Bool? // 미스키는 isLocked 값으로 파악해야 할듯
    public let discoverable: Bool? // 무슨 차인지 좀
    public let isbot: Bool?
    public let isCat: Bool? // 미스키 전용으로 추출 필요
    public let indexable: Bool?
    public let group: Bool?
    public let createdAt: String?
    public let note: String?
    public let url: String?
    public let uri: String?
    public let avatarURL: URL?
    public let avatarStaticURL: URL?
    public let header: String?
    public let header_static: String?
    public let followersCount: Int
    public let followingCount: Int
    public let statusesCount: Int
    public let lastStatusAt: String?
    public let hideCollections: Bool?
}
