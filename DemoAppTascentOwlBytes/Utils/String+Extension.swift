//
//  String+Extension.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 13/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

extension String: Error { }

extension String {
    var utf8Data: Data? {
        return data(using: String.Encoding.utf8)
    }
}
