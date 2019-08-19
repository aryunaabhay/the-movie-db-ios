//
//  ApiOperations.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import SwiftyJSON
import Promises
import RealmSwift

protocol ApiObjectOperations: class {
    var querySegment: String { get }
    var networkingClient: NetworkingClient { get set }
    func listContent(sortedBy category: ContentCategory) -> Promise<[Object]>
    func search(queryTxt: String, category: ContentCategory, localData: [Object]?) -> Promise<[Object]>
}

protocol JSONObjectMapping {
    func mapping(jsonResponse: JSON) -> [Object]
    func transformKeysForMapping(dictionary: [String: Any]) -> [String: Any]
}

protocol ApiServible: ApiObjectOperations, JSONObjectMapping { }

class ApiService<T: Object>: ApiServible {
    var querySegment: String { return String(describing: T.self).lowercased() }
    var networkingClient: NetworkingClient
    
    required init(networkingClient: NetworkingClient){
        self.networkingClient = networkingClient
    }
    
    func listContent(sortedBy category: ContentCategory) -> Promise<[Object]> {
        if AppConfiguration.isNetworkReachable {
            let querySegmentType = self.querySegment.lowercased()
            let endpoint = "\(querySegmentType)/\(category.rawValue)"
            let promise = self.networkingClient.request(verb: .get, endpoint: endpoint, parameters: [:])
                .then { (json) -> Promise<[Object]> in
                    let mappedContent = self.mapping(jsonResponse: json)
                    return Promise(mappedContent)
                }.catch { (error) in
                    return Promise(error)
            }
            return promise
        } else {
            let realm = try! Realm()
            let filteredContent = realm.objects(T.self).sorted(byKeyPath: category.associatedKeyPath, ascending: false)
            return Promise(Array(filteredContent))
        }
    }
    
    func search(queryTxt: String, category: ContentCategory, localData: [Object]?) -> Promise<[Object]> {
        let realm = try! Realm()
        if let localObjects = localData {
            return Promise([])
        } else {
            return Promise([])
        }
    }
    
    func transformKeysForMapping(dictionary: [String : Any]) -> [String : Any] {
        return [:]
    }
    
    func mapping(jsonResponse: JSON) -> [Object] {
        let realm = try! Realm()
        var contentArray: [Object] = []
        realm.beginWrite()
        for contentJson in jsonResponse["results"].arrayObject as? [[String: Any]] ?? [] {
            let content = realm.create(T.self,
                                       value: self.transformKeysForMapping(dictionary: contentJson),
                                       update: .modified)
            contentArray.append(content)
        }
        try! realm.commitWrite()
        return contentArray
    }
}
