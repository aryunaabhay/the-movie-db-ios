//
//  ContentListViewModelTests.swift
//  MovieDBTests
//
//  Created by Aryuna on 8/20/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import XCTest
import OHHTTPStubs
import RealmSwift
@testable import MovieDB

class ContentListViewModelTests: XCTestCase {
    let domain = App.baseApiUrlString.replacingOccurrences(of: "https://", with: "").replacingOccurrences(of: "/", with: "")
    
    override func setUp() {
        
    }

    override func tearDown() {
        let realm = try! Realm()
        realm.beginWrite()
        realm.delete(realm.objects(Movie.self))
        try! realm.commitWrite()
        App.isNetworkReachable = true
    }
    
    func testMoviesListDataOnline(){
        let contentListVm = ContentListViewModel(contentType: .movie, sortCategory: .popular)
        let path = "/" + App.apiVersion + "/movie/" + contentListVm.sortCategory.rawValue
        stub(condition: isHost(self.domain) && isPath(path)) { _ in
            let stubPath = OHPathForFile("movies.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type":"application/json"])
        }
        let moviesDataExpectation = expectation(description: "movies list online")
        contentListVm.retrieveData({
            moviesDataExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(contentListVm.allObjects.count > 0)
        }
    }
    
    func testListDataLocally(){
        self.loadDataLocally()
        let contentListVm = ContentListViewModel(contentType: .movie, sortCategory: .popular)
        let moviesDataExpectation = expectation(description: "movies list offline")
        contentListVm.retrieveData({
            moviesDataExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(contentListVm.allObjects.count > 0)
        }
    }
    
    func testSearchOnline(){
        stub(condition: isHost(self.domain) && isPath("/" + App.apiVersion + "/search/movie")) { _ in
            let stubPath = OHPathForFile("movies.json", type(of: self))
            return fixture(filePath: stubPath!, headers: ["Content-Type": "application/json"])
        }
        let contentListVm = ContentListViewModel(contentType: .movie, sortCategory: .popular)
        let moviesDataExpectation = expectation(description: "movies search results online")
        
        contentListVm.searchContent(by: "Avengers", completion: {
            moviesDataExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(contentListVm.displayObjects.count > 0)
        }
    }
    
    func testSearchOffline(){
        self.loadDataLocally()
        let contentListVm = ContentListViewModel(contentType: .movie, sortCategory: .popular)
        let moviesDataExpectation = expectation(description: "movies search results offline")
        contentListVm.searchContent(by: "Toy S", completion: {
            moviesDataExpectation.fulfill()
        })
        self.waitForExpectations(timeout: 1) { error in
            XCTAssert(contentListVm.displayObjects.count > 0)
        }
    }
    
    func loadDataLocally(){
        App.isNetworkReachable = false
        let realm = try! Realm()
        realm.beginWrite()
        realm.create(Movie.self, value: ["id": 12, "title": "Toy story 4", "voteAverage": 7.2, "popularity": 237])
        try! realm.commitWrite()
        
        realm.beginWrite()
        realm.create(Movie.self, value: ["id": 15, "title": "Avengers End Game", "voteAverage": 8.4, "popularity": 155])
        try! realm.commitWrite()
    }
}
