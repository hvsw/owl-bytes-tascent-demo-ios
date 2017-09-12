//
//  EventTableViewCell.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    
    var event: Event? = nil {
        didSet {
            guard oldValue != event && event != nil else { return }
            
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.darkGray
    }
    
    private func updateUI() {
        guard let image = event?.image, let name = event?.name, let price = event?.price else {
            return
        }
        
        eventImageView.image = image
        eventNameLabel.text = name
        eventPriceLabel.text = String(format: "$ %.2f", price)
    }
    
}
