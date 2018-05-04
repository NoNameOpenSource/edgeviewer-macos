//
//  Book.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 5. 4..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Foundation

class Book {
    
    var title: String = ""
    var author: String?
    var series: Any?
    var seriesName: String?
    var identifier: Any
    var numberOfPages: Int = 0
    var chapters: [Chapter]?
    
    init(identifier: Any) {
        self.identifier = identifier
    }
}
