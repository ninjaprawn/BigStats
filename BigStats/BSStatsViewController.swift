//
//  BSStatsViewController.swift
//  BigStats
//
//  Created by George Dan on 10/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSStatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var stats = TweakStats(tweakName: "dudu",downloads: [""])
    var versions = NSDictionary()
    var versionsarr = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.bounds = self.view.bounds
        
        var nib = UINib(nibName: "BSVersionViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "BSVersionViewCell")
        nib = UINib(nibName: "BSTotalViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "BSTotalViewCell")
        versions = stats.downloadsDict()
        versionsarr = versions.allKeys as [String]
        versionsarr = versionsarr.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return versionsarr.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("BSVersionViewCell") as BSVersionViewCell
            var dls = versions[versionsarr[indexPath.row]] as Int
            cell.updateCellWith(versionsarr[indexPath.row], downloads: dls)
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("BSTotalViewCell") as BSTotalViewCell
            cell.updateCellWith(stats.totalDownloads())
            return cell
        }
    }
    
}
