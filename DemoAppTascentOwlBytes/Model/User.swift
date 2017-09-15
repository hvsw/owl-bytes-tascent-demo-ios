//
//  User.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

struct User {
    let deviceId: String
    var firstName: String
    var lastName: String
    var dateOfBirth: String?
    var optedInToBiometricPayment: Bool = false
    var paymentMethods = [PaymentMethod]()
    var profilePicture: UIImage?
    
    init() {
        deviceId = ""
        firstName = ""
        lastName = ""
    }
}
