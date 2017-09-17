//
//  UIViewController+Extension.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/16/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(title: String?, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func showError(_ message: String?) {
        showAlert(title: "Error", message: message)
    }
    
    func showLoader(title: String?, message: String?) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating()
    
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
        return alert
    }
}

extension UIAlertController {
    func dismiss() {
        dismiss(animated: true)
    }
}
