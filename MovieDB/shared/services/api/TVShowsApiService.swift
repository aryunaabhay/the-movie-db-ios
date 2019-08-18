//
//  TVShowsApiService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

class TVShowsApiService: ApiObjectOperations, JSONObjectMapping {
    typealias Content = TV
    var networkingClient: NetworkingClient
    
    required init(networkingClient: NetworkingClient){
        self.networkingClient = networkingClient
    }
    
    func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = dictionary["vote_average"]
            modifiedDictionary["posterPath"] = dictionary["poster_path"]
            modifiedDictionary["title"] = dictionary["name"]
        }
        return modifiedDictionary
    }
}
