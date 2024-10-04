//
//  MastodonActivityDataDTO.swift
//
//
//  Created by 김수환 on 9/21/24.
//

import Foundation

struct MastodonActivityDataDTO {
    let id: String
    let created_at: String?
    let in_reply_to_id: String?
    let in_reply_to_account_id: String?
    let sensitive: Bool?
    let favourited: Bool?
    let spoiler_text: String?
    let visibility: String?
    let language: String?
    let uri: String?
    let url: String?
    let replies_count: Int?
    let reblogs_count: Int?
    let favourites_count: Int?
    let edited_at: String?
    let content: String?
    let reblog: MastodonReblogActivityDataDTO?
    let account: MastodonActivityDataAccountDTO?
    let media_attachments: [MastodonActivityDataMediaAttachmentDTO]?
    //    "mentions"
    //    "tags"
    //    "emojis"
}

struct MastodonReblogActivityDataDTO: Decodable {
    let id: String
    let created_at: String?
    let in_reply_to_id: String?
    let in_reply_to_account_id: String?
    let sensitive: Bool?
    let favourited: Bool?
    let spoiler_text: String?
    let visibility: String?
    let language: String?
    let uri: String?
    let url: String?
    let replies_count: Int?
    let reblogs_count: Int?
    let favourites_count: Int?
    let edited_at: String?
    let content: String?
    let account: MastodonActivityDataAccountDTO?
    let media_attachments: [MastodonActivityDataMediaAttachmentDTO]?
    //    "mentions"
    //    "tags"
    //    "emojis"
}

struct MastodonActivityDataAccountDTO: DTOType {
    
    let id: String
    let username: String?
    let acct: String?
    let display_name: String?
    let locked: Bool?
    let bot: Bool?
    let discoverable: Bool?
    let indexable: Bool?
    let group: Bool?
    let created_at: String?
    let note: String?
    let url: String?
    let uri: String?
    let avatar: String?
    let avatar_static: String?
    let header: String?
    let header_static: String?
    let followers_count: Int?
    let following_count: Int?
    let statuses_count: Int?
    let last_status_at: String?
    let hide_collections: Bool?
    
    public func toEntity() -> some EntityType {
        PRCActivityAccountData(
            id: id,
            name: display_name,
            username: username,
            host: nil,
            handle: acct,
            locked: locked,
            discoverable: discoverable,
            isbot: bot,
            isCat: false,
            indexable: indexable,
            group: group,
            createdAt: created_at,
            note: note,
            url: url,
            uri: uri,
            avatarURL: URL(string: avatar ?? ""),
            avatarStaticURL: URL(string: avatar_static ?? ""),
            header: header,
            header_static: header_static,
            followersCount: followers_count ?? 0,
            followingCount: following_count ?? 0,
            statusesCount: statuses_count ?? 0,
            lastStatusAt: last_status_at,
            hideCollections: hide_collections
        )
    }
}

struct MastodonActivityDataMediaAttachmentDTO: DTOType { // 추후 개선 필요
    
    let id: String
    let type: String
    let url: URL?
    let preview_url: URL?
    let remote_url: URL?
    let text_url: String?
    let meta: MastodonActivityDataMediaAttachmentMetaDTO?
    
    func toEntity() -> some EntityType {
        ActivityDataMediaAttachmentEntity(
            id: id,
            type: type,
            url: url,
            preview_url: preview_url,
            remote_url: remote_url,
            text_url: text_url,
            meta: meta?.toEntity() as? ActivityDataMediaAttachmentMetaEntity
        )
    }
}

struct MastodonActivityDataMediaAttachmentMetaDTO: DTOType {
    
    let original: MastodonActivityDataMediaAttachmentMetaDataDTO?
    let small: MastodonActivityDataMediaAttachmentMetaDataDTO?
    let description: String?
    let blurhash: String?
    
    public func toEntity() -> some EntityType {
        ActivityDataMediaAttachmentMetaEntity(
            original: original?.toEntity() as? ActivityDataMediaAttachmentMetaDataEntity,
            small: small?.toEntity() as? ActivityDataMediaAttachmentMetaDataEntity,
            description: description,
            blurhash: blurhash
        )
    }
}

struct MastodonActivityDataMediaAttachmentMetaDataDTO: DTOType {
    
    let width: Int
    let height: Int
    let size: String
    let aspect: Float
    
    public func toEntity() -> some EntityType {
        ActivityDataMediaAttachmentMetaDataEntity(
            width: width,
            height: height,
            size: size,
            aspect: aspect
        )
    }
}


// MARK: - TO Entity

extension MastodonActivityDataDTO: DTOType {
    
    func toEntity() -> some EntityType {
        var reblogData: PRCReblogActivityData? = nil
        if let reblog {
            let mediaAttachments = reblog.media_attachments?.compactMap { attachment in
                attachment.toEntity() as? ActivityDataMediaAttachmentEntity
            }
            reblogData = PRCReblogActivityData(
                id: reblog.id,
                createdAt: reblog.created_at ?? "",
                replyToId: reblog.in_reply_to_id,
                sensitive: reblog.sensitive ?? true,
                reacted: reblog.favourited ?? false,
                myReaction: reblog.favourited == true ? "❤️" : nil,
                spoilerText: reblog.spoiler_text,
                visibility: reblog.visibility,
                language: reblog.language,
                uri: reblog.uri,
                url: reblog.url,
                repliesCount: reblog.replies_count ?? 0,
                reblogCount: reblog.reblogs_count ?? 0,
                reactionCount: reblog.favourites_count ?? 0,
                text: reblog.content?.asHTMLString,
                account: reblog.account?.toEntity() as? PRCActivityAccountData,
                mediaAttachments: mediaAttachments ?? [],
                mentions: [],
                tags: [],
                emojis: []
            )
        }
        let mediaAttachments = media_attachments?.compactMap { attachment in
            attachment.toEntity() as? ActivityDataMediaAttachmentEntity
        }
        return PRCActivityData(
            id: id,
            createdAt: created_at ?? "",
            replyToId: in_reply_to_id,
            sensitive: sensitive ?? true,
            reacted: favourited ?? false,
            myReaction: favourited == true ? "❤️" : nil,
            spoilerText: spoiler_text,
            visibility: visibility,
            language: language,
            uri: uri,
            url: url,
            repliesCount: replies_count ?? 0,
            reblogCount: reblogs_count ?? 0,
            reactionCount: favourites_count ?? 0,
            text: content?.asHTMLString,
            reblog: reblogData,
            account: account?.toEntity() as? PRCActivityAccountData,
            mediaAttachments: mediaAttachments ?? [],
            mentions: [],
            tags: [],
            emojis: []
        )
    }
}
