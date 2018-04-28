//
//  Plugin.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 27..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Foundation

protocol Plugin {
    var name: String { get }
    var version: Double { get }
    
    func page(atIndex index: Int) -> LibraryPage
    func book(withIdentifier identifier: Any) -> Book
}
