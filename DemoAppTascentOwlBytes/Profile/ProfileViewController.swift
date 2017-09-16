//
//  ProfileViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit
import SwiftyCam

private enum Sections: Int {
    case picture = 0, userData, paymentMethods, biometric, logout
    static let allValues = [Sections.picture, .userData, .paymentMethods, .biometric, .logout]
}

private enum UserDataSection: Int {
    case firstName = 0, lastName, dateOfBirth, picker
    static let allValues = [UserDataSection.firstName, .lastName, .dateOfBirth, .picker]
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user = User() {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let api: APIClientProtocol = StubAPI()
    
    fileprivate var isPickerHidden = true {
        didSet {
            updateUserFromFields()
            tableView.reloadSections([Sections.userData.rawValue], with: .automatic)
        }
    }
    
    fileprivate var statusBarHidden: Bool = true {
        didSet {
            debugPrint(statusBarHidden)
            UIApplication.shared.isStatusBarHidden = statusBarHidden
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        automaticallyAdjustsScrollViewInsets = false
        title = "Profile"
        navigationController?.navigationBar.barTintColor = UIColor.tascent
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        
        if let currentUser = AppDefaults.shared.currentUser() {
            user = currentUser
        }
    }
    
    @objc fileprivate func save() {
        updateUserFromFields()
        
        guard user.profilePicture != nil else {
            showError("Profile picture missing.")
            return
        }
        guard user.firstName != "" && user.lastName != "" && user.dateOfBirth != nil else {
            showError("Personal info missing.")
            return
        }
        guard user.paymentMethods.count > 0 else {
            showError("Please choose at least 1 payment method.")
            return
        }
        guard user.optedInToBiometricPayment else {
            showError("Please opt in to biometric payment.")
            return
        }
        
        let loader = showLoader(title:"Enrolling...", message: "")
        api.enroll(user: user) { (success: Bool, error: Error?, token: String?) in
            loader.dismiss()
            guard error == nil else {
                self.showError("The operation could not be completed.")
                return
            }
            
            guard token != nil else {
                self.showError("Error getting the token for this enrollment")
                return
            }
            
            self.user.token = token!
            AppDefaults.shared.save(user: self.user)
            self.tableView.reloadSections([Sections.logout.rawValue], with: .automatic)
            self.showAlert(title: "User enrolled with success!", message: "Now you can buy tickets for your favorite events!")
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    fileprivate func updateUserFromFields() {
        //profilePicture is already populated
        
        //first name
        let firstNamePath = IndexPath(row: UserDataSection.firstName.rawValue, section: Sections.userData.rawValue)
        let firstNameCell = tableView.cellForRow(at: firstNamePath) as! TextEntryTableViewCell
        user.firstName = firstNameCell.textField.text ?? ""
        
        let lastNamePath = IndexPath(row: UserDataSection.lastName.rawValue, section: Sections.userData.rawValue)
        let lastNameCell = tableView.cellForRow(at: lastNamePath) as! TextEntryTableViewCell
        user.lastName = lastNameCell.textField.text ?? ""
        
        //let dobPath = IndexPath(row: UserDataSection.dateOfBirth.rawValue, section: Sections.userData.rawValue)
        //let dobCell = tableView.cellForRow(at: dobPath) as! TextEntryTableViewCell
        //user.dateOfBirth = dobCell.textField.text ?? ""
    }
    
    fileprivate func didTapNewPaymentMethod() {
        let sb = UIStoryboard(name: "Profile", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "paymentVC") as? PaymentMethodViewController else {return}
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func didTapProfilePicture() {
        let vc = CameraViewController()
        vc.cameraDelegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHidden
    }
    
    fileprivate func setProfilePicture(_ image: UIImage) {
        user.profilePicture = image
        tableView.reloadSections([Sections.picture.rawValue], with: .automatic)
        if !user.optedInToBiometricPayment {
            showConsentForBiometricPayment()
        }
    }
    
    fileprivate func showConsentForBiometricPayment() {
        let title = "Biometric Payment"
        let message = "By \"Opting In\", you will be able to pay for goods and services at approved Points of Sale using a biometric scanner. There is no additional charge for biometric payment. The costs for goods and services will be charged to your credit card at the time of purchase, and receipts will be emailed to you."
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let optOut = UIAlertAction(title: "Opt Out", style: .cancel) { (action) in
            self.userOptedOutOfBiometricPayment()
        }
        let optIn = UIAlertAction(title: "Opt In", style: .default) { (action) in
            self.userOptedInToBiometricPayment()
        }
        alert.addAction(optIn)
        alert.addAction(optOut)
        present(alert, animated: true, completion: nil)
    }
    
    fileprivate func userOptedOutOfBiometricPayment() {
        user.optedInToBiometricPayment = false
        tableView.reloadSections([Sections.biometric.rawValue], with: .automatic)
    }
    
    fileprivate func userOptedInToBiometricPayment() {
        user.optedInToBiometricPayment = true
        tableView.reloadSections([Sections.biometric.rawValue], with: .automatic)
    }
}

extension ProfileViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let section = Sections(rawValue: indexPath.section) else {return}
        switch section {
        case .picture:
            didTapProfilePicture()
            return
        case .userData:
            if indexPath.row == UserDataSection.dateOfBirth.rawValue {
                guard !isPickerHidden else {
                    isPickerHidden = !isPickerHidden
                    return
                }
                let cell = tableView.cellForRow(at: IndexPath(row: UserDataSection.picker.rawValue, section: indexPath.section)) as! DatePickerCell
                let date = cell.datePicker.date
                
                user.dateOfBirth = date
                tableView.reloadRows(at: [indexPath], with: .automatic)
                isPickerHidden = true
            }
        case .paymentMethods:
            guard user.paymentMethods.count > indexPath.row else {
                didTapNewPaymentMethod()
                return
            }
            //didSelectPaymentMethod, nothing to be done, yet
            return
        case .biometric:
            if user.optedInToBiometricPayment {
                userOptedOutOfBiometricPayment()
            } else {
                guard user.profilePicture != nil else {
                    didTapProfilePicture()
                    return
                }
                showConsentForBiometricPayment()
            }
            return
        case .logout:
            AppDefaults.shared.clear()
            user = User()
            tableView.reloadData()
            return
        }
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = Sections(rawValue: section) else {return ""}
        switch sectionType {
        case .picture:
            return " "
        case .userData:
            return "User Data"
        case .paymentMethods:
            return "Payment Methods"
        case .biometric:
            return "Biometric Payment"
        case .logout:
            return " "
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
            if isPickerHidden {
                return UserDataSection.allValues.count - 1
            } else {
                return UserDataSection.allValues.count
            }
        case .paymentMethods:
            return user.paymentMethods.count + 1 //counting the add new method cell
        case .biometric:
            return 1
        case .logout:
            return AppDefaults.shared.currentUser() == nil ? 0 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 50
        let pictureHeight: CGFloat = 150
        let pickerHeight: CGFloat = 150
        guard let section = Sections(rawValue: indexPath.section) else {return defaultHeight}
        if section == .picture {
            return pictureHeight
        }
        if indexPath.section == Sections.userData.rawValue &&
            indexPath.row == UserDataSection.picker.rawValue {
            return pickerHeight
        }
        return defaultHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = Sections(rawValue: indexPath.section) else {return UITableViewCell()}
        switch section {
        case .picture:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath) as? ProfilePictureTableViewCell else {return UITableViewCell()}
            if user.profilePicture != nil  {
                cell.profileImageView.image = user.profilePicture
            } else {
                cell.profileImageView.image = UIImage(named: "profile_placeholder")
            }
            return cell
        case .userData:
            guard indexPath.row != UserDataSection.picker.rawValue else {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: "picker", for: indexPath) as? DatePickerCell else {return UITableViewCell()}
                if let date = user.dateOfBirth {
                    cell.datePicker.setDate(date, animated: false)
                }
                return cell
            }
            guard let cellType = UserDataSection(rawValue: indexPath.row) else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as? TextEntryTableViewCell else {return UITableViewCell()}
            switch cellType {
            case .firstName:
                cell.caption.text = "First Name"
                cell.textField.placeholder = "Required"
                cell.textField.text = user.firstName
            case .lastName:
                cell.caption.text = "Last Name"
                cell.textField.placeholder = "Required"
                cell.textField.text = user.lastName
            case .dateOfBirth:
                cell.caption.text = "DOB"
                cell.textField.placeholder = "mm/dd/yyyy"
                cell.textField.isUserInteractionEnabled = false
                
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MM/dd/yyyy"
                if let date = user.dateOfBirth {
                    let dateString = dateFormatter.string(from: date)
                    cell.textField.text = dateString
                } else {
                    cell.textField.text = ""
                }
            case .picker:break
            }
            return cell
        case .paymentMethods:
            guard user.paymentMethods.count > indexPath.row else {
                return tableView.dequeueReusableCell(withIdentifier: "new_method", for: indexPath)
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as? PaymentMethodTableViewCell else {return UITableViewCell()}
            cell.paymentMethod = user.paymentMethods[indexPath.row]
            return cell
        case .biometric:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "biometric_payment", for: indexPath) as? BiometricPaymentTableViewCell else {return UITableViewCell()}
            
            let text = user.optedInToBiometricPayment ? "Tap to opt out" : "Opt In to Biometric Payment"
            cell.caption.text = text
            cell.switch.setOn(user.optedInToBiometricPayment, animated: true)
            cell.switch.isEnabled = false
            return cell
        case .logout:
            return tableView.dequeueReusableCell(withIdentifier: "logout", for: indexPath)
        }
    }
}

// MARK: - PaymentMethodViewControllerDelegate
extension ProfileViewController: PaymentMethodViewControllerDelegate {
    func didCreatePaymentMethod(paymentMethodViewController: PaymentMethodViewController, payment: PaymentMethod) {
        user.paymentMethods.append(payment)
        navigationController?.popViewController(animated: true)
        tableView.reloadSections([Sections.paymentMethods.rawValue], with: .automatic)
    }
}

extension ProfileViewController: SwiftyCamViewControllerDelegate {
    
    func swiftyCam(_ swiftyCam: SwiftyCamViewController, didTake image: UIImage) {
        navigationController?.popViewController(animated: true)
        
        guard let data = image.data else {
            return
        }
        api.qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            if error == nil {
                if suc {
                    debugPrint("valid image")
                    self.setProfilePicture(image)
                } else {
                    self.showError("Invalid image")
                }
            } else {
                self.showError("Error checking the image! \nDetails: \(error!)")
            }
        }
    }
}
