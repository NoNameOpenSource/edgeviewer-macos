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
    
    let request: @convention(block) (String, JSValue?) -> Void  = { url, callback in
        guard let url = URL(string: url) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
          
            //TODO: handle error with (if let error = error)
            guard let httpResponse = response as? HTTPURLResponse else {
                // request failed
                return
            }
            if let mimeType = httpResponse.mimeType, mimeType == "text/html",
                let data = data,
                let string = String(data: data, encoding: .utf8) {
                if let callback = callback {
                    _ = callback.call(withArguments: [httpResponse.statusCode, mimeType, string])!
                }
            }
        }
        task.resume()
    }
    
    let consoleLog: @convention(block) (String) -> Void = { string in
        print(string)
    }
    
    init(pluginName: String) {
        self.name = pluginName
        self.version = 0.1
        let path = pluginFolder + pluginName
        let contentData = FileManager.default.contents(atPath: path)
        let content = String(data: contentData!, encoding: .utf8)
        let consoleLog = unsafeBitCast(self.consoleLog, to: AnyObject.self)
        let request = unsafeBitCast(self.request, to: AnyObject.self)
        context.setObject(consoleLog, forKeyedSubscript: "consoleLog" as NSCopying & NSObjectProtocol)
        context.setObject(request, forKeyedSubscript: "request" as NSCopying & NSObjectProtocol)
        context.evaluateScript(content)
        _ = homePage
    }
}
