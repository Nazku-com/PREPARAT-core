//
//  AppInfoType.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public protocol AppInfoType {
    
    var clientName: String { get }
    var scheme: String { get }
    var weblink: String { get }
}
