//
//  BSVersionViewCell.swift
//  BigStats
//
//  Created by George Dan on 10/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSVersionViewCell: UITableViewCell {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var downloadsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        downloadsLabel.textAlignment = NSTextAlignment.Right
    }
    
    func updateCellWith(version: String, downloads: Int) {
        versionLabel.text = version
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        downloadsLabel.text = "\(formatter.stringFromNumber(downloads as NSNumber)!)"
    }
    
}
