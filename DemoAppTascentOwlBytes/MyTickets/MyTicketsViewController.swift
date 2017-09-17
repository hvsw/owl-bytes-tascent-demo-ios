//
//  MyTicketsViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 16/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import PopupDialog
import UIKit

class MyTicketsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, EventTableViewCellDelegate {
    
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
        cell.delegate = self
        
//        cell.bioPayRoundView.layer.cornerRadius = cell.bioPayRoundView.frame.size.height/2
//        cell.bioPayRoundView.backgroundColor = UIColor.bioPay
//        cell.bioPayCaption.textColor = UIColor.bioPay
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
    
    func didTapBuyAt(cell: EventTableViewCell) {
        guard let event = cell.event else { return }
        showInfo(for: event)
    }
    
    func didTapOverlayViewOn(cell: EventTableViewCell) {
        guard let event = cell.event else { return }
        showInfo(for: event)
    }
    
    private func showInfo(for event: Event) {
        guard let data = event.name.data(using: String.Encoding.isoLatin1, allowLossyConversion: false) else {
            debugPrint("Error getting the data")
            return
        }
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else {
            debugPrint("Error creating the filter")
            return
        }
        
        filter.setValue(data, forKey: "inputMessage")
        filter.setValue("Q", forKey: "inputCorrectionLevel")
        
        guard let qrCodeImage = filter.outputImage else {
            debugPrint("Error generating CIImage")
            return
        }
        
        let scaleX = 1000 / qrCodeImage.extent.size.width
        let scaleY = 1000 / qrCodeImage.extent.size.height
        
        let transformedImage = qrCodeImage.applying(CGAffineTransform(scaleX: scaleX, y: scaleY))
        
        
        let title = "Your mobile ticket"
        let message = "Present this ticket upon entry to the event.\nBio-Payment Enabled for this event"
        let image = UIImage(ciImage: transformedImage)
        
        let popup = PopupDialog(title: title, message: message, image: image)
        
        let closeButton = CancelButton(title: "CLOSE", action: nil)
        popup.addButton(closeButton)
        
        present(popup, animated: true, completion: nil)
    }
}



