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
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        SVProgressHUD.setDefaultStyle(SVProgressHUDStyle.dark)
        SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.gradient)
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted: Bool, error: Error?) in
            if error == nil {
                if granted {
                    //SVProgressHUD.showSuccess(withStatus: "Successfully registered to receive notifications!")
                    UNUserNotificationCenter.current().delegate = self
                } else {
                    SVProgressHUD.showInfo(withStatus: "You didn't authorize notification on this device. If you want you can do this later on your device's settings.")
                }
            } else {
                SVProgressHUD.showError(withStatus: "Error getting authorization to use notifications! \nDetails: \(error!)")
            }
        }
        
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    private func test() {
        let user = User()
        RestAPI().enroll(user: user) { (suc: Bool, error: Error?, token: String?) in
            if error == nil {
                if token != nil {
                    user.token = token!
                    AppDefaults.shared.save(user: user)
                    RestAPI().getEnrollmentResult(for: user) { (status: EnrollmentStatus?, error: Error?) in
                        if status != nil {
                            print(status!)
                        }
                        
                        if error != nil {
                            print(error!)
                        }
                    }
                } else {
                    debugPrint("Token nil")
                }
            } else {
                debugPrint(error!)
            }
        }
    }
    
}

