//
//  Content.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import RealmSwift

class VideoContent: Object {
    @objc dynamic var id: Int64 = 0
    @objc dynamic var overview: String = ""
    @objc dynamic var posterPath: String = ""
    @objc dynamic var popularity: Double = 0.0
    @objc dynamic var voteAverage: Double = 0.0
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

enum ContentCategory: String {
    case topRated = "top_rated", popular, upcoming
    
    var associatedKeyPath: String {
        switch self {
        case .topRated:
            return "voteAverage"
        case .popular:
            return "popularity"
        case .upcoming:
            return "releaseDate"
        }
    }
}
