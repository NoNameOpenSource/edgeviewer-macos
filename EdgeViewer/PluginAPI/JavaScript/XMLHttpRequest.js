//
//  XMLHttpRequest.js
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 4. 29..
//  Copyright © 2018년 NoName. All rights reserved.
//

class XMLHttpRequest {
    constructor() {
        this.status = 0;
        this.readyState = 0;
        this.timeout = 0;
        this.responseType = "";
        this.responseURL = "";
        this.responseXML = null;
        this.withCredentials = false;
        this.requestMethod = "";
    }
    
    open(method, url, async = null, user = null, password = null) {
        this.readyState = 1;
        this.requestMethod = method;
        this.url = url;
    }
    
    addEventListener(type, listener, useCapture = false) {
        switch(type) {
            case "load":
                this.onload = listener;
                break;
            default:
                return;
                
        }
    }
    
    send(body = null) {
        request(this.url, function(statusCode, mimeType, responseText) {
                var evt = new Object();
                evt.target = this;
                if(this.onload) {
                var parser = new DOMParser();
                this.responseText = responseText;
                this.responseHTML = parser.parseFromString(responseText, mimeType);
                this.status = statusCode;
                this.onload(evt);
                }
                }.bind(this));
    }
}
