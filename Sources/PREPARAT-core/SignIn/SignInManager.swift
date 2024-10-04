//
//  SignInManager.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation
import AuthenticationServices
import SwiftUI
import os

@available(macOS 13.3, *)
public struct SignInManager {
    private var webAuthenticationSession: WebAuthenticationSession
    
    public func signIn(into url: URL, appInfo: AppInfoType) async -> Result<OauthData, SignInError> {
        let service = FediverseAPIService()
        
        let result = await service.request(api: NodeInfoAPI.nodeInfo(url: url), dtoType: WellKnownNodeInfoDTO.self)
        switch result {
        case .success(let success):
            guard let nodeInfoURL = (success as? WellKnownNodeInfoEntity)?.href else {
                return .failure(.nodeInfoNotFound)
            }
            let result = await service.request(api: NodeInfoAPI.get(url: nodeInfoURL), dtoType: NodeInfoDTO.self)
            
            switch result {
            case .success(let success):
                guard let node = (success as? NodeInfoEntity)?.nodeType else {
                    return .failure(.unsupportedServer)
                }
                return await node.startSignIn(into: url, appInfo: appInfo, session: webAuthenticationSession)
                
            case .failure(let failure):
                print (failure)
                return .failure(.unsupportedServer)
            }
            
        case .failure(let failure):
            print (failure)
            return .failure(.nodeInfoNotFound)
        }
    }
    
    public init(webAuthenticationSession: WebAuthenticationSession) {
        self.webAuthenticationSession = webAuthenticationSession
    }
}
