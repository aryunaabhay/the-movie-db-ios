//
//  VideoContentDetailViewController.swift
//  MovieDB
//
//  Created by Aryuna on 8/17/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Kingfisher

class VideoContentDetailViewController: UIViewController, ReactiveDataView {
    private var viewModel: VideoContentDetailViewModel
    private var posterImageView = UIImageView(image: nil)
    private var titleLabel = UILabel(frame: .zero)
    private var backButton = UIButton(type: .custom)
    private var overviewTextView = UITextView(frame: .zero)
    private var popularityLabel = UILabel(frame: .zero)
    private var voteAveragLabel = UILabel(frame: .zero)
    private var containerStackView = UIStackView()
    
    init(viewModel: VideoContentDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configure()
    }
    
    func configureData() {
        
    }
    
    func databinding() {
        
    }
    
    func configureSubviews() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor.white
        // container stack view
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerStackView)
        self.containerStackView.axis = .vertical
        self.containerStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom)
            make.left.equalTo(self.view)
            make.right.equalTo(self.view)
        }
        
        self.containerStackView.addArrangedSubview(self.titleLabel)
        self.titleLabel.text = self.viewModel.videoContent.title
        
        self.containerStackView.addArrangedSubview(self.posterImageView)
        self.posterImageView.kf.indicatorType = .activity
        self.posterImageView.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(400)
        }
        if let url = URL(string: "https://image.tmdb.org/t/p/w200/" + self.viewModel.videoContent.posterPath){
            self.posterImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.6))])
        }
        
        self.containerStackView.addArrangedSubview(self.overviewTextView)
        self.overviewTextView.text = self.viewModel.videoContent.overview
        self.overviewTextView.isScrollEnabled = true
        
        self.backButton.setTitle("<", for: .normal)
        self.voteAveragLabel.text = String(self.viewModel.videoContent.voteAverage)
        self.popularityLabel.text = String(self.viewModel.videoContent.popularity)
        
        
        
        
        
    }
}
