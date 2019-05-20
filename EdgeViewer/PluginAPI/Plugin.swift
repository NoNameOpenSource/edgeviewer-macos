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
    var homePage: LibraryPage { get }
    
    func page(withIdentifier identifier: Any) -> LibraryPage?
    func book(withIdentifier identifier: Any) -> Book?
    func series(withIdentifier identifier: Any) -> Series?
    func page(ofBook book: Book, pageIndex: Int) -> BookPage?
    func update(book: Book)
    func update(currentPage: Int, ofBook book: Book)
    func update(rating: Double, ofBook book: Book)
    func isSameBook(_ left: Book, _ right: Book) -> Bool
}
