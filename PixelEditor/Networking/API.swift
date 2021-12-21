//
//  API.swift
//  PixelEditor
//
//  Created by BarsO_o on 18.12.2021.
//

import FirebaseCore
import FirebaseDatabase
import CodableFirebase

func convertToDict<T: Encodable>(value: T) -> Dict? {
    guard
        let data = try? JSONEncoder().encode(value)
    else {
        return nil
    }
    
    guard
        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? Dict
    else {
        return nil
    }
    
    return json
}

func convertToStruct<T: Decodable>(value: Dict) -> T? {
    guard
        let userData = try? JSONSerialization.data(withJSONObject: value, options: [])
    else {
        print("data error"); return nil
    }
    
    
    guard let value = try? JSONDecoder().decode(T.self, from: userData) else {
        print("decoder error"); return nil
    }
    
    return value //try? JSONDecoder().decode(T.self, from: userData)
}


//MARK: - user

enum UsersError: Error {
    case userNotFound
    case noUsers
    case castError
    case keyProblem
    case serverError
}

func getUsers(completion: @escaping (Result<Users, UsersError>) -> Void) {
    let database = Database.database().reference()
    database.child("users").getData(completion: {
        error, snapshot in
        guard error == nil else {
            return completion(.failure(.serverError))
        }
        
        guard let usersMap = snapshot.value as? [String: Any] else {
            return completion(.failure(.castError))
        }
        
        var users = Users()
        
        for (_, value) in usersMap {
            guard
                let value = value as? Dict,
                let user: User = convertToStruct(value: value)
            else { continue }
            users.append(user)
        }
        completion(.success(users))
    })
}

func addUser(_ user: User, completion: ((User?, UsersError?) -> Void)? = nil) {
    let database = Database.database().reference().child("users")
    guard let key = database.childByAutoId().key else { completion?(nil, .keyProblem); return }
    var _user = user
    _user.key = key
    guard let userDict = convertToDict(value: _user) else { completion?(nil, .castError); return }
    database.child(key).setValue(userDict, withCompletionBlock: { _, _ in  completion?(_user, nil) })
}

func checkIsUserValid(key: String, completion: @escaping (Result<Bool, Error>) -> Void) {
    getUsers(completion: {
        result in
        switch result {
        case .success(let users):
            print("users is")
            print(users)
            for _user in users {
                if _user.key == key {
                    completion(.success(true))
                    return
                }
            }
            completion(.success(false))
            break
        case .failure(let error):
            print("isuservalid \(error)")
            completion(.failure(error))
            break
        }
    })
}

func findUser(name: String, completion: @escaping (Result<User, Error>) -> Void) {
    getUsers(completion: {
        result in
        switch result {
        case .success(let users):
            for user in users {
                print(user.name + " " + name)
                
                if user.name == name { return completion(.success(user)) }
            }
            completion(.failure(UsersError.userNotFound))
            break
        case .failure(let error):
            print("findUser: error \(error)")
            completion(.failure(error))
            break
        }
    })
}

//MARK: - art

enum ArtError: Error {
    case userNotFound
    case artNotFound
    case keyProblem
    case castError
}

func addArt(_ art: Art, user: User, completion: ((Art?, ArtError?) -> Void)? = nil) {
    let artsRef = Database.database().reference().child("arts")
    guard let key = artsRef.childByAutoId().key else {
        completion?(nil, .keyProblem); return
    }
    var _art = art
    _art.key = key
    _art.userKey = user.key
    guard let artDict = convertToDict(value: _art) else { completion?(nil, .castError); return }
    artsRef.child(key).setValue(artDict, withCompletionBlock: {
        _, _ in
        completion?(_art, nil)
    })
}

func getArts(completion: @escaping (Result<Arts, ArtError>) -> Void) {
    let artsRef = Database.database().reference().child("arts")
    artsRef.getData(completion: {
        error, snapshot in
        guard let artMap = snapshot.value as? Dict else { return completion(.failure(.castError)) }
        
        var arts = Arts()
        
        for (_, value) in artMap {
            guard
                let value = value as? Dict,
                let art: Art = convertToStruct(value: value)
            else {
                return completion(.failure(.castError))
            }
            arts.append(art)
        }
 
        completion(.success(arts))
    })
}

func getArts(for user: User, completion: @escaping (Result<Arts, ArtError>) -> Void) {
    getArts(completion: {
        result in
        switch result {
        case.success(let arts):
            var arr = Arts()
            for art in arts where art.userKey == user.key {
                arr.append(art)
            }
            completion(.success(arr))
            break
        case .failure(let error):
            completion(.failure(error))
            break
        }
    })
}

func updateArt(_ art: Art) {
    let artsRef = Database.database().reference().child("arts")
    guard let dict = convertToDict(value: art) else { return }
    artsRef.child(art.key).setValue(dict)
}

func removeArt(_ art: Art) {
    let artsRef = Database.database().reference().child("arts")
    artsRef.child(art.key).removeValue()
}
