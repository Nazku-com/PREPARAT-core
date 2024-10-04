//
//  FediverseAPIService.swift
//
//
//  Created by 김수환 on 8/24/24.
//

import Foundation
import Alamofire

public final class FediverseAPIService: FediverseAPIServiceType {
    
    // MARK: - Interface
    
    @discardableResult
    public func request(api: FediverseAPIType) async -> Data? {
        guard api.method == .post else {
            let result = await afSession.request(
                api.route,
                method: api.method,
                parameters: api.parameters,
                headers: api.headers
            ).serializingData().result
            switch result {
            case .success(let success):
                return success
            case .failure(let error):
                print(error)
                return nil
            }
        }
        return await requestWithBody(api: api)
    }
    
    private func requestWithBody(api: FediverseAPIType) async -> Data? {
        await withCheckedContinuation { continuation in
            var request = URLRequest(url: api.route)
            request.httpMethod = api.method.rawValue
            request.headers = api.headers ?? []
            request.httpBody = try? JSONSerialization.data(withJSONObject: api.bodyData ?? [], options: [])
            
            afSession.request(request)
                .responseData(completionHandler: { response in
                    guard let data = response.data else {
                        continuation.resume(returning: nil)
                        return
                    }
                    continuation.resume(returning: data)
                })
        }
    }
    
    public func request<T: DTOType>(api: FediverseAPIType, dtoType: T.Type) async -> Result<EntityType?, APIServiceError> {
        guard let response = await request(api: api) else {
            return .failure(.requestFailed)
        }
        let result = self.handleResponse(dataResponse: response, dtoType: T.self)
        guard let entity = result?.toEntity() as? EntityType else {
            return .failure(.responseParsingFailed)
        }
        return .success(entity)
    }
    
    
    // MARK: - Attribute
    
    private let afSession: Alamofire.Session
    
    
    // MARK: - Initialization
    
    public init(afSession: Alamofire.Session = AF) {
        let configuration = afSession.sessionConfiguration
        configuration.timeoutIntervalForRequest = Constant.timeoutSeconds
        self.afSession = Session(configuration: configuration)
    }
    
    
    // MARK: - Response Handler
    
    private func handleResponse<T: DTOType>(dataResponse: Data, dtoType: T.Type) -> T? {
        do {
            return try JSONDecoder().decode(T.self, from: dataResponse)
        } catch(let error) {
            print(error)
            return nil
        }
        
    }
}


// MARK: - Constant

private extension FediverseAPIService {
    
    enum Constant {
        static let timeoutSeconds = 30.0
    }
}
