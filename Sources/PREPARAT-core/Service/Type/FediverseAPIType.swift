//
//  FediverseAPIType.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation
import Alamofire

public protocol FediverseAPIType {
    
    var baseURL: URL { get }
    var path: String? { get }
    var method: Alamofire.HTTPMethod { get }
    var headers: Alamofire.HTTPHeaders? { get }
    var bodyData: Parameters? { get }
    var parameters: Parameters? { get }
    var route: URL { get }
    var encoding: ParameterEncoding { get }
}


public extension FediverseAPIType {
    
    var route: URL {
        guard let path = path else { return baseURL }
        return baseURL.appendingPathComponent(path)
    }
}

