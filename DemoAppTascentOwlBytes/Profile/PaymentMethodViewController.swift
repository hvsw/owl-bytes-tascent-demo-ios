//
//  PaymentMethodViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

private enum Sections: Int {
    case brand = 0, userData, cardData
    static let allValues = [Sections.brand, .userData, .cardData]
}

private enum CardDataSection: Int {
    case number = 0, expirationDate, securityCode
    static let allValues = [CardDataSection.number, .expirationDate, .securityCode]
}


class PaymentMethodViewController: UIViewController {
    let brands = ["Master Card", "American Express", "Visa"]
    var selectedBrandIndex = 0
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false
        title = "Payment Method"
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PaymentMethodViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = Sections(rawValue: indexPath.section), section == .brand else {return}
        guard let oldCell = tableView.cellForRow(at: IndexPath(row: selectedBrandIndex, section: Sections.brand.rawValue)) else {return}
        oldCell.accessoryType = .none
        
        selectedBrandIndex = indexPath.row
        guard let newCell = tableView.cellForRow(at: IndexPath(row: selectedBrandIndex, section: Sections.brand.rawValue)) else {return}
        newCell.accessoryType = .checkmark
    }
}

extension PaymentMethodViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Sections(rawValue: section) else {return ""}
        switch sectionType {
        case .brand:
            return "Card Type"
        case .cardData:
            return "Card Data"
        case .userData:
            return "User Data"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Sections(rawValue: section) else {return 0}
        switch sectionType {
        case .brand:
            return brands.count
        case .userData:
            return 1
        case .cardData:
            return CardDataSection.allValues.count
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 50
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .brand:
            let cell = UITableViewCell(style: .default, reuseIdentifier: "")
            cell.textLabel?.text = brands[indexPath.row]
            let isSelected = selectedBrandIndex == indexPath.row
            cell.accessoryType = isSelected ? .checkmark : .none
            return cell
        case .userData:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as? TextEntryTableViewCell else {return UITableViewCell()}
            cell.caption.text = "Cardholder"
            cell.textField.placeholder = "As shown on card"
            return cell
        case .cardData:
            guard let cellType = CardDataSection(rawValue: indexPath.row) else { return UITableViewCell() }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as? TextEntryTableViewCell else { return UITableViewCell() }
            switch cellType {
            case .number:
                cell.caption.text = "Number"
                cell.textField.placeholder = "0000 0000 0000 0000"
                cell.setCardNumberMask()
            case .expirationDate:
                cell.caption.text = "Expiration"
                cell.textField.placeholder = "MM/YY"
                cell.setExpirationDateMask()
            case .securityCode:
                cell.caption.text = "CVC"
                cell.textField.placeholder = "000"
                cell.setSecurityCodeMask()
            }
            cell.textField.keyboardType = .numberPad
            return cell
        }
    }
}

// MARK: Keyboard Notifications
extension PaymentMethodViewController {
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardHeight = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            tableView.contentInset = UIEdgeInsetsMake(0, 0, keyboardHeight, 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.1, animations: {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
        })
    }
}
