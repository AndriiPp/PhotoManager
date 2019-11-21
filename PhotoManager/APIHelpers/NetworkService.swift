//
//  NetworkService.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/20/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import Foundation

protocol Networking {
    func request(request : URLRequest, completion: @escaping (Data?, Error?) -> Void)
}

class NetworkService: Networking {
    func request(request : URLRequest, completion: @escaping (Data?, Error?) -> Void) {
        
        let task = createDataTask(from: request, completion: completion)
        task.resume()
    }
    
    private func createDataTask(from requst: URLRequest, completion: @escaping (Data?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: requst, completionHandler: { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        })
    }
}

