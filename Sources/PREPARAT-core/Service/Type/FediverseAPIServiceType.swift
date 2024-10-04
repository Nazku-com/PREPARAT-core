//
//  FediverseAPIServiceType.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation

public protocol FediverseAPIServiceType {
    
    func request(api: FediverseAPIType) async -> Data?
    func request<T: DTOType>(api: FediverseAPIType, dtoType: T.Type) async -> Result<EntityType?, APIServiceError>
}
