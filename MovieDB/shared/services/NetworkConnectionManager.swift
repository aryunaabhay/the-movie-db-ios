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

    func startListening(completion: @escaping (Bool) -> ()){
        let reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.listener = { status in
            switch status {
            case .notReachable:
                completion(false)
            case .reachable(_), .unknown:
                completion(true)
            }
        }
        reachabilityManager?.startListening()
    }
}

