//
//  TextEntryTableViewCell.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import AKMaskField

class TextEntryTableViewCell: UITableViewCell {

    @IBOutlet weak var caption: UILabel!
    @IBOutlet weak var separator: UIView!
    @IBOutlet weak var textField: AKMaskField!

    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        separator.backgroundColor = UIColor.tascent
        caption.textColor = UIColor.tascent
        textField.autocapitalizationType = .words
    }
    
    func setDOBMask() {
        textField.maskExpression = "{dd}/{dd}/{dddd}"
    }
    
    func setExpirationDateMask() {
        textField.keyboardType = .decimalPad
        textField.maskExpression = "{dd}/{dd}"
    }
    
    func setCardNumberMask() {
        textField.keyboardType = .decimalPad
        textField.maskExpression = "{dddd}-{dddd}-{dddd}-{dddd}"
    }
    
    func setSecurityCodeMask() {
        textField.keyboardType = .decimalPad
        textField.maskExpression = "{ddd}"
    }
}
