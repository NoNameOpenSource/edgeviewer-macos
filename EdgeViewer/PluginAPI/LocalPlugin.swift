//
//  LocalPlugin.swift
//  EdgeViewer
//
//  Created by Matthew Dean on 4/28/18.
//  Copyright © 2018 NoName. All rights reserved.
//

import Foundation

class LocalPlugin: Plugin {
    
    
    var name: String = "Local"
    var version: Double = 0.1
    
    var Books = [Book]()
    
    func addBook() {
        // some code
    }
    
    func page(atIndex index: Int) -> LibraryPage {
        // some code
        return LibraryPage()
    }
    
    func book(withIdentifier identifier: Any) -> Book {
        // some code
        return Book(id: 4)
    }
    
    let pluginFolder = Bundle.main.resourcePath! + "/"
    let xmlFileName = "LocalLibrary.xml"
}
