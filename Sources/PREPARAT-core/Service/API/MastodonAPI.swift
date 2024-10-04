//
//  MastodonAPI.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation
import Alamofire

@available(macOS 13.3, *)
public enum MastodonAPI {
    case registerApp(from: URL, appInfo: AppInfoType)
    case createToken(from: URL, code: String, clientId: String, clientSecret: String, appInfo: AppInfoType)
    case checkUserInfo(from: URL, token: OauthTokenEntity)
    case timeline(from: URL, token: OauthTokenEntity, of: TimelineType)
    case status(from: URL, token: OauthTokenEntity, id: String)
    case setFavorite(from: URL, token: OauthTokenEntity, id: String)
    case unFavorite(from: URL, token: OauthTokenEntity, id: String)
    case lookup(from: URL, token: OauthTokenEntity, handle: String)
}

@available(macOS 13.3, *)
extension MastodonAPI: FediverseAPIType {
    
    public var baseURL: URL {
        switch self {
        case .registerApp(let url, _), .createToken(let url, _, _, _, _), .checkUserInfo(let url, _), 
                .timeline(let url, _, _), .status(let url, _, _), .setFavorite(let url, _, _),
                .unFavorite(let url, _, _), .lookup(let url, _, _):
            return url
        }
    }
    
    public var path: String? {
        switch self {
        case .registerApp:
            return "/api/v1/apps"
        case .createToken:
            return "/oauth/token"
        case .checkUserInfo:
            return "/api/v1/accounts/verify_credentials"
        case .timeline(_, _, let type):
            return type.path
        case .status(_, _, let id):
            return "/api/v1/statuses/\(id)"
        case .setFavorite(_, _, let id):
            return "/api/v1/statuses/\(id)/favourite"
        case .unFavorite(_, _, let id):
            return "/api/v1/statuses/\(id)/unfavourite"
        case .lookup:
            return "/api/v1/accounts/lookup"
        }
    }
    
    public var method: Alamofire.HTTPMethod {
        switch self {
        case .checkUserInfo, .timeline, .status, .lookup:
            return .get
        case .registerApp, .createToken, .setFavorite, .unFavorite:
            return .post
        }
    }
    
    public var headers: Alamofire.HTTPHeaders? {
        switch self {
        case .registerApp, .createToken:
            return HTTPHeaders([
                "Content-Type": "application/json"
            ])
        case .checkUserInfo(_, let token), .timeline(_, let token, _), 
                .status(_, let token, _), .setFavorite(_, let token, _),
                .unFavorite(_, let token, _), .lookup(_, let token, _):
            return HTTPHeaders([
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token.accessToken)"
            ])
        }
    }
    
    public var bodyData: Alamofire.Parameters? {
        switch self {
        case .registerApp(_, let appInfo):
            return [
                "client_name": appInfo.clientName,
                "redirect_uris": appInfo.scheme,
                "scopes": "read write follow push",
                "website": appInfo.weblink
            ]
        case .createToken(_, let code, let clientId, let clientSecret, let appInfo):
            return [
                "grant_type": "authorization_code",
                "code": code,
                "client_id": clientId,
                "client_secret": clientSecret,
                "redirect_uri": appInfo.scheme,
                "scope": "read write follow push"
            ]
        default:
            return nil
        }
    }
    
    public var parameters: Alamofire.Parameters? {
        switch self {
        case .timeline(_, _, let type):
            return [
                "local": (type == .home || type == .local || type == .hybrid),
                "remote": (type == .hybrid || type == .global)
            ]
        case .lookup(_, _, let handle):
            return [
                "acct": handle
            ]
        default:
            return nil
        }
    }
    
    public var encoding: any Alamofire.ParameterEncoding {
        switch self {
        default:
            return URLEncoding.default
        }
    }
}

private extension TimelineType {
    
    var path: String {
        switch self {
        case .home:
            return "/api/v1/timelines/home"
        case .local:
            return "/api/v1/timelines/public"
        case .hybrid:
            return "/api/v1/timelines/public"
        case .global:
            return "/api/v1/timelines/public"
        }
    }
}
