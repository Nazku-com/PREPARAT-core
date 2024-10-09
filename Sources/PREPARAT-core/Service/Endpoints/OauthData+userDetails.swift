//
//  OauthData+userDetails.swift
//  PREPARAT-core
//
//  Created by 김수환 on 10/9/24.
//

import Foundation

@available(macOS 13.3, *)
public extension OauthData {
    
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
