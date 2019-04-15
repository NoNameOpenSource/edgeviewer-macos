//
//  PageViewProtocol.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 4. 15..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Cocoa

protocol PageViewProtocol {
    var view: NSView { get }
    var book: Book { get }
}
