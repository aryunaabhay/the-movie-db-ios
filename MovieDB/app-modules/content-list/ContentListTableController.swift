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
        self.tableView.rowHeight = 90
        let cellIdentifier = VideoContentListCell.cellIdentifier
        let cellNib = UINib(nibName: cellIdentifier, bundle: nil)
        self.tableView.register(cellNib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func databinding(){
        
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
        let videoContent = self.viewModel.displayObjects[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: VideoContentListCell.cellIdentifier, for: indexPath) as! VideoContentListCell
        cell.titleLabel.text = videoContent.title
        cell.voteAvgLabel.text = String(videoContent.voteAverage)
        cell.popularityLabel.text = String(videoContent.popularity)
        cell.configureImage(urlString: AppConfiguration.baseImagesUrlString + "w92/" + videoContent.posterPath)
        cell.selectionStyle = .none
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let videoContent = self.viewModel.displayObjects[indexPath.row]
        VideoContentDetailRouter.navigateToVideoDetail(videoContent: videoContent, presenter: self)
    }
}
