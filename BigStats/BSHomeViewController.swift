//
//  BSHomeViewController.swift
//  BigStats
//
//  Created by George Dan on 5/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var tweaks: NSDictionary = ["Please wait": ["0.0", "0"]]
    var tweakNames: [String] = ["Please wait"]
    var authorName = ""
    var refreshControl:UIRefreshControl!
    var loading: UIView!
    var firstTime = true
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        // Do any additional setup after loading the view, typically from a nib.
        var nib = UINib(nibName: "BSSummaryViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "BSSummaryViewCell")
        nib = UINib(nibName: "BSTotalViewCell", bundle: nil)
        
        tableView.registerNib(nib, forCellReuseIdentifier: "BSTotalViewCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        if firstTime {
            self.refreshControl = UIRefreshControl()
            self.refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
            self.tableView.addSubview(refreshControl)
            firstTime = false
        }
        
        if self.authorName.isEmpty || (NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/authorName") as String) != self.authorName {
            if let an: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/authorName") {
                self.authorName = an as String
                self.tableView.reloadData()
                self.loadingView()
            } else {
                self.startUpAlert()
            }
        } else {
            self.tableView.reloadData()
        }
    }
    
    func refresh(sender: AnyObject?) {
        self.updateTable()
    }
    
    func loadingView() {
        self.loading = UIView(frame: CGRectMake(0, 0, 50, 50))
        self.loading.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
        self.loading.alpha = 0.0
        self.loading.center = self.view.center
        self.loading.layer.masksToBounds = false
        self.loading.layer.cornerRadius = 5.0
        var loadingView = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
        self.loading.addSubview(loadingView)
        loadingView.startAnimating()
        
        self.view.addSubview(self.loading)
        
        UIView.animateWithDuration(0.5, animations: {
            self.loading.alpha = 1.0
            }, completion: { (finished) in
                if finished {
                    self.updateTable()
                }
        })
    }
    
    func updateTable() {
        
        var statsFinder = StatsFinder(author: authorName)
        self.tweaks = statsFinder.tweaks() as NSDictionary
        self.tweakNames = tweaks.allKeys as [String]
        self.tweakNames = tweakNames.sorted { $0.localizedCaseInsensitiveCompare($1) == NSComparisonResult.OrderedAscending }
        self.tableView.reloadData()
        UIView.animateWithDuration(0.5, animations: {
            self.loading.alpha = 0.0
        }, completion: { (finished) in
            if finished {
                self.loading.removeFromSuperview()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    func startUpAlert(cancel: Bool = false) {
        let alertController = UIAlertController(title: "Search for author", message: nil, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            let authorField = alertController.textFields![0] as UITextField
            self.authorName = authorField.text
            NSUserDefaults.standardUserDefaults().setObject(NSString(string: self.authorName), forKey: "com.ninjaprawn.bigstats/authorName")
            NSUserDefaults.standardUserDefaults().synchronize()
            //self.tableView.contentOffset = CGPointMake(0, 0-self.refreshControl.frame.size.height)
            
            self.loading = UIView(frame: CGRectMake(0, 0, 50, 50))
            self.loading.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.7)
            self.loading.alpha = 0.0
            self.loading.center = self.view.center
            self.loading.layer.masksToBounds = false
            self.loading.layer.cornerRadius = 5.0
            var loadingView = UIActivityIndicatorView(frame: CGRectMake(0,0,50,50))
            self.loading.addSubview(loadingView)
            loadingView.startAnimating()
            
            self.view.addSubview(self.loading)
            
            UIView.animateWithDuration(0.5, animations: {
                self.loading.alpha = 1.0
            }, completion: { (finished) in
                if finished {
                    self.updateTable()
                }
            })
        }
        
        alertController.addAction(OKAction)
        
        if cancel {
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alert) in })
            alertController.addAction(cancelAction)
        }
        
        
        alertController.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Author name"
            OKAction.enabled = false
            
            NSNotificationCenter.defaultCenter().addObserverForName(UITextFieldTextDidChangeNotification, object: textField, queue: NSOperationQueue.mainQueue()) { (notification) in
                if NSString(string: textField.text).containsString(" ") || textField.text.isEmpty {
                    OKAction.enabled = false
                } else {
                    OKAction.enabled = true
                }
            }
        }
        
        self.presentViewController(alertController, animated: true) { }

    }
    
    @IBAction func searchButtonClicked(sender: AnyObject) {
        self.startUpAlert(cancel: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tweaks.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.section == 1 && indexPath.row == 0 {
            var cell = tableView.dequeueReusableCellWithIdentifier("BSTotalViewCell") as BSTotalViewCell
            var totalDownloads = 0
            for tweak in self.tweaks {
                let ts = TweakStats(tweakName: tweak.key as String, downloads: tweak.value as [String])
                totalDownloads += ts.totalDownloads()
            }
            cell.updateCellWith(totalDownloads)
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("BSSummaryViewCell") as BSSummaryViewCell
            var tweakName = self.tweakNames[indexPath.row]
            var dls: AnyObject = self.tweaks.objectForKey(tweakName)!
            cell.updateCellWith(TweakStats(tweakName: tweakName, downloads: dls as [String]))
            return cell
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return self.authorName
        }
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            let statsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("statsvc") as BSStatsViewController
        
            var cell = tableView.cellForRowAtIndexPath(indexPath) as BSSummaryViewCell
            statsViewController.title = cell.tweakStats.tweakName
            statsViewController.stats = cell.tweakStats
            cell.setHighlighted(false, animated: true)
            tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
            self.navigationController?.pushViewController(statsViewController, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0
    }
    


}

