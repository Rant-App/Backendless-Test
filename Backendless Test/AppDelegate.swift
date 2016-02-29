//
//  AppDelegate.swift
//  Backendless Test
//
//  Created by block7 on 2/1/16.
//  Copyright © 2016 block7. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let APP_ID = "DA768064-82F0-A5E6-FF9D-2E742DA45300"
    let SECRET_KEY = "3BB19F39-0750-49E6-FF91-4B1A6427BA00"
    let VERSION_NUM = "v1"
    
    var backendless = Backendless.sharedInstance()
    
    let identification = UIDevice.currentDevice().identifierForVendor!.UUIDString
    
    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        backendless.initApp(APP_ID, secret:SECRET_KEY, version:VERSION_NUM)
        // If you plan to use Backendless Media Service, uncomment the following line (iOS ONLY!)
        // backendless.mediaService = MediaService()
        return true
    }
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        logoutUserSync()
        logoutUserAsync()
        
    }
    func logoutUserAsync() {
        
        backendless.userService.login(
            identification, password:"password",
            response: { ( user : BackendlessUser!) -> () in
                print("User has been logged in (ASYNC): \(user)")
                
                self.backendless.userService.logout(
                    { ( user : AnyObject!) -> () in
                        print("Current user session expired.")
                    },
                    error: { ( fault : Fault!) -> () in
                        print("Server reported an error: \(fault)")
                    }
                )
            },
            error: { ( fault : Fault!) -> () in
                print("Server reported an error: \(fault)")
            }
        )
    }
    func logoutUserSync() {
        
        Types.tryblock({ () -> Void in
            
            let user = self.backendless.userService.login(self.identification, password: "password")
            print("User has been logged in (SYNC): \(user)")
            self.backendless.userService.logout()
            print("Current user session expired.")
            },
            
            catchblock: { (exception) -> Void in
                print("Server reported an error: \(exception as! Fault)")
            }
        )
    }

}

