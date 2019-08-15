//
//  Networking.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Promises

enum HttpVerb: String {
    case get, post , put, head, delete, patch
    
    var alamofireVerb: Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .head:
            return .head
        case .delete:
            return .delete
        case .patch:
            return .patch
        }
    }
}

class NetworkingClient {
   
    private var baseUrl: String
    private var apiKey: String?
    
    init(baseUrl: String, apiKey: String?) {
        self.baseUrl = baseUrl
        self.apiKey = apiKey
    }
    
    func request(verb: HttpVerb, endpoint: String, parameters: [String: String]) -> Promise<SwiftyJSON.JSON> {
        
        let requestUrl = self.baseUrl + endpoint
        var modifiedParameters = parameters
        if let apiKey = self.apiKey {
            modifiedParameters["api_key"] = apiKey
        }
        
        return Promise<SwiftyJSON.JSON> { fulfill, reject in
            Alamofire.request(requestUrl,method: verb.alamofireVerb,
            parameters: modifiedParameters, encoding: URLEncoding.methodDependent, headers: nil)
            .responseJSON { (response) in
                switch response.result {
                case .success(let value):
                    fulfill(JSON(value))
                case .failure(let errorResult):
                    reject(errorResult)
                }
            }
        }
    }
}
