//
//  PaymentMethodTableViewCell.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class PaymentMethodTableViewCell: UITableViewCell {
    
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var numberEndingLabel: UILabel!
    
    var paymentMethod: PaymentMethod? {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        guard let card = paymentMethod else {return}
        brandLabel.text = card.brand
        let digits = card.number
        let lastFourDigits = digits.substring(from:digits.index(digits.endIndex, offsetBy: -4))
        numberEndingLabel.text = "****\(lastFourDigits)"
    }
}
