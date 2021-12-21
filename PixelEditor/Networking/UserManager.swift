//
//  UserManager.swift
//  PixelEditor
//
//  Created by BarsO_o on 01.10.2021.
//

import Foundation

protocol UserManagerDelegate: AnyObject {
    func userManagerDidConfigure()
    func userManager(didGet user: User)
    func userManagerDidNotGetUser()
    func userManager(didGetUser arts: Arts)
}

extension UserManagerDelegate {
    func userManagerDidConfigure() {}
}

class UserManager {
        
    static let shared = UserManager()
    
    weak var delegate: UserManagerDelegate?
    
    private(set) var user: User?
    
    private(set) var arts: Arts?
 
    private let id: String = "UserManager.user.id"
    private let userDefaults = UserDefaults.standard
    
    private init() {}
    
    func clearUser() {
        user = nil
        userDefaults.removeObject(forKey: id)
    }
}

//MARK: - public user funcs
extension UserManager {
    func saveUser(_ user: User) {
        guard let data = try? JSONEncoder().encode(user) else {
            print("saveUser: unavailable to encode user")
            return
        }
        self.user = user
        userDefaults.set(data, forKey: id)
    }
    
    func getUser() -> User? {
        guard let data = userDefaults.data(forKey: id),
              let user = try? JSONDecoder().decode(User.self, from: data)
        else { return nil }
        self.user = user
        return user
    }
}

//MARK: - public
extension UserManager {
    private func getArtsForUser(completion: @escaping () -> Void) {
        guard let user = user else { return }
        
        getArts(for: user, completion: {
            [unowned self] result in
            switch result {
            case .success(let arts):
                self.arts = arts
                completion()
                break
            case .failure(let error):
                completion()
                print(error)
                break
            }
        })
    }

    func configure() {
        guard let _user = getUser() else {
            delegate?.userManagerDidNotGetUser()
            delegate?.userManagerDidConfigure()
            return
        }
        
        checkIsUserValid(key: _user.key, completion: {
            [unowned self] result in

            delegate?.userManagerDidConfigure()
            
            switch result {
            case .success(let status):
                print(status)
                guard status else {
                    clearUser()
                    delegate?.userManagerDidNotGetUser()
                    return
                }
                
                user = _user
                getArtsForUser() {
                    delegate?.userManager(didGet: _user)
                    delegate?.userManager(didGetUser: arts ?? [])
                }
                break
            case .failure(let error):
                clearUser()
                delegate?.userManagerDidNotGetUser()
                print(error)
                break
            }
        })
    }
}
