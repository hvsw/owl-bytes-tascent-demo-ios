//
//  User.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class User: NSObject, NSCoding {
    var deviceId: String = ""
    var firstName: String?
    var lastName: String?
    var dateOfBirth: String?
    var optedInToBiometricPayment: Bool = false
    var paymentMethods = [PaymentMethod]()
    var profilePicture: UIImage?
    var enrollmentStatus: String?
    
    override init() {
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(deviceId, forKey: "deviceId")
        aCoder.encode(firstName, forKey: "firstName")
        aCoder.encode(lastName, forKey: "lastName")
        aCoder.encode(dateOfBirth, forKey: "dateOfBirth")
        aCoder.encode(optedInToBiometricPayment, forKey: "optedIn")
        aCoder.encode(paymentMethods, forKey: "paymentMethods")
        aCoder.encode(profilePicture, forKey: "profilePicture")
        aCoder.encode(enrollmentStatus, forKey: "enrollmentStatus")
    }

    required init?(coder aDecoder: NSCoder) {
        if let deviceId = aDecoder.decodeObject(forKey: "deviceId") as? String {
            self.deviceId = deviceId
        }
        if let firstName = aDecoder.decodeObject(forKey: "firstName") as? String {
            self.firstName = firstName
        }
        if let lastName = aDecoder.decodeObject(forKey: "lastName") as? String {
            self.lastName = lastName
        }
        if let dateOfBirth = aDecoder.decodeObject(forKey: "dateOfBirth") as? String {
            self.dateOfBirth = dateOfBirth
        }
        if let optedIn = aDecoder.decodeObject(forKey: "optedIn") as? Bool {
            self.optedInToBiometricPayment = optedIn
        }
        if let paymentMethods = aDecoder.decodeObject(forKey: "paymentMethods") as? [PaymentMethod] {
            self.paymentMethods = paymentMethods
        }
        if let profilePicture = aDecoder.decodeObject(forKey: "profilePicture") as? UIImage {
            self.profilePicture = profilePicture
        }
        if let enrollment = aDecoder.decodeObject(forKey: "enrollmentStatus") as? String {
            self.enrollmentStatus = enrollment
        }
    }
}
