//
//  ContentListViewController.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit
import SnapKit
import ReactiveSwift
import ReactiveCocoa

class ContentListViewController: UIViewController, ReactiveDataView {
    private let viewModel: ContentListViewModel
    private let tableViewController: ContentListTableController
    private let containerStackView = UIStackView()
    private let categoriesSegmentedControl: UISegmentedControl
    private let searchBar = UISearchBar(frame: .zero)
    private let loader = UIActivityIndicatorView(style: .gray)
    private let noDataLabel = UILabel(frame: .zero)
    
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
        self.title = self.viewModel.contentType == .movie ? "Movies" : "TV Shows"
        self.view.backgroundColor = UIColor.white
        self.configureContainerStack()
        self.configureSegmentedControl()
        self.configureSearch()
        self.configureTableView()
    }
    
    func configureContainerStack(){
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerStackView)
        self.containerStackView.axis = .vertical
        self.containerStackView.spacing = 8
        self.containerStackView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
    }
    
    func configureSegmentedControl(){
        self.categoriesSegmentedControl.tintColor = Colors.primaryLight
        self.categoriesSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        self.categoriesSegmentedControl.selectedSegmentIndex = 0
        
        let segmentedControlContainerView = UIView()
        segmentedControlContainerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControlContainerView.addSubview(self.categoriesSegmentedControl)
        self.categoriesSegmentedControl.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(segmentedControlContainerView).inset(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }
        self.containerStackView.addArrangedSubview(segmentedControlContainerView)
        segmentedControlContainerView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(40)
        }
    }
    
    func configureSearch(){
        self.searchBar.translatesAutoresizingMaskIntoConstraints = false
        self.searchBar.delegate = self
        self.searchBar.barTintColor = Colors.primaryLight
        self.searchBar.tintColor = Colors.primaryDark
        self.containerStackView.addArrangedSubview(self.searchBar)
        self.searchBar.placeholder = "Search"
        self.searchBar.returnKeyType = .done
        self.searchBar.snp.makeConstraints { (make) in
            make.height.equalTo(50)
        }
    }
    
    func configureTableView(){
        self.tableViewController.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerStackView.addArrangedSubview(self.tableViewController.view)
        self.containerStackView.addArrangedSubview(self.loader)
        self.containerStackView.addArrangedSubview(self.noDataLabel)
        self.loader.isHidden = true
        self.noDataLabel.isHidden = true
        self.noDataLabel.textAlignment = .center
        self.noDataLabel.textColor = Colors.primaryDark
        self.noDataLabel.font = Fonts.titleFont
    }
    
    func databinding() {
        self.categoriesSegmentedControl.reactive.controlEvents(.valueChanged).signal.observeValues { [weak self](segment) in
            guard let this = self else { return }
            this.viewModel.updateSelectedCategory(selectedIndex: segment.selectedSegmentIndex)
            this.searchBarCancelButtonClicked(this.searchBar)
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
                if this.viewModel.displayObjects.count > 0 {
                    this.tableViewController.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
                }
            case .loading:
                this.loader.isHidden = false
                this.tableViewController.tableView.isHidden = true
                this.loader.startAnimating()
            case .noData:
                this.loader.isHidden = true
                this.tableViewController.tableView.isHidden = true
                this.noDataLabel.text = "Not found"
                this.noDataLabel.isHidden = false
            case .errorLoading:
                print("errorloading")
            }
        }
        
        self.searchBar.reactive.continuousTextValues.take(duringLifetimeOf: self).throttle(0.8
            , on: QueueScheduler.main).observeValues { [weak self](text) in
            guard let this = self, let searchText = text else { return }
            this.viewModel.searchContent(by: searchText)
        }
    }
    
    func configureData() {
        // request data from vm
    }
}

extension ContentListViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearch()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.cancelSearch()
    }
    
    func cancelSearch(){
        self.searchBar.showsCancelButton = false
        self.searchBar.text = ""
        self.searchBar.resignFirstResponder()
        self.viewModel.resetSearch()
    }
}
