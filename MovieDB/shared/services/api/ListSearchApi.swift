//
//  ListSearchApi.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import SwiftyJSON
import Promises
import RealmSwift

protocol ListSearchApi: class {
    associatedtype Content: VideoContent
    static func retrieveList(sortedBy category: ContentCategory) -> Promise<[Content]>
    static func search(queryTxt: String, category: ContentCategory) -> Promise<[Content]>
}

extension ListSearchApi {
    static func retrieveList(sortedBy category: ContentCategory) -> Promise<[Content]> {
        
        if AppConfiguration.isNetworkReachable {
            let querySegmentType = String(describing: Content.self).lowercased()
            let endpoint = "\(querySegmentType)/\(category.rawValue)"
            let promise = AppConfiguration.movieDBNetworkingClient
                .request(verb: .get, endpoint: endpoint, parameters: [:])
                .then { (json) -> Promise<[Content]> in
                    let mappedContent = self.mapping(jsonResponse: json)
                    return Promise(mappedContent)
                }.catch { (error) in
                    return Promise(error)
                }
            return promise
        } else {
            let realm = try! Realm()
            let filteredContent = realm.objects(Content.self).sorted(byKeyPath: category.associatedKeyPath, ascending: false)
            return Promise(Array(filteredContent))
        }
    }
    
    static func search(queryTxt: String, category: ContentCategory) -> Promise<[Content]> {
        let realm = try! Realm()
        if AppConfiguration.isNetworkReachable {
            return Promise([])
        } else {
            return Promise([])
        }
    }
    
    static func mapping(jsonResponse: JSON) -> [Content] {
        let realm = try! Realm()
        var contentArray: [Content] = []
        realm.beginWrite()
        for contentJson in jsonResponse["results"].arrayObject as? [[String: Any]] ?? [] {
            let content = realm.create(Content.self,
                                       value: self.transformKeysForMapping(dictionary: contentJson),
                                       update: .modified)
            contentArray.append(content)
        }
        try! realm.commitWrite()
        return contentArray
    }
    
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
