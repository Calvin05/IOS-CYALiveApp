//
//  AuthService.swift
//  Cya
//
//  Created by Cristopher Torres on 17/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class AuthService {
    
    let appConfig: NSMutableDictionary
    let authApiUrl: String
    var error: NSError?
    
    init(){
        
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        authApiUrl = appConfig.value(forKey: "authApiUrl") as! String
        
    }
    
    func login(email: String, password: String) -> LoginDisplayObject{
        
        let json: [String: Any] = ["email": email, "password": password ]
        
        let url = "\(authApiUrl)/login"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        var loginDisplayObject: LoginDisplayObject = LoginDisplayObject()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                loginDisplayObject = try JSONDecoder().decode(LoginDisplayObject.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return loginDisplayObject
        
    }
    
    func facebookLogin(token: String) -> LoginDisplayObject{
        
        let json: [String: Any] = ["access_token": token]
        
        let url = "\(authApiUrl)/login/facebook"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        var loginDisplayObject: LoginDisplayObject = LoginDisplayObject()
        
        let semaphore = DispatchSemaphore(value: 0)
        var resStatusCode = 200
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    loginDisplayObject = try JSONDecoder().decode(LoginDisplayObject.self, from: data!)
                }
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return loginDisplayObject
        
    }
    
    func googleLogin(token: String) -> LoginDisplayObject{
        
        let json: [String: Any] = ["access_token": token]
        
        let url = "\(authApiUrl)/login/google"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        var loginDisplayObject: LoginDisplayObject = LoginDisplayObject()
        
        let semaphore = DispatchSemaphore(value: 0)
        var resStatusCode = 200
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    loginDisplayObject = try JSONDecoder().decode(LoginDisplayObject.self, from: data!)
                }
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return loginDisplayObject
        
    }
    
    func register(userRegister: UserRegisterDisplayObject) -> AnyObject{
        
        let url = "\(authApiUrl)/register"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(userRegister)
            request.httpBody = jsonData
        }catch let err{
            print(err)
        }
        
        var loginDisplayObject: LoginDisplayObject = LoginDisplayObject()
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    loginDisplayObject = try JSONDecoder().decode(LoginDisplayObject.self, from: data!)
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
            return loginDisplayObject
        }
    }
    
    func passwordReset(email: String) throws -> AnyObject{
        
        let url = "\(authApiUrl)/password/reset"
        var request = URLRequest(url: URL(string: url)!)
        
        let json: [String: Any] = ["email": email]
        
        request.httpMethod = "POST"
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    try self.setErrorMessage(data: data!)
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
            throw self.error!
        }else{
            return true as AnyObject
        }
    }
    
    func setErrorMessage(data: Data)throws {
        let errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data)
        var errorMessage = ""
        
        if (errorResponse.code != nil || errorResponse.statusCode != nil){
            errorMessage = errorResponse.message!
        }else{
            errorMessage = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
        }
        
        self.error = NSError(domain: errorMessage, code: 400, userInfo: nil)
    }
    
}
