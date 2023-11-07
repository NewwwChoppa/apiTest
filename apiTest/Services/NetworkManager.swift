//
//  NetworkManager.swift
//  apiTest
//
//  Created by Андрей on 24.10.2023.
//

import Foundation
import Alamofire

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchAvatar(from url: URL, completion: @escaping (Data) -> Void) {
        DispatchQueue.global().async {
            
            guard let imageData = try? Data(contentsOf: url) else { return }
            
            DispatchQueue.main.async {
                completion(imageData)
            }
        }
    }
    
    
    
    func fetchUsers(completion: @escaping (Result<[User], AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        AF.request(Link.allUsers.url)
            .validate()
            .responseDecodable(of: UsersQuery.self, decoder: decoder) { dataResponse in
                switch dataResponse.result {
                    
                case .success(let usersQuery):
                    completion(.success(usersQuery.data))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func postUser(_ user: User, completion: @escaping (Result<PostUserQuery, AFError>) -> Void) {
        let postUserParameters = PostUserQuery(
            firstName: user.firstName,
            lastName: user.lastName)
        
        AF.request(Link.singleUser.url, method: .post, parameters: postUserParameters)
            .validate()
            .responseDecodable(of: PostUserQuery.self) { dataResponse in
                switch dataResponse.result {
                case .success(let postUserQuery):
                    completion(.success(postUserQuery))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func deleteUserWith(_ id: Int, completion: @escaping (Bool) -> Void) {
        let userURL = Link.singleUser.url.appending(component: "\(id)")
        
        AF.request(userURL, method: .delete)
            .validate(statusCode: [204])
            .response { dataResponse in
                switch dataResponse.result {
                    
                case .success:
                    completion(true)
                case .failure:
                    completion(false)
                }
            }
    }
}

// MARK: - Link

extension NetworkManager {
    enum Link {
        case allUsers
        case singleUser
        case withNoData
        case withDecodingError
        case withNoUsers
        
        var url: URL {
            switch self {
            case .allUsers:
                return URL(string: "https://reqres.in/api/users")!
            case .singleUser:
                return URL(string: "https://reqres.in/api/users")!
            case .withNoData:
                return URL(string: "https://reqres.int/api/users/?delay=2")!
            case .withDecodingError:
                return URL(string: "https://reqres.in/api/users/3?delay=2")!
            case .withNoUsers:
                return URL(string: "https://reqres.in/api/users/?delay=2&page=3")!
            }
        }
    }
}
