//
//  UserTableViewCell.swift
//  apiTest
//
//  Created by Андрей on 26.10.2023.
//

import UIKit
import Kingfisher

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
        }
    }
    @IBOutlet weak var nameLabel: UILabel!
    
    func configure(with user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        if user.avatar != nil {
            avatarImageView.kf.setImage(with: user.avatar)
        } else {
            avatarImageView.image = UIImage(systemName: "person.crop.circle")
        }
    }

}
