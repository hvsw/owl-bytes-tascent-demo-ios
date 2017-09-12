//
//  ProfileViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit


private enum Sections: Int {
    case picture = 0, userData, paymentMethods
    static let allValues = [Sections.picture, .userData, .paymentMethods]
}

private enum UserDataSection: Int {
    case firstName = 0, lastName, dateOfBirth
    static let allValues = [UserDataSection.firstName, .lastName, .dateOfBirth]
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false
        title = "Profile"
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Sections(rawValue: section) else {return ""}
        switch sectionType {
        case .picture:
            return "Picture"
        case .userData:
            return "User Data"
        case .paymentMethods:
            return "Payment Methods"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allValues.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = Sections(rawValue: section) else {return 0}
        switch sectionType {
        case .picture:
            return 1
        case .userData:
            return UserDataSection.allValues.count
        case .paymentMethods:
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 50
        let pictureHeight: CGFloat = 110
        guard let section = Sections(rawValue: indexPath.section) else {return defaultHeight}
        if section == .picture {
           return pictureHeight
        }
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .picture:
            return tableView.dequeueReusableCell(withIdentifier: "picture")!
        case .userData:
            guard let cellType = UserDataSection(rawValue: indexPath.row) else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as? TextEntryTableViewCell else {return UITableViewCell()}
            switch cellType {
            case .firstName:
                cell.caption.text = "First Name"
            case .lastName:
                cell.caption.text = "Last Name"
            case .dateOfBirth:
                cell.caption.text = "DOB"
                cell.textField.placeholder = "mm/dd/yyyy"
            }
            return cell
        case .paymentMethods:
            return UITableViewCell()
        }
    }
}
