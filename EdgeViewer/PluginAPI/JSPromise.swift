//
//  JSPromise.swift
//  EdgeViewer
//
//  Created by YunSang Lee on 2019. 2. 8..
//  Copyright © 2019년 NoName. All rights reserved.
//

import Foundation
import JavaScriptCore

class JSPromise {
    
    let jsValue: JSValue
    let context: JSContext
    let callMethod: JSValue
    
    init?(withJSValue jsValue: JSValue) {
        guard jsValue.toString() == "[object Promise]" else { return nil }
        self.jsValue = jsValue
        self.context = jsValue.context
        self.callMethod = context.globalObject.forProperty("callMethod");
    }
    
    func then(onFulfilled: AnyObject) {
        callMethod.call(withArguments: [self.jsValue, "then", onFulfilled])
    }
}
