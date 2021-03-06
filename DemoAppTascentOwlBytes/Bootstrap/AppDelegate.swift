//
//  AppDelegate.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/11/17.
//  Copyright © 2017 None. All rights reserved.
//

import UserNotifications
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
//        AppDefaults.shared.resetAppDefaults()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.lightContent
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        (window?.rootViewController as? UITabBarController)?.selectedIndex = 1
        
        completionHandler()
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
    
    private func qualityCheck() {
        let data = UIImage(named: "profile")!.data!
        RestAPI().qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            
        }
    }
    
}



var allEvents = [
    Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "Apple Special Event 2017", image: UIImage(named: "apple")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "Google I/O 2017", image: UIImage(named: "google")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "Facebook F8 2017", image: UIImage(named: "fb")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "FIFA World Cup Russia 2018", image: UIImage(named: "wc")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    Event(name: "Olympics Tokyo 2020", image: UIImage(named: "olympics")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
]
