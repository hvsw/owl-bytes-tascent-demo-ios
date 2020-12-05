//
//  Data+Extension.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 13/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

extension Data {
    var base64: String {
        return base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    var string: String? {
        return String(data: self, encoding: String.Encoding.utf8)
    }
}
