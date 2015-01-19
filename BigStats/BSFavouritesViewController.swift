//
//  BSFavouritesViewController.swift
//  BigStats
//
//  Created by George Dan on 12/01/2015.
//  Copyright (c) 2015 Ninjaprawn. All rights reserved.
//

import UIKit

class BSFavouritesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    var favourites: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        //NSUserDefaults.standardUserDefaults().setObject([""], forKey: "com.ninjaprawn.bigstats/favourites")
        //NSUserDefaults.standardUserDefaults().synchronize()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonClicked(sender: AnyObject) {
        let alertController = UIAlertController(title: "Add author", message: nil, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            
            let authorField = alertController.textFields![0] as UITextField
            if let favs: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/favourites") {
                var favours = favs as [String]
                favours.append(authorField.text)
                NSUserDefaults.standardUserDefaults().setObject(favours, forKey: "com.ninjaprawn.bigstats/favourites")
            } else {
                var faves = [authorField.text]
                NSUserDefaults.standardUserDefaults().setObject(faves, forKey: "com.ninjaprawn.bigstats/favourites")
            }
            NSUserDefaults.standardUserDefaults().synchronize()
            self.tableView.reloadData()
            self.tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .None)
        }
        
        alertController.addAction(OKAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (alert) in })
        alertController.addAction(cancelAction)
        
        
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let fav: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/favourites") {
            var favArray = fav as [String]
            if favArray.count == 0 {
                return 1
            } else {
                return favArray.count
            }
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("developerCell") as UITableViewCell
        if let fav: AnyObject = NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/favourites") {
            var favsArray = fav as [String]
            if favsArray.count == 0 {
                cell.textLabel.text = "No favourites"
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                cell.accessoryType = .None
            } else {
                cell.textLabel.text = favsArray[indexPath.row]
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }
        } else {
            cell.textLabel.text = "No favourites"
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            cell.accessoryType = .None
        }
        cell.textLabel.font = UIFont(name: "HelveticaNeue-Light", size: 16.0)
        return cell
    }
    
    func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel.text == "No favourites" {
            return false
        }
        return true
    }
    
    func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            // handle delete (by removing the data from your array and updating the tableview)
            //numbers.removeAtIndex(indexPath.row)
            var favs = NSUserDefaults.standardUserDefaults().valueForKey("com.ninjaprawn.bigstats/favourites") as [String]
            favs.removeAtIndex(indexPath.row)
            NSUserDefaults.standardUserDefaults().setObject(favs, forKey: "com.ninjaprawn.bigstats/favourites")
            NSUserDefaults.standardUserDefaults().synchronize()
            tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: .Automatic)
            
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell = tableView.cellForRowAtIndexPath(indexPath)
        if cell?.textLabel.text != "No favourites" {
            NSUserDefaults.standardUserDefaults().setObject(cell?.textLabel.text, forKey: "com.ninjaprawn.bigstats/authorName")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
    }
    
}
