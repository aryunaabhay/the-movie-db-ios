//
//  ContentListTableController.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ContentListTableController: UITableViewController, ReactiveDataView {
    var viewModel: ContentListViewModel
    
    required init(viewModel: ContentListViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configureSubviews(){
        let cellIdentifier = VideoContentListCell.cellIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func databinding(){
        self.viewModel.viewState.producer.take(duringLifetimeOf: self).startWithValues { [weak self](state) in
            guard let this = self else { return }
            switch state {
            case .start:
                print("start")
            case .dataLoaded:
                this.tableView.reloadData()
            case .loadingData:
                print("loading")
            case .noData:
                 print("nodata")
            case .errorLoadingData:
                print("errorloading")
            }
        }
    }
    
    func configureData(){
        self.viewModel.retrieveData()
    }
}

//MARK: Table delegate methods
extension ContentListTableController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.displayObjects.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = self.viewModel.displayObjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoContentListCell.cellIdentifier, for: indexPath) as! VideoContentListCell
        cell.titleLabel.text = content.title
        cell.voteAvgLabel.text = String(content.voteAverage)
        cell.popularityLabel.text = String(content.popularity)
        cell.selectionStyle = .none
        return cell
    }
}
