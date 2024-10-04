//
//  MisskeyActivityDataDTO.swift
//
//
//  Created by 김수환 on 9/21/24.
//

import Foundation

struct MisskeyActivityDataDTO {
    let id: String
    let createdAt: String?
    let renoteId: String?
    let replyId: String?
    let myReaction: String?
    let cw: String?
    let visibility: String?
    let language: String?
    let uri: String?
    let url: String?
    let repliesCount: Int?
    let renoteCount: Int?
    let reactionCount: Int?
    let edited_at: String?
    let text: String?
    let renote: MisskeyReblogActivityDataDTO?
    let user: MisskeyActivityDataAccountDTO?
    let files: [MisskeyActivityDataMediaAttachmentDTO]?
    //    "mentions"
    //    "tags"
    //    "emojis"
}

struct MisskeyReblogActivityDataDTO: Decodable {
    let id: String
    let createdAt: String?
    let renoteId: String?
    let replyId: String?
    let myReaction: String?
    let cw: String?
    let visibility: String?
    let language: String?
    let uri: String?
    let url: String?
    let repliesCount: Int?
    let renoteCount: Int?
    let reactionCount: Int?
    let edited_at: String?
    let text: String?
    let user: MisskeyActivityDataAccountDTO?
    let files: [MisskeyActivityDataMediaAttachmentDTO]?
    //    "mentions"
    //    "tags"
    //    "emojis"
}

struct MisskeyActivityDataAccountDTO: DTOType { // TODO: -
    let id: String
    let name: String?
    let username: String?
    let host: String?
    let avatarUrl: String?
    let avatarBlurhash: String?
    let isbot: Bool?
    let isCat: Bool?
    let url: String?
    let uri: String?
    let bannerUrl: String?
    let bannerBlurhash: String?
    let description: String?
    let followersCount: Int?
    let followingCount: Int?
    let notesCount: Int?
    let isLocked: Bool?
    
    public func toEntity() -> some EntityType {
        var handle: String? {
            guard let username,
                  let host
            else {
                return nil
            }
            return "\(username)@\(host)"
        }
        return PRCActivityAccountData(
            id: id,
            name: name,
            username: username,
            host: host,
            handle: handle,
            locked: isLocked,
            discoverable: isLocked, // TODO: -
            isbot: isbot,
            isCat: isCat,
            indexable: nil,
            group: nil,
            createdAt: nil,
            note: description,
            url: url,
            uri: uri,
            avatarURL: URL(string: avatarUrl ?? ""),
            avatarStaticURL: URL(string: avatarBlurhash ?? ""),
            header: bannerUrl,
            header_static: bannerBlurhash,
            followersCount: followersCount ?? 0,
            followingCount: followingCount ?? 0,
            statusesCount: 0,
            lastStatusAt: nil,
            hideCollections: nil
        )
    }
}

struct MisskeyActivityDataMediaAttachmentDTO: DTOType { // 추후 개선 필요
    
    let id: String
    let type: String
    let url: URL?
    let preview_url: URL?
    let remote_url: URL?
    let text_url: String?
    let meta: MisskeyActivityDataMediaAttachmentMetaDTO?
    
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

struct MisskeyActivityDataMediaAttachmentMetaDTO: DTOType {
    
    let original: MisskeyActivityDataMediaAttachmentMetaDataDTO?
    let small: MisskeyActivityDataMediaAttachmentMetaDataDTO?
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

struct MisskeyActivityDataMediaAttachmentMetaDataDTO: DTOType {
    
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

extension MisskeyActivityDataDTO: DTOType {
    
    func toEntity() -> some EntityType {
        var reblogData: PRCReblogActivityData? = nil
        if let renote {
            let mediaAttachments = renote.files?.compactMap { attachment in
                attachment.toEntity() as? ActivityDataMediaAttachmentEntity
            }
            reblogData = PRCReblogActivityData(
                id: renote.id,
                createdAt: renote.createdAt ?? "",
                replyToId: renote.replyId,
                sensitive: renote.cw != nil,
                reacted: renote.myReaction != nil,
                myReaction: renote.myReaction,
                spoilerText: renote.cw,
                visibility: renote.visibility,
                language: renote.language,
                uri: renote.uri,
                url: renote.url,
                repliesCount: renote.repliesCount ?? 0,
                reblogCount: renote.renoteCount ?? 0,
                reactionCount: renote.reactionCount ?? 0,
                text: renote.text?.asHTMLString,
                account: renote.user?.toEntity() as? PRCActivityAccountData,
                mediaAttachments: mediaAttachments ?? [],
                mentions: [],
                tags: [],
                emojis: []
            )
        }
        let mediaAttachments = files?.compactMap { attachment in
            attachment.toEntity() as? ActivityDataMediaAttachmentEntity
        }
        return PRCActivityData(
            id: id,
            createdAt: createdAt ?? "",
            replyToId: replyId,
            sensitive: cw != nil,
            reacted: myReaction != nil,
            myReaction: myReaction,
            spoilerText: cw,
            visibility: visibility,
            language: language,
            uri: uri,
            url: url,
            repliesCount: repliesCount ?? 0,
            reblogCount: renoteCount ?? 0,
            reactionCount: reactionCount ?? 0,
            text: text?.asHTMLString,
            reblog: reblogData,
            account: user?.toEntity() as? PRCActivityAccountData,
            mediaAttachments: mediaAttachments ?? [],
            mentions: [],
            tags: [],
            emojis: []
        )
    }
}
