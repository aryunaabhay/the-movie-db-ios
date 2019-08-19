//
//  AppConfiguration.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

struct AppConfiguration {
    static let movieDBNetworkingClient = NetworkingClient(baseUrl: AppConfiguration.baseApiUrlString, apiKey: AppConfiguration.apiKey)
    static var isNetworkReachable = true
    
    static let baseApiUrlString = "https://api.themoviedb.org/3/"
    static let apiKey = "a7858a6a4563ad4528384bfef10f4044"
    static let baseImagesUrlString = "https://image.tmdb.org/t/p/"
}
