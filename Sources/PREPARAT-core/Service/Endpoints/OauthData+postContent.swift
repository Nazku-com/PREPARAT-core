//
//  OauthData+postContent.swift
//  PREPARAT-core
//
//  Created by 김수환 on 10/14/24.
//

import Foundation

@available(macOS 13.3, *)
public extension OauthData {
    
    func postContent(content: PRCPostContentData) async {
        switch nodeType {
        case .mastodon:
            return
        case .misskey:
            let result = await FediverseAPIService().request(api: MisskeyAPI.createNote(from: url, token: token, content: content))
            print(String(data: result ?? Data(), encoding: .utf8))
        }
    }
}

public struct PRCPostContentData {
    
    let text: String
    let visibility: String
    let cw: String?
    let replyId: String?
    let renoteId: String?
    
    public init(text: String, visibility: String = "public", cw: String?, replyId: String?, renoteId: String?) {
        self.text = text
        self.visibility = visibility
        self.cw = cw
        self.replyId = replyId
        self.renoteId = renoteId
    }
}
