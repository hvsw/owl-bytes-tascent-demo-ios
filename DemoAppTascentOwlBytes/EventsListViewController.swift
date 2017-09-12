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
                        debugPrint("Bought!")
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

extension Int {
    static func randomIntFrom(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
}
