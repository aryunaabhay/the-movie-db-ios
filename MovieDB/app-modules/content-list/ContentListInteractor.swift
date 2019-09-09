//
//  ContentListInteractor.swift
//  MovieDB
//
//  Created by Aryuna on 9/6/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

enum ContentType {
    case tvshow, movie
}

enum ContentListDataState {
    case start, loading, noData, loaded, errorLoading
}

typealias ContentListBusinessLogic = ContentListInteractorProtocol & ContentListDataProtocol

protocol ContentListInteractorProtocol {
    func changeSelectedCategory(_ category: ContentCategory)
    func searchContent(by text: String, completion: (() -> ())?)
    func resetSearch()
    
    // non use case logic
    func selectedCategory(selectedIndex: Int) -> ContentCategory?
    var presenter: ContentListOutputProtocol? { get set }
}

protocol ContentListDataProtocol {
    // worker or gateway to the data server or local
    var apiService: ApiServible { get set }
    
    // request ?
    var sortCategory: ContentCategory { get set }
    var contentType: ContentType { get set }
    var segmentCategories: [String] { get set }
}

class ContentListInteractor: ContentListInteractorProtocol, ContentListDataProtocol {
    var apiService: ApiServible
    
    var sortCategory: ContentCategory
    var contentType: ContentType
    var segmentCategories: [String]
    
    var presenter: ContentListOutputProtocol? = nil
    
    init(contentType: ContentType, sortCategory: ContentCategory){
        self.contentType = contentType
        self.sortCategory = sortCategory
        
        if self.contentType == .movie {
            self.apiService = MoviesApiService(networkingClient: App.movieDBNetworkingClient)
        }else{
            self.apiService = TVShowsApiService(networkingClient: App.movieDBNetworkingClient)
        }
        self.segmentCategories = contentType == .movie ? ["Popular", "Top rated", "Upcoming"] : ["Popular", "Top rated"]
    }
    
    func selectedCategory(selectedIndex: Int) -> ContentCategory? {
        var selected = self.segmentCategories[selectedIndex].lowercased()
        if selected == "top rated" {
            selected = "top_rated"
        }
        if let selectedCategory = ContentCategory(rawValue: selected) {
            return selectedCategory
        }else{
            return nil
        }
    }
    
    func changeSelectedCategory(_ category: ContentCategory){
        self.sortCategory = category
        self.retrieveData(nil)
    }
    
    func searchContent(by text: String, completion: (() -> ())?) {
        if text.count < 4 { return }
        self.presenter?.setState(.loading)
        
        self.apiService.search(queryTxt: text, category: self.sortCategory, online: App.isNetworkReachable).then { [weak self](results) in
            guard let this = self else { return }
            // presenter these are the db objects convert them into dtos the view understands and in the way the view needs them
            let objectResults = results as? [VideoContent] ?? []
            this.presenter?.showResults(objectResults, isSearchMode: true)
            completion?()
        }.catch { [weak self] (error) in
            self?.handleError(error)
            completion?()
        }
    }
    
    func resetSearch(){
        self.presenter?.showResults(self.presenter?.viewController.viewModel.allObjects ?? [], isSearchMode: false)
    }
    
    private func retrieveData(_ completion: (() -> ())?){
        self.presenter?.setState(.loading)
        
        self.apiService.listContent(sortedBy: self.sortCategory, online: App.isNetworkReachable).then { [weak self] (objects) in
            guard let this = self else { return }
            let videoContentArray = objects as? [VideoContent] ?? []
            this.presenter?.showResults(videoContentArray, isSearchMode: false)
            completion?()
        }.catch { [weak self] (error) in
            self?.handleError(error)
            completion?()
        }
    }
    
    private func handleError(_ error: Error){
        self.presenter?.setState(.errorLoading)
    }
}
