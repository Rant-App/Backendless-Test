//
//  MyPostsTableViewController.swift
//  Backendless Test
//
//  Created by block7 on 2/12/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit

class MyPostsTableViewController: UITableViewController {
    
    let backendless = Backendless.sharedInstance()
    
    var id = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var myPosts = [MyPostsTableViewCell]()
    
    var test: [AnyObject]!
    var postArray: [String] = []
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("myPosts", forIndexPath: indexPath) as! MyPostsTableViewCell
        cell.postCell.text = postArray[indexPath.row]
        cell.postCell.editable = false
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
        findPostsById()
        
        self.refreshControl?.addTarget(self, action: "handleRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    }
    func handleRefresh(refreshControl: UIRefreshControl) {
        findPostsById()
        self.tableView.reloadData()
        refreshControl.endRefreshing()
    }
    func findPostsById(){
        let whereClause = "id = '\(id)'"
        let dataQuery = BackendlessDataQuery()
        dataQuery.whereClause = whereClause
        
        let posts = self.backendless.persistenceService.of(Posts.ofClass()).find(dataQuery)
        
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
