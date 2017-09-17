//
//  EventTableViewCell.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit
import PopupDialog

protocol EventTableViewCellDelegate: class {
    func didTapBuyAt(cell: EventTableViewCell)
    func didTapOverlayViewOn(cell: EventTableViewCell)
}

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventPriceLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var bottomView: RoundedView!
    
    weak var delegate: EventTableViewCellDelegate?
    @IBOutlet weak var bioPayRoundView: UIView!
    @IBOutlet weak var bioPayCaption: UILabel!
    
    var event: Event? = nil {
        didSet {
            guard oldValue != event && event != nil else { return }
            
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        backgroundColor = UIColor.darkGray
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOverlayView(gesture:)))
        contentView.addGestureRecognizer(tap)
        
        overlayView.round(.topLeft, radius: 20)
        eventImageView.round(.topLeft, radius: 20)
        bottomView.cornerRadius = 20
    }
    
    private func updateUI() {
        guard let image = event?.image, let name = event?.name, let price = event?.price else {
            return
        }
        
        eventImageView.image = image
        eventNameLabel.text = name
        eventPriceLabel.text = String(format: "$ %.2f", price)
    }
    
    @IBAction func didTapBuy(_ sender: Any) {
        guard event != nil else {
            debugPrint("No event on the cell!")
            return
        }
        
        delegate?.didTapBuyAt(cell: self)
    }
    
    @objc private func didTapOverlayView(gesture: UITapGestureRecognizer) {
        let point = gesture.location(in: overlayView)
        if overlayView.point(inside: point, with: nil) {
            
            guard event != nil else {
                debugPrint("No event on the cell!")
                return
            }
            
            delegate?.didTapOverlayViewOn(cell: self)
        }
    }
    
}
