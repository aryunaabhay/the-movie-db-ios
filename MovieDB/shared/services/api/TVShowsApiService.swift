//
//  TVShowsApiService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import Promises
import RealmSwift

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
    
    override func search(queryTxt: String, category: ContentCategory, online: Bool) -> Promise<[Object]> {
        return super.search(queryTxt: queryTxt, category: category, online: online)
            .then({ (objects) -> Promise<[Object]> in
                let sorted = (objects as? [Movie])?.sorted(by: { (left, right) -> Bool in
                    switch category {
                    case .popular:
                        return left.popularity > right.popularity
                    case .topRated:
                        return left.voteAverage > right.voteAverage
                    case .upcoming:
                        return false
                    }
                }) ?? []
                return Promise(sorted)
            })
    }
}
