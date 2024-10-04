//
//  APIServiceError.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public enum APIServiceError: Error {
    
    case requestFailed
    case responseParsingFailed
}
