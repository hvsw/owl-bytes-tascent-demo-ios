//
//  MonthYearPicker.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/15/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class MonthYearPicker: UIPickerView {
    let months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dataSource = self
        self.delegate = self
    }
    
    func getDateString() -> String {
        return "Jan/22"
    }
}

extension MonthYearPicker: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 { //month
            return 12
        } else { //year
            return 20 //years ahead should be enough
        }
    }
}

extension MonthYearPicker: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 { //month
            return months[row]
        } else { //year
            return "\(2017 + row)"
        }
    }
}
