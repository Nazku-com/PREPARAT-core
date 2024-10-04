//
//  File.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

@available(macOS 13.3, *)
public extension OauthData {
    
    func timeline(type: TimelineType) async -> [PRCActivityData] {
        switch nodeType {
        case .mastodon:
            guard let data = try? await FediverseAPIService().request(api: MastodonAPI.timeline(from: url, token: token, of: type), dtoType: [MastodonActivityDataDTO].self).throw(),
                  let response = data as? [PRCActivityData] else {
                return []
            }
            return response
        case .misskey:
            do {
                guard let data = try await FediverseAPIService().request(api: MisskeyAPI.timeline(from: url, token: token, of: type), dtoType: [MisskeyActivityDataDTO].self).throw(),
                      let response = data as? [PRCActivityData] else {
                    return []
                }
                return response
            } catch(let error) {
                print(error)
                return []
            }
        }
    }
    
    func singleContent(id: String) async -> PRCActivityData? {
        switch nodeType {
        case .mastodon:
            let newNoteStatusData = try? await FediverseAPIService().request(api: MastodonAPI.status(from: url, token: token, id: id), dtoType: MastodonActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        case .misskey:
            let newNoteStatusData = try? await FediverseAPIService().request(api: MisskeyAPI.singleNote(from: url, token: token, noteId: id), dtoType: MisskeyActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        }
    }
    
    func like(id: String, reaction: String? = nil) async -> PRCActivityData? {
        switch nodeType {
        case .mastodon:
            let newNoteStatusData = try? await FediverseAPIService().request(api: MastodonAPI.setFavorite(from: url, token: token, id: id), dtoType: MastodonActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        case .misskey:
            guard let reaction else {
                return nil
            }
            await FediverseAPIService().request(api: MisskeyAPI.createReaction(from: url, token: token, noteId: id, reaction: reaction))
            let newNoteStatusData = try? await FediverseAPIService().request(api: MisskeyAPI.singleNote(from: url, token: token, noteId: id), dtoType: MisskeyActivityDataDTO.self).throw()
            return newNoteStatusData as? PRCActivityData
        }
    }
    
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
    
    func userDetails(handle: String) async -> PRCActivityAccountData? {
        switch nodeType {
        case .mastodon:
            let result = try? await FediverseAPIService().request(api: MastodonAPI.lookup(from: url, token: token, handle: handle), dtoType: MastodonActivityDataAccountDTO.self).throw()
            return result as? PRCActivityAccountData
        case .misskey:
            // use as username
            var username: String
            var host: String?
            var builder = handle
            if builder.hasPrefix("@") {
                builder.removeFirst()
            }
            if builder.contains("@") {
                let comps = builder.components(separatedBy: "@")
                assert(comps.count == 2)
                username = comps.first ?? ""
                host = comps.last
            } else {
                username = builder
            }
            let result = try? await FediverseAPIService().request(api: MisskeyAPI.userShow(from: url, token: token, userName: username, host: host), dtoType: MisskeyActivityDataAccountDTO.self).throw()
            return result as? PRCActivityAccountData
        }
    }
}
