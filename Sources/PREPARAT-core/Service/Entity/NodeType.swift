//
//  NodeType.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import os

@available(macOS 13.3, *)
public enum NodeType: String, Codable {
    
    case mastodon
    case misskey
    
    func startSignIn(into url: URL, appInfo: AppInfoType, session: WebAuthenticationSession) async -> Result<OauthData, SignInError> {
        switch self {
        case .mastodon:
            await MastodonSignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: appInfo)
        case .misskey:
            await MisskeySignInManager(webAuthenticationSession: session).signIn(into: url, appInfo: appInfo)
        }
    }
}
