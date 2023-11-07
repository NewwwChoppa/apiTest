//
//  UserViewController.swift
//  apiTest
//
//  Created by Андрей on 24.10.2023.
//

import UIKit
import Kingfisher


final class UserViewController: UIViewController {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    private let networkManager = NetworkManager.shared
    var user: User?
    let emptyUser = User(id: 1000, firstName: "No", lastName: "Name")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        composeUser(user ?? emptyUser)
    }
    
    private func composeUser(_ user: User) {
        nameLabel.text = "\(user.firstName) \(user.lastName)"
        avatarImageView.kf.setImage(with: user.avatar)
    }
    
}
