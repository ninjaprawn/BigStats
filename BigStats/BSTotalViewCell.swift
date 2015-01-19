//
//  BSTotalViewCell.swift
//  BigStats
//
//  Created by George Dan on 5/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSTotalViewCell: UITableViewCell {
    
    @IBOutlet weak var tweakName: UILabel!
    @IBOutlet weak var downloadCount: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //tweakName.text = "test"
        downloadCount.textAlignment = NSTextAlignment.Right
    }
    
    func updateCellWith(totalDownloads: Int) {
        var formatter = NSNumberFormatter()
        formatter.numberStyle = NSNumberFormatterStyle.DecimalStyle
        downloadCount.text = "\(formatter.stringFromNumber(totalDownloads as NSNumber)!)"
    }
    
}
