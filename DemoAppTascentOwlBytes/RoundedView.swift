//
//  Roundedview.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class RoundedView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0
    
    @IBInspectable
    var corners: UIRectCorner = [.bottomLeft, .bottomRight]
    
    override func layoutSubviews() {
        super.layoutSubviews()
        round(corners, radius: cornerRadius)
    }
}
