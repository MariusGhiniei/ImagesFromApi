//
//  Data.swift
//  ImagesFromApi
//
//  Created by Marius Ghiniei on 09.01.2023.
//

import Foundation

struct data: Decodable{
    var albumId: Int
    var id : Int
    var title: String
    var url : String
    var thumbnailUrl: String
}
