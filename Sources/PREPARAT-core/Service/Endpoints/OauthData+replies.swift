//
//  OauthData+replies.swift
//  PREPARAT-core
//
//  Created by 김수환 on 10/9/24.
//

import Foundation

@available(macOS 13.3, *)
public extension OauthData {
    
    func replies(for id: String) async -> [PRCActivityData] {
        switch nodeType {
        case .mastodon:
            do {
                guard let data = try await FediverseAPIService().request(api: MastodonAPI.context(from: url, token: token, id: id), dtoType: [String: [MastodonActivityDataDTO]].self).throw(),
                      let response = data as? [PRCActivityData] else {
                    return []
                }
                return response
            } catch (let error) {
                print(error)
                let data = await FediverseAPIService().request(api: MastodonAPI.context(from: url, token: token, id: id))
                print(String(data: data ?? Data(), encoding: .utf8))
                return []
            }
        case .misskey:
            guard let data = try? await FediverseAPIService().request(api: MisskeyAPI.replies(from: url, token: token, noteId: id), dtoType: [MisskeyActivityDataDTO].self).throw(),
                  let response = data as? [PRCActivityData] else {
                return []
            }
            return response
        }
    }
}


extension [String: [MastodonActivityDataDTO]]: DTOType {

    public typealias EntityType = [PRCActivityData]

    public func toEntity() -> [PRCActivityData] {
        var result = [PRCActivityData]()
        if let ancestors = self["ancestors"]?.toEntity() as? [PRCActivityData] {
            result.append(contentsOf: ancestors)
        }
        if let descendants = self["descendants"]?.toEntity() as? [PRCActivityData] {
            result.append(contentsOf: descendants)
        }
        return result
    }
}
