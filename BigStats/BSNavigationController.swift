//
//  BSNavigationController.swift
//  BigStats
//
//  Created by George Dan on 5/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var foregroundColor = UIColor(red: 52/255, green: 73/255, blue: 94/255, alpha: 1.0)
        var backgroundColor = UIColor(red: 236/255, green: 240/255, blue: 241/255, alpha: 0.5)
        var tintColor = UIColor(red: 41/255, green: 128/255, blue: 185/255, alpha: 1.0)
        
        self.navigationBar.backgroundColor = backgroundColor
        self.navigationBar.tintColor = tintColor
        self.navigationBar.shadowImage = foregroundColor.toImage(CGRectMake(0, 0, 1, 1))
        
        if let font = UIFont(name: "HelveticaNeue-Light", size: 18.0) {
            self.navigationBar.titleTextAttributes = [NSFontAttributeName: font, NSForegroundColorAttributeName: foregroundColor]
        }
    }
    
}
