//
//  VideoContentListCell.swift
//  MovieDB
//
//  Created by Aryuna on 8/16/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class VideoContentListCell: UITableViewCell {
    static let cellIdentifier = "VideoContentListCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAvgLabel: UILabel!
    
    override func awakeFromNib() {
        self.configure()
    }
    
    func configure(){
        self.posterImageView.clipsToBounds = true
        self.posterImageView.layer.cornerRadius = 8
    }
    
    func configureImage(urlString: String){
        let url = URL(string: urlString)
        self.posterImageView.contentMode = .top
        self.posterImageView.kf.indicatorType = .activity
        self.posterImageView.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(0.6))])
    }
}
