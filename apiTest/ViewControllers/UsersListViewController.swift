//
//  UsersLIstViewController.swift
//  apiTest
//
//  Created by Андрей on 24.10.2023.
//

import UIKit

protocol NewUserViewControllerDelegate {
    func createUser(user: User)
}

final class UsersListViewController: UITableViewController {
    
    private let networkManager = NetworkManager.shared
    private var users = [User]()
    private var spinnerView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80
        fetchUsers()
        showSpinner(in: tableView)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUser" {
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            let user = users[indexPath.row]
            let userVC = segue.destination as? UserViewController
            userVC?.user = user
        } else if segue.identifier == "newUser" {
            let navigationVC = segue.destination as? UINavigationController
            let newUserVC = navigationVC?.topViewController as? NewUserViewController
            newUserVC?.delegate = self
        }
        
    }
    
    // MARK: - Private methods
    private func showAlert(with networkError:NetworkError) {
        let alert = UIAlertController(
            title: networkError.title,
            message: nil,
            preferredStyle: .alert
        )
        let okAction = UIAlertAction(title: "Ok", style: .default)
        alert.addAction(okAction)
        present(alert, animated: true)
    }
    
    private func showSpinner(in view: UIView) {
        spinnerView.style = .large
        spinnerView.startAnimating()
        spinnerView.hidesWhenStopped = true
        spinnerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinnerView)
        
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor)

        ])
    }
    
}

// MARK: - Networking
extension UsersListViewController {
    private func fetchUsers() {
        
        networkManager.fetchUsers { [weak self] result in
            self?.spinnerView.stopAnimating()
            switch result {
            case .success(let users):
                self?.users = users
            case .failure(let error):
                print("Error in fetchUsers: \(error.localizedDescription)")
                self?.showAlert(with: error)
            }
            self?.tableView.reloadData()
        }
    }
    
    private func post(user: User) {
        networkManager.postUser(user) { [weak self] result in
            switch result {
            case .success(let postUserQuery):
                // create User in UserList
                print("\(postUserQuery)")
                self?.users.append(User(postUserQuery: postUserQuery))
                self?.tableView.reloadData()
            case .failure(let error):
                print("Error in post user: \(error)")
            }
        }
    }
    
    private func deleteUserWith(id: Int, at indexPath: IndexPath) {
        Task {
            if try await networkManager.deleteUserWith(id) {
                users.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } else {
                showAlert(with: .deletingError)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension UsersListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserTableViewCell else { return UITableViewCell()}
        
        cell.configure(with: users[indexPath.row])
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let user = users[indexPath.row]
            deleteUserWith(id: user.id, at: indexPath)
        }
    }
}

// MARK: - NewUserViewControllerDelegate {
extension UsersListViewController: NewUserViewControllerDelegate {
    func createUser(user: User) {
        post(user: user)
    }
}
