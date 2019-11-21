//
//  DataFetcherService.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/20/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import Foundation

class DataFetcherService {

    var dataFetcher: DataFetcher

    init(dataFetcher: DataFetcher = NetworkDataFetcher()) {
    self.dataFetcher = dataFetcher
    }
    
    func fetchNewPhotos(completion: @escaping (Picture?) -> Void) {
        let photo = RequestAPI.getPhotos.request
        dataFetcher.fetchGenericJSONData(request: photo, response: completion)
    }
    func fetchSearchPhotos(query: String, completion: @escaping(picturesearch?) -> Void){
        let photo = RequestAPI.searchPhotos(query: query).request
        dataFetcher.fetchGenericJSONData(request: photo, response: completion)
    }
}
