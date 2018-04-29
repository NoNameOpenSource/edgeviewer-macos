//
//  JSPlugin.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 27..
//  Copyright © 2018년 NoName. All rights reserved.
//

import Foundation
import JavaScriptCore

// for now it lives in home folder of the user
let pluginFolder = Bundle.main.resourcePath! + "/"

class JSPlugin: Plugin {
    let name: String
    var version: Double
    
    var homePage: LibraryPage {
        get {
            let page = context.evaluateScript("loadHomePage();")!
            let identifier = page.forProperty("identifier")!.toString()!
            let type = page.forProperty("type")!.toString()!
            return LibraryPage(identifier: identifier, type: LibraryPage.LibraryPageType(fromString: type))
        }
    }
    
    let context = JSContext()!
    
    init(pluginName: String) {
        self.name = pluginName
        self.version = 0.1
        let path = pluginFolder + pluginName
        let contentData = FileManager.default.contents(atPath: path)
        let content = String(data: contentData!, encoding: .utf8)
        context.evaluateScript(content)
        _ = homePage
    }
}
