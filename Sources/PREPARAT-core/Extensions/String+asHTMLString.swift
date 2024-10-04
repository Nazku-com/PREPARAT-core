//
//  String+asHTMLString.swift
//
//
//  Created by 김수환 on 9/21/24.
//

import Foundation

extension String {
    
    var asHTMLString: HTMLString? {
        let decoder = JSONDecoder()
        let convertedContentString = replacingOccurrences(of: "\"", with: "“")
        let contentHtmlString = "\"\(convertedContentString)\""
        guard var decodedValue = try? decoder.decode(HTMLString.self, from: Data(contentHtmlString.utf8)) else {
            return nil
        }
        decodedValue.asRawText = decodedValue.asRawText.isEmpty ? self.escape : decodedValue.asRawText.escape
        return decodedValue
    }
    
    private var escape: String {
        replacingOccurrences(of: "&amp;", with: "&")
            .replacingOccurrences(of: "&lt;", with: "<")
            .replacingOccurrences(of: "&gt;", with: ">")
            .replacingOccurrences(of: "&quot;", with: "\"")
            .replacingOccurrences(of: "&apos;", with: "'")
            .replacingOccurrences(of: "&#39;", with: "’")
    }
}
