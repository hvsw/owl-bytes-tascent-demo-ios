//
//  AppDelegate.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/11/17.
//  Copyright © 2017 None. All rights reserved.
//

import SVProgressHUD
import UserNotifications
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted: Bool, error: Error?) in
            if error == nil {
                if granted {
                    SVProgressHUD.showSuccess(withStatus: "Successfully registered to receive notifications!")
                } else {
                    SVProgressHUD.show(withStatus: "You didn't authorize notification on this device. If you want you can do this later on your device's settings.")
                }
            } else {
                SVProgressHUD.showError(withStatus: "Error getting authorization to use notifications! \nDetails: \(error!)")
            }
        }
        
        return true
    }
    
}

