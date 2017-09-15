//
//  Array+Extension.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 14/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

extension Array {
    func randomElement() -> Element? {
        if isEmpty { return nil }
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}
