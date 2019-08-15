//
//  ContentListViewController.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit

class ContentListViewController: UIViewController, ReactiveDataView {
    var viewModel: ContentListViewModel
    var tableViewController: ContentListTableController
    
    init(viewModel: ContentListViewModel){
        self.viewModel = viewModel
        self.tableViewController = ContentListTableController(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
        self.addChild(self.tableViewController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("implement this if using storyboards or xib files remember providing the viewmodel configured")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configureSubviews(){
        // navigation title
        // add stack container
        // add segmentview
        // add search
        // add table
    }
    
    func databinding() {
        // react when all objects changes
    }
    
    func configureData() {
        // request data from vm
    }
}
