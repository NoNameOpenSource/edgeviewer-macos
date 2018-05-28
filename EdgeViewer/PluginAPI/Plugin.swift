//
//  Plugin.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 27..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Cocoa

protocol Plugin {
    var name: String { get }
    var version: Double { get }
    
    func page(withIdentifier identifier: Any) -> LibraryPage?
    func book(withIdentifier identifier: Any) -> Book?
    func page(ofBook book: Book, pageNumber: Int) -> NSImage?
}
