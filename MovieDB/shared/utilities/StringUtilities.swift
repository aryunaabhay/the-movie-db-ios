//
//  StringUtilities.swift
//  MovieDB
//
//  Created by Aryuna on 8/14/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation

extension String {
    
    func toDate(withFormat format: String = "yyyy-MM-dd HH:mm:ss")-> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)
    }
}
