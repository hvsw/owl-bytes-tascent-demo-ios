//
//  EventsListViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import PopupDialog
import UIKit
import UserNotifications

class EventsListViewController: UIViewController, UITableViewDataSource, EventTableViewCellDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var events = allEvents
    
    private let api: APIClientProtocol = StubAPI()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.tascent
        
        automaticallyAdjustsScrollViewInsets = true
        title = "Events"
        navigationController?.navigationBar.barTintColor = UIColor.tascent
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self
        cell.event = events[indexPath.row]
        cell.backgroundColor = UIColor.tascent
        
        return cell
    }
    
    // MARK: - EventTableViewCellDelegate
    func didTapBuyAt(cell: EventTableViewCell) {
        guard let event = cell.event else {
            return
        }
        let title = event.name
        let message = "Do you want to buy the ticket for this event?"
        let image = event.image
        
        let popup = PopupDialog(title: title, message: message, image: image)
        let closeButton = CancelButton(title: "NO", action: nil)
        popup.addButton(closeButton)
        
        let openSiteButton = DefaultButton(title: "YES") {
            debugPrint("Comprando...")
            self.userConfirmedPurchaseForEvent(event)
        }
        popup.addButton(openSiteButton)
        
        present(popup, animated: true, completion: nil)
    }
    
    fileprivate func userConfirmedPurchaseForEvent(_ event: Event) {
        
        guard isUserEnrolled() else {
            showAlert(title: nil, message: "Please, enroll before purchasing tickets.")
            tabBarController?.selectedIndex = 2//profile tab index
            return
        }
        
        let loader = showLoader(title:"Processing purchase...", message: "")
        self.api.buyTicket(for: event, completion: { (success: Bool, error: Error?) in
            loader.dismiss()
            guard error == nil || !success else {
                self.showError("We were not able to process your purchase at this time.")
                return
            }
            self.eventTicketPurchased(event)
        })
    }
    
    fileprivate func isUserEnrolled() -> Bool {
        guard let user = AppDefaults.shared.currentUser() else {
            return false
        }
        return (user.token != "")
    }
    
    fileprivate func eventTicketPurchased(_ event: Event) {
        hasNotificationPermission { (hasPermission) in
            guard hasPermission else {
                return
            }
            self.scheduleNotificationForPurchase(event)
        }
        AppDefaults.shared.boughtTicket(for: event)
    }
    
    fileprivate func scheduleNotificationForPurchase(_ event: Event) {
        let content = UNMutableNotificationContent()
        content.title = "Ticket bought for \(event.name)"
        var body = "Your purchase was completed.\n \(String(format: "%@ \n $ %.2f", event.name, event.price))"
        if let user = AppDefaults.shared.currentUser() {
            if user.optedInToBiometricPayment {
                body += " \n Biometric Payment enabled"
            }
        }
        content.body = body
        if let attachment = UNNotificationAttachment.create(identifier: event.name, image: event.image, options: nil) {
            content.attachments = [attachment]
        }
        let dateComponents = Date(timeIntervalSinceNow: 2.0).components
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: "TicketBought", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error: Error?) in
            if error != nil {
                debugPrint(error!)
            }
        })
    }
    
    fileprivate func hasNotificationPermission(_ block: @escaping (Bool) -> () ) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { (granted: Bool, error: Error?) in
            guard error == nil else {
                self.showError("Error getting authorization to use notifications! \nDetails: \(error!)")
                block(false)
                return
            }
            guard granted else {
                self.showError("You didn't authorize notification on this device. If you want you can do this later on your device's settings.")
                block(false)
                return
            }
            guard let notificationDelegate = UIApplication.shared.delegate as? UNUserNotificationCenterDelegate else {
                debugPrint("AppDelegate has to implement UNUserNotificationCenterDelegate")
                block(false)
                return
            }
            UNUserNotificationCenter.current().delegate = notificationDelegate
            block(true)
        }
    }
    
    func didTapOverlayViewOn(cell: EventTableViewCell) {
        if let evt = cell.event {
            let title = evt.name
            let message = "This event is happening and will be amazing. Don't lose this chance, buy it now with Tascent!\nTap BUY below if you want to buy a ticket to go!"
            let image = evt.image
            
            let popup = PopupDialog(title: title, message: message, image: image)
            let closeButton = CancelButton(title: "NO", action: nil)
            popup.addButton(closeButton)
            
            let openSiteButton = DefaultButton(title: "BUY") {
                self.didTapBuyAt(cell: cell)
            }
            popup.addButton(openSiteButton)
            
            present(popup, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

