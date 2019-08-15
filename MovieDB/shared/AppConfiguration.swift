//
//  AppConfiguration.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

struct AppConfiguration {
    static let movieDBNetworkingClient = NetworkingClient(baseUrl: "https://api.themoviedb.org/3/",
                                                apiKey: "a7858a6a4563ad4528384bfef10f4044")
    static var isNetworkReachable = true
}
