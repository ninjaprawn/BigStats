//
//  TweakStats.swift
//  BigStats
//
//  Created by George Dan on 6/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class TweakStats {
    var tweakName: String
    var downloads: [String]
    
    init(tweakName: String, downloads: [String]) {
        self.tweakName = tweakName
        self.downloads = downloads
    }
    
    func totalDownloads() -> Int {
        var count = 0
        var tl = 0
        for item in downloads {
            if count % 2 == 1 {
                tl += item.toInt()!
            }
            count++
        }
        return tl
    }
    
    func downloadsDict() -> [String: Int] {
        var dict = ["verystrangename":0]
        var count = 0
        var ver = ""
        for item in downloads {
            if count % 2 == 0 {
                ver = item
            } else {
                dict[ver] = item.toInt()
            }
            count++
        }
        dict["verystrangename"] = nil
        return dict
    }
}
