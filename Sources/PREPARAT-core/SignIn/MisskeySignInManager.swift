//
//  MisskeySignInManager.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import os

@available(macOS 13.3, *)
struct MisskeySignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    
    @MainActor
    func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let createTokenAPI = MisskeyAPI.createSession(from: url, session: UUID().uuidString, appInfo: appInfo)

        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host()
        components.path += "/miauth/\(UUID().uuidString)"
        components.queryItems = createTokenAPI.parameters?.compactMap{ key, value in
            guard let value = value as? String else { return nil }
            return URLQueryItem(name: key, value: value)
        }
        guard let oauthURL = components.url else {
            return .failure(.urlNotFound)
        }

        if let urlWithToken = try? await webAuthenticationSession.authenticate(
            using: oauthURL,
            callbackURLScheme: appInfo.clientName
        ) {
            return await createOauthData(urlWithToken: urlWithToken, url: url, appInfo: appInfo)
        } else {
            return .failure(.createTokenFailed)
        }
    }
    
    
    private func createOauthData(urlWithToken: URL, url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        guard let components = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false),
              let session = components.queryItems?.first(where: { $0.name == "session" })?.value
        else {
            return .failure(.createTokenFailed)
        }
        
        let service = FediverseAPIService()
        let result = await service.request(api: MisskeyAPI.createToken(from: url, session: session), dtoType: MisskeyOauthTokenDTO.self)
        switch result {
        case .success(let success):
            guard let oAuthData = success as? MisskeyOauthTokenEntity else {
                return .failure(.createTokenFailed)
            }
            return .success(.init(url: url, nodeType: .misskey, token: oAuthData.token, user: oAuthData.user))
        case .failure(let error):
            print(error)
            return .failure(.createTokenFailed)
        }
    }
    
    init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
}
