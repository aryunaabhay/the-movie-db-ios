//
//  TVShowsApiService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

class TVShowsApiService: ApiService<TV> {
    override func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = dictionary["vote_average"] ?? 0.0
            modifiedDictionary["posterPath"] = (dictionary["poster_path"] as? String)?.removingPercentEncoding ?? ""
            modifiedDictionary["title"] = dictionary["name"] ?? ""
        }
        return modifiedDictionary
    }
}
