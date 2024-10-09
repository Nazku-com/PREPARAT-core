//
//  OauthData+deleteLike.swift
//  PREPARAT-core
//
//  Created by 김수환 on 10/9/24.
//

import Foundation

@available(macOS 13.3, *)
public extension OauthData {
    
    func deleteLike(id: String) async -> PRCActivityData? {
        switch nodeType {
        case .mastodon:
            let newNoteStatusData = try? await FediverseAPIService().request(api: MastodonAPI.unFavorite(from: url, token: token, id: id), dtoType: MastodonActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        case .misskey:
            await FediverseAPIService().request(api: MisskeyAPI.deleteReaction(from: url, token: token, noteId: id))
            let newNoteStatusData = try? await FediverseAPIService().request(api: MisskeyAPI.singleNote(from: url, token: token, noteId: id), dtoType: MisskeyActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        }
    }
}
