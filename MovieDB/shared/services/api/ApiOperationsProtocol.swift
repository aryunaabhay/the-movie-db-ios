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

//TODO: get a better name
protocol ApiOperationsProtocol: class {
    associatedtype Content: Object
    static func listContent(sortedBy category: ContentCategory) -> Promise<[Content]>
    static func search(queryTxt: String, category: ContentCategory, localData: [Content]?) -> Promise<[Content]>
    static func mapping(jsonResponse: JSON) -> [Content]
    static func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any]
}

extension ApiOperationsProtocol {
    
    //list content by category
    static func listContent(sortedBy category: ContentCategory) -> Promise<[Content]> {
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
    
    // if local data is passed the method searches inside of that array and returns results if not goes to the server to look for them
    static func search(queryTxt: String, category: ContentCategory, localData: [Content]?) -> Promise<[Content]> {
        let realm = try! Realm()
        if let localObjects = localData {
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
}
