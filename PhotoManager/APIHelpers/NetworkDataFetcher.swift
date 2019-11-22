//
//  NetworkDataFetcher.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/20/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import Foundation

protocol DataFetcher {
    func fetchGenericJSONData<T: Decodable>(request : URLRequest, response: @escaping (T?) -> Void)
}

class NetworkDataFetcher: DataFetcher {
    var networking: Networking
    init(networking: Networking = NetworkService()) {
        self.networking = networking
    }
    
    func fetchGenericJSONData<T: Decodable>(request : URLRequest, response: @escaping (T?) -> Void) {
        networking.request(request: request) { (data, error) in
            if let error = error {
                print("Error received requesting data: \(error.localizedDescription)")
                response(nil)
            }
            let decoded = self.decodeJSON(type: T.self, from: data)
            response(decoded)
        }
    }
    
    func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        let decoder = JSONDecoder()
        guard let data = from else { return nil }
        do {
            let objects = try decoder.decode(type.self, from: data)
            return objects
        } catch let jsonError {
            print("Failed to decode JSON", jsonError)
            return nil
        }
    }
}
