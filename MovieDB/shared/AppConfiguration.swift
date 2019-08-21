//
//  AppConfiguration.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

struct App {
    static let movieDBNetworkingClient = NetworkingClient(baseUrl: App.baseApiUrlString + App.apiVersion + "/", apiKey: App.apiKey)
    static var isNetworkReachable = false
    
    static let baseApiUrlString = "https://api.themoviedb.org/"
    static let apiVersion = "3"
    static let apiKey = "a7858a6a4563ad4528384bfef10f4044"
    static let baseImagesUrlString = "https://image.tmdb.org/t/p/"
}
