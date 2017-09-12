//
//  EventsListViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit

class EventsListViewController: UIViewController, UITableViewDataSource {
    
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
    
    override func viewDidLoad() {
        tableView.dataSource = self
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
        
        cell.event = events[indexPath.row]
        
        return cell
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
