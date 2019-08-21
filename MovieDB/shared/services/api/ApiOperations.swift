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
    func listContent(sortedBy category: ContentCategory, online: Bool) -> Promise<[Object]>
    func search(queryTxt: String, category: ContentCategory, online: Bool) -> Promise<[Object]>
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
    
    func listContent(sortedBy category: ContentCategory, online: Bool) -> Promise<[Object]> {
        if online {
            let querySegmentType = self.querySegment.lowercased()
            let endpoint = "\(querySegmentType)/\(category.rawValue)"
            return self.networkingClient.request(verb: .get, endpoint: endpoint, parameters: [:])
            .then { (json) -> Promise<[Object]> in
                let mappedContent = self.mapping(jsonResponse: json)
                return Promise(mappedContent)
            }
        } else {
            let realm = try! Realm()
            let filteredContent = realm.objects(T.self).sorted(byKeyPath: category.associatedKeyPath, ascending: false)
            return Promise(Array(filteredContent))
        }
    }
    
    func search(queryTxt: String, category: ContentCategory, online: Bool) -> Promise<[Object]> {
        if online {
            let querySegmentType = self.querySegment.lowercased()
            let endpoint = "search/\(querySegmentType)"
            let params = ["query": queryTxt]
            return self.networkingClient.request(verb: .get, endpoint: endpoint, parameters: params)
            .then { [weak self] (json) -> Promise<[Object]> in
                let mapped = self?.mapping(jsonResponse: json) ?? []
                return Promise(mapped)
            }
        } else {
            let realm = try! Realm()
            let predicate = NSPredicate(format: "title CONTAINS[c] %@", queryTxt.lowercased())
            let filtered = realm.objects(T.self).filter(predicate).sorted(byKeyPath: category.associatedKeyPath, ascending: false)
            return Promise(Array(filtered))
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
