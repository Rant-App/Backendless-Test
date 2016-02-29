//
//  PostViewController.swift
//  Backendless Test
//
//  Created by block7 on 2/4/16.
//  Copyright © 2016 block7. All rights reserved.
//

import Foundation

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    
    
    @IBOutlet weak var postBtn: UIButton!
    
    var backendless = Backendless.sharedInstance()
    
    let identification = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    func dismissKeyboard(){
        view.endEditing(true)
    }
    
    @IBAction func postAction(sender: AnyObject) {
        let postText = textField.text
        let posts = Posts()
        posts.post = postText
        posts.id = identification
        
        let dataStore = backendless.data.of(Posts.ofClass())
        
        var error: Fault?
        let result = dataStore.save(posts, fault: &error) as? Posts
        if error == nil {
            print("Post has been saved: \(result!.objectId)")
        }
        else {
            print("Server reported an error: \(error)")
        }
        
    }
    
}