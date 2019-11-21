//
//  Downloader.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/21/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit

struct Downloader {
    
    static func image(link: String, withComplection complection: @escaping (UIImage?) -> ()) {
        guard let url = URL(string: link) else {
            DispatchQueue.main.async {
                complection(nil)
            }
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else {
                    DispatchQueue.main.async {
                        complection(nil)
                    }
                    return
            }
            DispatchQueue.main.async {
                complection(image)
            }
            }.resume()
    }
    
    private init() {}
}
