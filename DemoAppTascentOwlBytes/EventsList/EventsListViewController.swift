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
    
    private let events = [
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Apple Special Event 2017", image: UIImage(named: "apple")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Google I/O 2017", image: UIImage(named: "google")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Facebook F8 2017", image: UIImage(named: "fb")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "FIFA World Cup Russia 2018", image: UIImage(named: "wc")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Olympics Tokyo 2020", image: UIImage(named: "olympics")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
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
        if let evt = cell.event {
            // process purchase
            let title = evt.name
            let message = "Do you wanna buy the ticket for this event?"
            let image = evt.image
            
            let popup = PopupDialog(title: title, message: message, image: image)
            let closeButton = CancelButton(title: "NO", action: nil)
            popup.addButton(closeButton)
            
            let openSiteButton = DefaultButton(title: "YES") {
                debugPrint("Comprando...")
                self.api.buyTicket(for: evt, completion: { (suc: Bool, error: Error?) in
                    if suc {
                        let content = UNMutableNotificationContent()
                        content.title = "Ticket bought for \(evt.name)"
                        content.body = "Your purchase was completed. \(String(format: "%@ - $ %.2f", evt.name, evt.price))"
                        if let attachment = UNNotificationAttachment.create(identifier: evt.name, image: evt.image, options: nil) {
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
                    } else {
                        if error == nil {
                            debugPrint("No error, but not success")
                        } else {
                            debugPrint(error!)
                        }
                    }
                })
            }
            popup.addButton(openSiteButton)
            
            present(popup, animated: true, completion: nil)
        }
    }
    
    func didTapOverlayViewOn(cell: EventTableViewCell) {
        if let evt = cell.event {
            // process purchase
            let title = evt.name
            let message = "This event is happening and will be amazing. Tap BUY below if you want to buy a ticket to go!"
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

