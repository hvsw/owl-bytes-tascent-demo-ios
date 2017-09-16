//
//  MyTicketsViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 16/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit

class MyTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var events: [Event]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.tascent
        
        automaticallyAdjustsScrollViewInsets = true
        title = "My Tickets"
        navigationController?.navigationBar.barTintColor = UIColor.tascent
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let bought = AppDefaults.shared.getBoughtTickets()
        self.events = allEvents.filter({ (evt: Event) -> Bool in
            return bought.contains(evt.name)
        })
        
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDatasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as? EventTableViewCell else {
            return UITableViewCell()
        }
        
        cell.event = events?[indexPath.row]
        cell.backgroundColor = UIColor.tascent
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
}



