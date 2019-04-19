//
//  DOMParser.js
//  EdgeViewer
//
//  Created by YunSang Lee on 2018. 5. 3..
//  Copyright © 2018년 NoName. All rights reserved.
//

class DOMParser {
    consturctor() {
    }
    
    parseFromString(str, mimeType) {
        if(mimeType == undefined)
            mimeType = "text/html";
        if(mimeType != "text/html") { return; }
        let index = str.indexOf("<html");
        if(index == -1) { return; }
        var htmlString = str.substring(index);
        var document = new Element(htmlString);
        for (var i = 0; i < document.children.length; i++) {
            if(document.children[i].nodeName == "body") {
                document.body = document.children[i].nodeName;
            }
            if(document.children[i].nodeName == "head") {
                document.head = document.children[i].nodeName;
            }
        }
        return document;
    }
    
    static nextTag(str, skipFirst) {
        var i = 0;
        if(skipFirst) {
            i = str.indexOf('<') + 1;
        }
        for (; i < str.length; i++) {
            if(str[i] == '<') {
                if(str[i+1] == '!') {
                    // ignore commented area
                    var substr = str.substring(i);
                    i += substr.indexOf("-->");
                } else {
                    return i;
                }
            }
        }
        return -1;
    }
    
    static nodeName(nodeStr) {
        for (var i = 1; i < nodeStr.length; i++) {
            if(nodeStr[i] == ' ' || nodeStr[i] == '>' )
                return nodeStr.substring(1, i);
        }
        return "";
    }
    
    static attributes(nodeStr) {
        var attributes = {};
        var tag = nodeStr.substring(0, nodeStr.indexOf('>'))
        //var match = tag.match(/(?!\s)([a-zA-Z0-9]+)=(([0-9])|(".*?"))/);
        var match = tag.match(/(?!\s)(id|class)=(([0-9]+)|(".*?"))/gi);
        if (match == null)
            return attributes;
        for (var i = 0; i < match.length; i++) {
            var equalIndex = match[i].indexOf('=');
            var value;
            if(match[i][equalIndex+1] == '"' || match[i][equalIndex+1] == "'") {
                value = match[i].substring(equalIndex+2, match[i].length-1);
            } else {
                value = match[i].substring(equalIndex+1);
            }
            attributes[match[i].substring(0, equalIndex)] = value;
        }
        return attributes;
    }
}
