//
//  EntityType.swift
//
//
//  Created by 김수환 on 4/7/24.
//

import SwiftUI

public protocol EntityType: Codable {}

extension Array: EntityType where Element: Codable {}
