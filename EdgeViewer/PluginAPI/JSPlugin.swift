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
    let context = JSContext()!
    
    init(pluginName: String) {
        let path = pluginFolder + pluginName
        let contentData = FileManager.default.contents(atPath: path)
        let content = String(data: contentData!, encoding: .utf8)
        context.evaluateScript(content)
        let result = context.evaluateScript("testAdder(100, 200)")
        print("\(result!.toInt32())")
    }
}
