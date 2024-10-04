//
//  SignInError.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public enum SignInError: Error {
    
    case nodeInfoNotFound
    case unsupportedServer
    case appRegisterFailed
    case urlNotFound
    case createTokenFailed
}
