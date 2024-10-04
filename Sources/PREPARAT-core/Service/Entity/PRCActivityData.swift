//
//  PRCActivityData.swift
//
//
//  Created by 김수환 on 9/17/24.
//

import Foundation

public struct PRCActivityData: PRCActivityDataType {
    
    public var uuid = UUID()
    public let id: String
    public let createdAt: String
    public let replyToId: String?
    public let sensitive: Bool
    public let reacted: Bool
    public let myReaction: String?
    public let spoilerText: String?
    public let visibility: String?
    public let language: String?
    public let uri: String?
    public let url: String?
    public let repliesCount: Int
    public let reblogCount: Int
    public let reactionCount: Int
    public let text: HTMLString?
    public let reblog: PRCReblogActivityData?
    public let account: PRCActivityAccountData?
    public let mediaAttachments: [ActivityDataMediaAttachmentEntity]
    public let mentions: [String]
    public let tags: [String]
    public let emojis: [String]
//    var misskey: PRCMisskeyActivityData?
//    var mastodon: PRCMastodonActivityData?
}

public struct PRCMisskeyActivityData {
    public let reactionAcceptance: Any
    public let userId: Any
    public let reactionEmojis: Any
    public let localOnly: Any
    public let clippedCount: Any
    public let reactions: [String: Int]
    public let fileIds: Any
}

public struct PRCMastodonActivityData {
    public let reblogged: Any
    public let muted: Any
    public let filtered: Any
    public let poll: Any
    public let bookmarked: Any
    public let card: Any
}

public struct PRCReblogActivityData: PRCActivityDataType {
    
    public var uuid = UUID()
    public let id: String
    public let createdAt: String
    public let replyToId: String?
    public let sensitive: Bool
    public let reacted: Bool
    public let myReaction: String?
    public let spoilerText: String?
    public let visibility: String?
    public let language: String?
    public let uri: String?
    public let url: String?
    public let repliesCount: Int
    public let reblogCount: Int
    public let reactionCount: Int
    public let text: HTMLString?
    public let account: PRCActivityAccountData?
    public let mediaAttachments: [ActivityDataMediaAttachmentEntity]
    public let mentions: [String]
    public let tags: [String]
    public let emojis: [String]
//    var misskey: PRCMisskeyActivityData?
//    var mastodon: PRCMastodonActivityData?
}


public struct ActivityDataMediaAttachmentEntity: EntityType { // 추후 개선 필요
    
    public let id: String
    public let type: String
    public let url: URL?
    public let preview_url: URL?
    public let remote_url: URL?
    public let text_url: String?
    public let meta: ActivityDataMediaAttachmentMetaEntity?
}

public struct ActivityDataMediaAttachmentMetaEntity: EntityType {
    
    public let original: ActivityDataMediaAttachmentMetaDataEntity?
    public let small: ActivityDataMediaAttachmentMetaDataEntity?
    public let description: String?
    public let blurhash: String?
}

public struct ActivityDataMediaAttachmentMetaDataEntity: EntityType {
    
    public let width: Int
    public let height: Int
    public let size: String
    public let aspect: Float
}
