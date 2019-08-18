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
    private var categoriesSegmentedControl: UISegmentedControl
    private var loader = UIActivityIndicatorView(style: .gray)
    
    init(viewModel: ContentListViewModel){
        self.viewModel = viewModel
        self.tableViewController = ContentListTableController(viewModel: viewModel)
        self.categoriesSegmentedControl = UISegmentedControl(items: viewModel.segmentCategories)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func configureSubviews(){
        self.navigationController?.navigationBar.isTranslucent = false
        self.title = self.viewModel.contentType == .movie ? "Movies" : "TVShows"
        self.view.backgroundColor = UIColor.white
        // container stack view
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerStackView)
        self.containerStackView.axis = .vertical
        self.containerStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        // segmented control
        self.categoriesSegmentedControl.tintColor = UIColor(red: 1/255, green: 210/255, blue: 119/255, alpha: 1)
        self.categoriesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.addArrangedSubview(self.categoriesSegmentedControl)
        self.categoriesSegmentedControl.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
        }
        self.categoriesSegmentedControl.selectedSegmentIndex = 0
        
        
        // search
        
        // tableview
        self.tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.addArrangedSubview(self.tableViewController.view)
        self.containerStackView.addArrangedSubview(self.loader)
       
    }
    
    func databinding() {
        self.categoriesSegmentedControl.reactive.controlEvents(.valueChanged).signal.observeValues { [weak self](segment) in
            self?.viewModel.updateSelectedCategory(selectedIndex: segment.selectedSegmentIndex)
        }
        
        self.viewModel.dataState.producer.take(duringLifetimeOf: self).startWithValues { [weak self](state) in
            guard let this = self else { return }
            switch state {
            case .start:
                print("start")
            case .loaded:
                this.loader.stopAnimating()
                this.loader.isHidden = true
                this.tableViewController.tableView.isHidden = false
                this.tableViewController.tableView.reloadData()
            case .loading:
                this.loader.isHidden = false
                this.tableViewController.tableView.isHidden = true
                this.loader.startAnimating()
            case .noData:
                print("nodata")
            case .errorLoading:
                print("errorloading")
            }
        }
    }
    
    func configureData() {
        // request data from vm
    }
}
