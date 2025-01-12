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
            guard let data = try? await FediverseAPIService().request(api: MisskeyAPI.timeline(from: url, token: token, of: type), dtoType: [MisskeyActivityDataDTO].self).throw(),
                  let response = data as? [PRCActivityData] else {
                return []
            }
            return response
        }
    }
}
