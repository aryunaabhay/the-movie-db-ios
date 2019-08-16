//
//  TVShowsService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

class TVShowsService: ApiOperationsProtocol {
    typealias Content = TV
    
    static func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = modifiedDictionary["vote_average"]
            modifiedDictionary["posterPath"] = modifiedDictionary["poster_path"]
        }
        return modifiedDictionary
    }
}