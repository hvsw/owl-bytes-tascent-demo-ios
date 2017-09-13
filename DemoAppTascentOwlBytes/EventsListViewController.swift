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
        Event(name: "Lorem Ipsum", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Lorem Ipsum", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Lorem Ipsum", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Lorem Ipsum", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Foo Fighters at Madison Square Garden", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Tomorrowland 2017", image: UIImage(named: "tomorrowland")!, price: Float(Int.randomIntFrom(start: 100, to: 1000))),
        Event(name: "Lorem Ipsum", image: UIImage(named: "ff")!, price: Float(Int.randomIntFrom(start: 100, to: 1000)))
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    private let api: APIClientProtocol = StubAPI()
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
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
                        
                        let dateComponents = Date(timeIntervalSinceNow: 5.0).components
                        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
                        let request = UNNotificationRequest(identifier: "TicketBought", content: content, trigger: trigger)
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error: Error?) in
                            debugPrint(error)
                        })
                    } else {
                        if error == nil {
                            debugPrint("No error, but not success")
                        } else {
                            debugPrint(error)
                        }
                    }
                })
            }
            popup.addButton(openSiteButton)
            
            present(popup, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
}

