//
//  VideoContentListCell.swift
//  MovieDB
//
//  Created by Aryuna on 8/16/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

class VideoContentListCell: UITableViewCell {
    static let cellIdentifier = "VideoContentListCell"
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var voteAvgLabel: UILabel!
}
