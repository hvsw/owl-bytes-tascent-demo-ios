//
//  UIImage+Extension.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 13/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit.UIImage

extension UIImage {
    var data: Data? {
        return UIImagePNGRepresentation(self)
    }
    
    var base64: String? {
        return data?.base64
    }
}
