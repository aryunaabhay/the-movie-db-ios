//
//  MoviesApiService.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import Promises
import RealmSwift

class MoviesApiService: ApiService<Movie> {

    override func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any] {
        var modifiedDictionary = dictionary
        if modifiedDictionary.keys.contains("release_date") {
            let releaseDate = (dictionary["release_date"] as? String)?.toDate(withFormat: "yyyy-MM-dd")
            modifiedDictionary["releaseDate"] = releaseDate
        }
        if modifiedDictionary.keys.contains("vote_average") {
            modifiedDictionary["voteAverage"] = dictionary["vote_average"] ?? 0.0
        }
        if modifiedDictionary.keys.contains("poster_path") {
            modifiedDictionary["posterPath"] = (dictionary["poster_path"] as? String)?.removingPercentEncoding ?? ""
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
                    if let leftReleaseDate = left.releaseDate, let rightReleaseDate = right.releaseDate {
                        return leftReleaseDate > rightReleaseDate
                    }else{
                        return true
                    }
                }
            }) ?? []
            return Promise(sorted)
        })
    }
}
