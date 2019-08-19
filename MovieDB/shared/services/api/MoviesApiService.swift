//
//  MoviesApiService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

class MoviesApiService: ApiService<Movie> {

    override func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("release_date") {
            let releaseDate = (dictionary["release_date"] as? String)?.toDate(withFormat: "yyyy-MM-dd")
            modifiedDictionary["releaseDate"] = releaseDate
        }
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = dictionary["vote_average"]
            modifiedDictionary["posterPath"] = dictionary["poster_path"]
        }
        return modifiedDictionary
    }
}
