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
    case picture = 0, userData, paymentMethods
    static let allValues = [Sections.picture, .userData, .paymentMethods]
}

private enum UserDataSection: Int {
    case firstName = 0, lastName, dateOfBirth
    static let allValues = [UserDataSection.firstName, .lastName, .dateOfBirth]
}

class ProfileViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate let api: APIClientProtocol = StubAPI()
    
    var image = UIImage(named: "profile_placeholder")
    
    var paymentMethods = [PaymentMethod]() {
        didSet {
            tableView.reloadData()
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
        //        self.image = image
        //        tableView.reloadData()
        let indexPath = IndexPath(row: 0, section: Sections.picture.rawValue)
        guard let cell = tableView.cellForRow(at: indexPath) as? ProfilePictureTableViewCell else {return}
        cell.profileImageView.image = image
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
            guard paymentMethods.count > indexPath.row else {
                didTapNewPaymentMethod()
                return
            }
            //didSelectPaymentMethod, nothing to be done, yet
            return
        }
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
            return paymentMethods.count + 1 //counting the add new method cell
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
            cell.updateUI()
            return cell
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
                cell.textField.keyboardType = .numberPad
                cell.textField.placeholder = "mm/dd/yyyy"
                cell.setDOBMask()
            }
            return cell
        case .paymentMethods:
            guard paymentMethods.count > indexPath.row else {
                return tableView.dequeueReusableCell(withIdentifier: "new_method", for: indexPath)
            }
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "payment_method", for: indexPath) as? PaymentMethodTableViewCell else {return UITableViewCell()}
            cell.paymentMethod = paymentMethods[indexPath.row]
            return cell
        }
    }
}

// MARK: - PaymentMethodViewControllerDelegate
extension ProfileViewController: PaymentMethodViewControllerDelegate {
    func didCreatePaymentMethod(paymentMethodViewController: PaymentMethodViewController, payment: PaymentMethod) {
        paymentMethods.append(payment)
        navigationController?.popViewController(animated: true)
        tableView.reloadData()
        
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
