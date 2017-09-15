//
//  PaymentMethod.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class PaymentMethod: NSObject, NSCoding {
    var brand = ""
    var cardholderName = ""
    var number = ""
    var expirationDate = ""
    var securityCode = ""
    
    override init() {}
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(brand, forKey: "brand")
        aCoder.encode(cardholderName, forKey: "cardholder")
        aCoder.encode(number, forKey: "number")
        aCoder.encode(expirationDate, forKey: "expirationDate")
        aCoder.encode(securityCode, forKey: "cvc")
    }
    
    required init?(coder aDecoder: NSCoder) {
        if let brand = aDecoder.decodeObject(forKey: "brand") as? String {
            self.brand = brand
        }
        if let cardholderName = aDecoder.decodeObject(forKey: "cardholder") as? String {
            self.cardholderName = cardholderName
        }
        if let number = aDecoder.decodeObject(forKey: "number") as? String {
            self.number = number
        }
        if let expirationDate = aDecoder.decodeObject(forKey: "expirationDate") as? String {
            self.expirationDate = expirationDate
        }
        if let securityCode = aDecoder.decodeObject(forKey: "cvc") as? String {
            self.securityCode = securityCode
        }
    }
}
