//
//  WallTableViewController.swift
//  Backendless Test
//
//  Created by block7 on 2/12/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit

class WallTableViewController: UITableViewController {
    let backendless = Backendless.sharedInstance()
    
    var id = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var myPosts = [WallTableViewCell]()
    
    var test: [AnyObject]!
    var postArray: [String] = []
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myWallPosts", forIndexPath: indexPath) as! WallTableViewCell
        cell.postText.text = postArray[indexPath.row]
        cell.postText.editable = false
        return cell
    }
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return test.count
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        findPosts()
        self.navigationItem.setHidesBackButton(true, animated: true)
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        findPosts()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func findPosts(){
        
        let posts = backendless.data.of(Posts.ofClass()).find()
        
        
        test = posts.data
        
        let currentPage = posts.getCurrentPage()
        
        
        for post in currentPage as! [Posts] {
            let userid = post.id
            let postText = post.post
            
            let unwrappedPostText = postText!
            postArray.append(unwrappedPostText)
        }
    }

}
