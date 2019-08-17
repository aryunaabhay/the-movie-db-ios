//
//  Movie.swift
//  MovieDB
//
//  Created by Aryuna on 8/13/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import UIKit
import RealmSwift

class Movie: VideoContent {
    @objc dynamic var video: Bool = false
    @objc dynamic var releaseDate: Date? = nil
}
