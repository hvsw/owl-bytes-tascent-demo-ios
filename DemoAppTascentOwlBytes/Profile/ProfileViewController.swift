//
//  ProfileViewController.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import Fusuma
import UIKit
import SVProgressHUD

private enum Sections: Int {
    case picture = 0, userData, paymentMethods, biometric
    static let allValues = [Sections.picture, .userData, .paymentMethods, .biometric]
}

private enum UserDataSection: Int {
    case firstName = 0, lastName, dateOfBirth
    static let allValues = [UserDataSection.firstName, .lastName, .dateOfBirth]
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var user = User() {
        didSet {
            tableView.reloadData()
        }
    }
    
    fileprivate let api: APIClientProtocol = RestAPI()
    
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
            SVProgressHUD.showError(withStatus: "Profile picture missing.")
            return
        }
        guard user.firstName != "" && user.lastName != "" && user.dateOfBirth != "" else {
            SVProgressHUD.showError(withStatus: "Personal info missing.")
            return
        }
        guard user.paymentMethods.count > 0 else {
            SVProgressHUD.showError(withStatus: "Please choose at least 1 payment method.")
            return
        }
        guard user.optedInToBiometricPayment else {
            SVProgressHUD.showError(withStatus: "Please opt in to biometric payment.")
            return
        }
        
        SVProgressHUD.show()
        api.enroll(user: user) { (success, error) in
            guard error == nil else {
                SVProgressHUD.showError(withStatus: error?.localizedDescription)
                return
            }
            AppDefaults.shared.save(user: self.user)
            SVProgressHUD.showSuccess(withStatus: "User enrolled with success!")
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
        
        let dobPath = IndexPath(row: UserDataSection.dateOfBirth.rawValue, section: Sections.userData.rawValue)
        let dobCell = tableView.cellForRow(at: dobPath) as! TextEntryTableViewCell
        user.dateOfBirth = dobCell.textField.text ?? ""
    }
    
    fileprivate func didTapNewPaymentMethod() {
        let sb = UIStoryboard(name: "Profile", bundle: Bundle.main)
        guard let vc = sb.instantiateViewController(withIdentifier: "paymentVC") as? PaymentMethodViewController else {return}
        vc.delegate = self
        navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func didTapProfilePicture() {
        let fusuma = FusumaViewController()
        fusuma.delegate = self
        fusumaTintColor = .white
        fusumaBackgroundColor = .tascent
        fusumaBaseTintColor = .lightGray
        fusuma.availableModes = [.camera, .library]
        statusBarHidden = true
        present(fusuma, animated: true, completion: nil)
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
        let message = "Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. Lorem ipsum. "
        
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
        case .userData: return
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
            return user.paymentMethods.count + 1 //counting the add new method cell
        case .biometric:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let defaultHeight: CGFloat = 50
        let pictureHeight: CGFloat = 150
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
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "picture", for: indexPath) as? ProfilePictureTableViewCell else {return UITableViewCell()}
            if user.profilePicture != nil  {
                cell.profileImageView.image = user.profilePicture
            }
            return cell
        case .userData:
            guard let cellType = UserDataSection(rawValue: indexPath.row) else {return UITableViewCell()}
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "text", for: indexPath) as? TextEntryTableViewCell else {return UITableViewCell()}
            switch cellType {
            case .firstName:
                cell.caption.text = "First Name"
                if !cell.textField.hasText {
                    cell.textField.text = user.firstName
                }
            case .lastName:
                cell.caption.text = "Last Name"
                if !cell.textField.hasText {
                    cell.textField.text = user.lastName
                }
            case .dateOfBirth:
                cell.caption.text = "DOB"
                cell.textField.keyboardType = .numberPad
                cell.textField.placeholder = "mm/dd/yyyy"
                if !cell.textField.hasText {
                    cell.setDOBMask()
                    cell.textField.text = user.dateOfBirth
                }
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

// MARK: - FusumaDelegate
extension ProfileViewController: FusumaDelegate {
    func fusumaMultipleImageSelected(_ images: [UIImage], source: FusumaMode) {
        statusBarHidden = false
        
        guard let image = images.first, let data = image.data else {
            SVProgressHUD.showError(withStatus: "Error generating data from image")
            return
        }
        
        api.qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            if error == nil {
                if suc {
                    debugPrint("valid image")
                    self.setProfilePicture(image)
                } else {
                    SVProgressHUD.showError(withStatus: "Invalid image")
                }
            } else {
                SVProgressHUD.showError(withStatus: "Error checking the image! \nDetails: \(error!)")
            }
        }
    }
    
    func fusumaImageSelected(_ image: UIImage, source: FusumaMode) {
        statusBarHidden = false
        
        guard let data = image.data else {
            return
        }
        
        api.qualityCheck(imageData: data) { (suc: Bool, error: Error?) in
            if error == nil {
                if suc {
                    debugPrint("valid image")
                    self.setProfilePicture(image)
                } else {
                    SVProgressHUD.showError(withStatus: "Invalid image")
                }
            } else {
                SVProgressHUD.showError(withStatus: "Error checking the image! \nDetails: \(error!)")
            }
        }
    }
    
    func fusumaCameraRollUnauthorized() {
        debugPrint("Not authorized")
        SVProgressHUD.showError(withStatus: "You must enable camera access in order to use this feature. Please access your settings and enable camera for this app.")
    }
    
    func fusumaClosed() {
        
    }
    
    func fusumaVideoCompleted(withFileURL fileURL: URL) {
        
    }
    
    func fusumaDismissedWithImage(_ image: UIImage, source: FusumaMode) {
        
    }
    
    func fusumaWillClosed() {
        statusBarHidden = false
    }
    
}
