//
//  ViewProtocols.swift
//  MovieDB
//
//  Created by Aryuna on 8/15/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

protocol ConfigurableView: class {
    func configure()
    func configureSubviews()
}

protocol ReactiveDataView: ConfigurableView {
    func configureData()
    func databinding()
}

extension ReactiveDataView {
    func configure(){
        self.configureSubviews()
        self.databinding()
        self.configureData()
    }
}
