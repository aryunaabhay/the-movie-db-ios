//
//  ContentListViewModel.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

enum ContentType {
    case tvshow, movie
}

enum ContentListViewState {
    case start, loadingData, noData, dataLoaded, errorLoadingData
}

class ContentListViewModel {
    var allObjects: [VideoContent] = []
    var displayObjects: [VideoContent] = []
    var sortCategory: ContentCategory
    var contentType: ContentType
    var viewState: ContentListViewState = .start
    
    init(contentType: ContentType, sortCategory: ContentCategory){
        self.contentType = contentType
        self.sortCategory = sortCategory
    }
    
    func retrieveData(){
        // TODO: check if we can abstract this better
        if self.contentType == .movie {
            MoviesService.listContent(sortedBy: self.sortCategory).then { [weak self] (movies) in
                guard let this = self else { return }
                this.viewState =  movies.count > 0 ? .dataLoaded : .noData
                this.allObjects = movies
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        } else {
            TVShowsService.listContent(sortedBy: self.sortCategory).then { [weak self] (shows) in
                guard let this = self else { return }
                this.viewState =  shows.count > 0 ? .dataLoaded : .noData
                this.allObjects = shows
            }.catch { [weak self] (error) in
                self?.handleError(error)
            }
        }
    }
    
    func handleError(_ error: Error){
        self.viewState = .errorLoadingData
    }
}
