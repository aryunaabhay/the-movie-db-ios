//
//  MovieService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

class MoviesService: ApiOperationsProtocol {
    typealias Content = Movie
    
    static func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("release_date") {
            let releaseDate = (modifiedDictionary["release_date"] as? String)?.toDate(withFormat: "yyyy-MM-dd")
            modifiedDictionary["releaseDate"] = releaseDate
        }
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = modifiedDictionary["vote_average"]
            modifiedDictionary["posterPath"] = modifiedDictionary["poster_path"]
        }
        return modifiedDictionary
    }
}
