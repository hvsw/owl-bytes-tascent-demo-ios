//
//  Date+Extensions.swift
//  DemoAppTascentOwlBytes
//
//  Created by Henrique Valcanaia on 12/09/17.
//  Copyright © 2017 None. All rights reserved.
//

import Foundation

extension Date {
    var components: DateComponents {
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: self)
        let minutes = calendar.component(.minute, from: self)
        let seconds = calendar.component(.second, from: self)
        
        var components = DateComponents()
        components.calendar = calendar
        components.hour = hour
        components.minute = minutes
        components.second = seconds
        
        return components
    }
}
