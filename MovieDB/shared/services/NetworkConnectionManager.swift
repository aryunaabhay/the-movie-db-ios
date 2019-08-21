//
//  NetworkConnectionManager.swift
//  MovieDB
//
//  Created by Aryuna on 8/18/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import Alamofire

class NetworkConnectionObserver {
    let manager = NetworkReachabilityManager(host: "www.apple.com")
    
    func startListening(completion: @escaping (Bool) -> ()){
        self.manager?.listener = { status in
            switch status {
            case .notReachable:
                completion(false)
            case .reachable(_), .unknown:
                completion(true)
            }
        }
        self.manager?.startListening()
    }
}

