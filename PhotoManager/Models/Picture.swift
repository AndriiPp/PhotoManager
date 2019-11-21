//
//  Picture.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/20/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

 import Foundation

struct picturesearch: Codable {
    let total, totalPages: Int?
    let results: [pictureelement]
}
 // MARK: - PictureElement
 struct pictureelement: Codable {
     let id: String?
     let width, height: Int?
     let urls: urlls?
     

 }
 // MARK: - Urls
 struct urlls: Codable {
     let  full, small: String?
 }
 typealias Picture = [pictureelement]

