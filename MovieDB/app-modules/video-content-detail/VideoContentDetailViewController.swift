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
        self.backButton.reactive.controlEvents(.touchUpInside).observeValues { [weak self](button) in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    func configureSubviews() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.view.backgroundColor = UIColor.white
        self.configureContainerStack()
        self.configurePosterAndBackButton()
        self.configureTitle()
        self.configureMetrics()
        self.configureOverviewText()
    }
    
    func configureContainerStack(){
        self.containerStackView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(containerStackView)
        self.containerStackView.axis = .vertical
        self.containerStackView.spacing = 15
        self.containerStackView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top).offset(10)
            make.bottom.equalTo(self.view.safeAreaLayoutGuide.snp.bottom).offset(-10)
            make.left.equalTo(self.view).offset(15)
            make.right.equalTo(self.view).offset(-15)
        }
    }
    
    func configurePosterAndBackButton() {
        let containerImageView = UIView()
        containerImageView.translatesAutoresizingMaskIntoConstraints = false
        
        self.posterImageView.kf.indicatorType = .activity
        self.posterImageView.contentMode = .scaleAspectFill
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = 10
        self.posterImageView.layer.borderColor = Colors.primaryDark.withAlphaComponent(0.3).cgColor
        self.posterImageView.layer.borderWidth = 3
        
        containerImageView.addSubview(self.posterImageView)
        self.posterImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(containerImageView).inset(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        }
        
        self.backButton.setTitleColor(UIColor.white, for: .normal)
        self.backButton.backgroundColor = Colors.primaryLight.withAlphaComponent(0.7)
        self.backButton.layer.cornerRadius = 10
        self.backButton.setTitle("<", for: .normal)
        containerImageView.addSubview(self.backButton)
        self.backButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(40)
            make.top.equalTo(containerImageView).offset(8)
            make.left.equalTo(containerImageView).offset(8)
        }
        
        self.containerStackView.addArrangedSubview(containerImageView)
        containerImageView.snp.makeConstraints { (make) in
            make.height.equalTo(450)
        }
        if let url = URL(string: AppConfiguration.baseImagesUrlString + "w500/" + self.viewModel.videoContent.posterPath){
            self.posterImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.6))])
        }
    }
    
    func configureTitle(){
        self.titleLabel.text = self.viewModel.videoContent.title
        self.titleLabel.textColor = Colors.primaryDark
        self.titleLabel.textAlignment = .left
        self.titleLabel.numberOfLines = -1
        self.titleLabel.font = Fonts.titleFont.withSize(30)
        self.containerStackView.addArrangedSubview(self.titleLabel)
    }
    
    func configureMetrics(){
        self.voteAveragLabel.text = String(self.viewModel.videoContent.voteAverage)
        self.popularityLabel.text = String(self.viewModel.videoContent.popularity)
    }
    
    func configureOverviewText() {
        self.overviewTextView.font = UIFont.systemFont(ofSize: 16)
        self.overviewTextView.textColor = Colors.primaryDark
        self.containerStackView.addArrangedSubview(self.overviewTextView)
        self.overviewTextView.isEditable = false
        self.overviewTextView.text = self.viewModel.videoContent.overview
        self.overviewTextView.isScrollEnabled = true
    }
}
