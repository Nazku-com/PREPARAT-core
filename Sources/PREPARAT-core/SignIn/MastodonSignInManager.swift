//
//  MastodonSignInManager.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import os

@available(macOS 13.3, *)
struct MastodonSignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    
    func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let service = FediverseAPIService()
        
        let registerApp = await service.request(api: MastodonAPI.registerApp(from: url, appInfo: appInfo), dtoType: MastodonAppDTO.self)
        switch registerApp {
        case .success(let success):
            guard let entity = (success as? MastodonAppEntity) else {
                return .failure(.appRegisterFailed)
            }
            return await continueSignIn(into: url, entity: entity, appInfo: appInfo)
        case .failure:
            return .failure(.appRegisterFailed)
        }
    }
    
    @MainActor
    private func continueSignIn(into url: URL, entity: MastodonAppEntity, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        var components = URLComponents()
        components.scheme = url.scheme
        components.host = url.host()
        components.path += "/oauth/authorize"
        components.queryItems = [
            .init(name: "response_type", value: "code"),
            .init(name: "client_id", value: entity.clientId),
            .init(name: "redirect_uri", value: appInfo.scheme),
            .init(name: "scope", value: "read write follow push"),
        ]
        
        guard let oauthURL = components.url else {
            return .failure(.urlNotFound)
        }
        
        if let urlWithToken = try? await webAuthenticationSession.authenticate(
            using: oauthURL,
            callbackURLScheme: appInfo.clientName
        ) {
            return await createOauthData(urlWithToken: urlWithToken, url: url, entity: entity, appInfo: appInfo)
        } else {
            return .failure(.createTokenFailed)
        }
    }
    
    private func createOauthData(urlWithToken: URL, url: URL, entity: MastodonAppEntity, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        guard let components = URLComponents(url: urlWithToken, resolvingAgainstBaseURL: false),
              let code = components.queryItems?.first(where: { $0.name == "code" })?.value
        else {
            return .failure(.createTokenFailed)
        }
        
        let service = FediverseAPIService()
        let result = await service.request(
            api: MastodonAPI.createToken(from: url, code: code, clientId: entity.clientId, clientSecret: entity.clientSecret, appInfo: appInfo),
            dtoType: MastodonOauthTokenDTO.self
        )
        
        switch result {
        case .success(let success):
            guard let token = success as? OauthTokenEntity else {
                return .failure(.createTokenFailed)
            }
            let userInfo = await service.request(api: MastodonAPI.checkUserInfo(from: url, token: token), dtoType: MastodonActivityDataAccountDTO.self)
            switch userInfo {
            case .success(let data):
                let userData = data as? PRCActivityAccountData
                return .success(.init(url: url, nodeType: .mastodon, token: token, user: userData))
            case .failure:
                return .success(.init(url: url, nodeType: .mastodon, token: token, user: nil))
            }
            
        case .failure:
            return .failure(.createTokenFailed)
        }
    }
    
    init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
}
