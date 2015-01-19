//
//  StatsFinder.swift
//  BigStats
//
//  Created by George Dan on 6/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

extension String {
    subscript (r: Range<Int>) -> String {
        get {
            let startIndex = advance(self.startIndex, r.startIndex)
            let endIndex = advance(startIndex, r.endIndex - r.startIndex)
            
            return self[Range(start: startIndex, end: endIndex)]
        }
    }
}


class StatsFinder {
    var author: String
    var url: NSURL
    
    init(author: String) {
        self.author = author
        self.url = NSURL(string: "http://apt.thebigboss.org/stats.php?dev=\(author)")!
    }
    
    func getVersionsForName(source: String, tweak: String, number: Int) -> String {
        var tw = tweak.stringByReplacingOccurrencesOfString("+", withString: "\\+", options: nil, range: nil)
        tw = tw.stringByReplacingOccurrencesOfString("(", withString: "\\(", options: nil, range: nil)
        tw = tw.stringByReplacingOccurrencesOfString(")", withString: "\\)", options: nil, range: nil)
        var pattern = "<strong>\(tw)</strong> \\((.+?)\\)</td>"
        let versions = source[pattern].allGroups()
        var newVersion = versions[number][1]
        return newVersion
    }
    
    func tweaks() -> [String: [String]] {
        var tweaks: [String: [String]] = ["No Author Found":[]]
        var error: NSError?
        var err: NSError?
        let myHTMLString = NSString(contentsOfURL: url, encoding: NSUTF8StringEncoding, error: &error)
        if let error = error {
            println("Error: \(error)")
            tweaks["No Author Found"] = nil
            tweaks["An Error Occured"] = []
        } else {
            let parser = HTMLParser(html: myHTMLString!, error: &err)
            if let err = err {
                //println("error: \(err)")
            } else {
                var body = parser.body
                var count = [String: Int]()
                //Find tables
                if let tables = body?.findChildTags("table") as [HTMLNode]? {
                    var table = tables[1]
                    //Find rows
                    if let rows = table.findChildTags("tr") as [HTMLNode]? {
                        for row in rows {
                            //Find tds
                            if let tds = row.findChildTags("td") as [HTMLNode]? {
                                var currentTweak = ""
                                for td in tds {
                                    //Tweak Titles
                                    if let strongs = td.findChildTags("strong") as [HTMLNode]? {
                                        for strong in strongs {
                                            if let exists = tweaks[strong.contents] {
                                            
                                            tweaks[strong.contents]!.append(getVersionsForName(myHTMLString!, tweak: strong.contents, number: count[strong.contents]!))
                                            count[strong.contents] = count[strong.contents]!+1
                                                
                                            } else {
                                                tweaks[strong.contents] = [getVersionsForName(myHTMLString!, tweak: strong.contents, number: 0)]
                                                count[strong.contents] = 1
                                            }
                                            currentTweak = strong.contents
                                        }
                                    }
                                    if let downloads = td.contents.toInt() {
                                        tweaks[currentTweak]?.append(td.contents)
                                        break
                                    }
                                }
                            }
                        }
                    }
                }
                tweaks["No Author Found"] = nil
            }
        }
        return tweaks
    }    
}

