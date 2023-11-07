//
//  NewUserViewController.swift
//  apiTest
//
//  Created by Андрей on 06.11.2023.
//

import UIKit

final class NewUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var delegate: NewUserViewControllerDelegate?
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        let user = User(
            id: 0,
            firstName: firstNameTextField.text ?? "",
            lastName: lastNameTextField.text ?? ""
        )
        delegate?.createUser(user: user)
        dismiss(animated: true)
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}


