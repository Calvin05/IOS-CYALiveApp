//
//  UserService.swift
//  Cya
//
//  Created by Cristopher Torres on 12/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class UserService{
    
    let userApiUrl: String
    
    init(){
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        let appConfig = NSMutableDictionary(contentsOfFile: path!)!
        userApiUrl = appConfig.value(forKey: "userApiUrl") as! String
    }
    
    func getUserById2(userId: String, handler: @escaping (User?, String?) -> Void){
        var user: User = User()
        
        let url = "\(userApiUrl)/\(userId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                user = try JSONDecoder().decode(User.self, from: data!)
                handler(user, "Error")
            } catch let err{
                print(err)
                handler(nil, "Error")
            }
        }
        tarea.resume()
    }
    
    func getUserById(userId: String)-> User{
        var user: User = User()
        
        let url = "\(userApiUrl)/\(userId)"
        
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                user = try JSONDecoder().decode(User.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return user
    }
    
    func userUpdate(user: User) -> AnyObject{
        
        let url = "\(userApiUrl)/\(user.user_id!)"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "PUT"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(user)
            request.httpBody = jsonData
        }catch let err{
            print(err)
        }
        
        var user: UserIdNumber = UserIdNumber()
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    user = try JSONDecoder().decode(UserIdNumber.self, from: data!)
                }
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        if(resStatusCode != 200){
            return errorResponse
        }else{
            return user
        }
    }
    
}

