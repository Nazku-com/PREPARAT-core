//
//  PRCActivityDataType.swift
//
//
//  Created by 김수환 on 9/17/24.
//

import Foundation

protocol PRCActivityDataType: EntityType {
    
    var id: String { get }
    var createdAt: String { get }
    var replyToId: String? { get }
    var sensitive: Bool { get }
    var reacted: Bool { get }
    var myReaction: String? { get }
    var spoilerText: String? { get }
    var visibility: String? { get }
    var language: String? { get }
    var uri: String? { get }
    var url: String? { get }
    var repliesCount: Int { get }
    var reblogCount: Int { get }
    var reactionCount: Int { get }
    var text: HTMLString? { get }
    var account: PRCActivityAccountData? { get }
    var mediaAttachments: [ActivityDataMediaAttachmentEntity] { get }
    var mentions: [String] { get }
    var tags: [String] { get }
    var emojis: [String] { get }
//    var misskey: PRCMisskeyActivityData? { get }
//    var mastodon: PRCMastodonActivityData? { get }
}
