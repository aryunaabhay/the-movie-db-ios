//
//  ContentListViewController.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit
import SnapKit

class ContentListViewController: UIViewController, ReactiveDataView {
    private var viewModel: ContentListViewModel
    private var tableViewController: ContentListTableController
    private var containerStackView = UIStackView()
    
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
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = self.viewModel.contentType == .movie ? "Movies" : "TVShows"
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerStackView)
        self.containerStackView.axis = .vertical
        self.containerStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        let segmentedControl = UISegmentedControl(items: ["popular", "top rated", "upcoming"])
        segmentedControl.backgroundColor = UIColor(red: 1/255, green: 210/255, blue: 119/255, alpha: 1)
        segmentedControl.tintColor = UIColor.white
        segmentedControl.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(60)
        }
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.addArrangedSubview(segmentedControl)
        // add search
        self.tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.addArrangedSubview(self.tableViewController.view)
       
    }
    
    func databinding() {
        // react when all objects changes
    }
    
    func configureData() {
        // request data from vm
    }
}
