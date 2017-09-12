//
//  Event.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit

struct Event {
    let name: String
    let image: UIImage
    let price: Float
}

extension Event: Equatable { }
func ==(lhs: Event, rhs: Event) -> Bool {
    return lhs.name == rhs.name
        && lhs.image == rhs.image
        && lhs.price == rhs.price
}
