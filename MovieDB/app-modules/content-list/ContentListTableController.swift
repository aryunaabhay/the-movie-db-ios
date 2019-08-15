//
//  ContentListTableController.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit

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
        // title ?
        // image view for poster
        // textview for overview
    }
    
    func databinding(){
        //databinding react to states and to data ?
    }
    
    func configureData(){
        //request data from vm
    }
}
