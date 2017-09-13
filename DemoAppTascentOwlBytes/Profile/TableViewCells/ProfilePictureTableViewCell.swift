//
//  ProfilePictureTableViewCell.swift
//  DemoAppTascentOwlBytes
//
//  Created by Pietro Degrazia on 9/12/17.
//  Copyright © 2017 None. All rights reserved.
//

import UIKit

class ProfilePictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        profileImageView.layer.cornerRadius = profileImageView.frame.size.height / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderWidth = 3
        profileImageView.layer.borderColor = UIColor.tascent.cgColor
    }
    
    func updateUI() {
        profileImageView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
    }
}
