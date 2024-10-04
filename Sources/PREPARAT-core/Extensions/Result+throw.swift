//
//  Result+throw.swift
//
//
//  Created by 김수환 on 8/29/24.
//

import Foundation

extension Result {
    
    func `throw`() throws -> Success {
        switch self {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
