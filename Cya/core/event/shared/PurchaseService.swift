//
//  PurchaseService.swift
//  Cya
//
//  Created by Rigo on 15/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class PurchaseService {
    
    let appConfig: NSMutableDictionary
    let purchaseUrl: String
    var error: NSError?
    
    init(){
        
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        purchaseUrl = appConfig.value(forKey: "purchaseUrl") as! String 
        
    }
    

    func payByStripe(payByStripeData: OrderFormDisplayObject) -> AnyObject{
        let url = "\(purchaseUrl)/purchase/stripe"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(payByStripeData)
            request.httpBody = jsonData
        }catch let err{
            print(err)
        }
        
        var resultObservert: AnyObject?
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    print( String(data: data!, encoding: String.Encoding.utf8) as String!)
                    
                    resultObservert = data as AnyObject
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
            return resultObservert!
        }
    }

    
    func payByRSVP(payByRSVPData: OrderFormPayByRSVPDisplayObject) -> AnyObject{
        
        let url = "\(purchaseUrl)/purchase/rsvp"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        do{
            let jsonEncoder = JSONEncoder()
            let jsonData = try jsonEncoder.encode(payByRSVPData)
            request.httpBody = jsonData
        }catch let err{
            print(err)
        }
        
        var resultObservert: AnyObject?
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    print( String(data: data!, encoding: String.Encoding.utf8) as String!)
                    resultObservert = data as AnyObject
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
            return resultObservert!
        }
    }
    
    
    func getTicketUser(eventId: String, userId: String)throws -> StatusDisplayObject{
        self.error = nil
        let url = "\(purchaseUrl)/tickets/\(eventId)/\(userId)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var ticketUser: StatusDisplayObject?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                try ErrorHelper.validateRequestError(data: data!, res: res!)
                ticketUser = try JSONDecoder().decode(StatusDisplayObject.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                self.error = err as NSError
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        if(self.error != nil){
            throw self.error!
        }
        
        return ticketUser!
    }
    
    
}

class StatusDisplayObject:  Decodable, Encodable {
    
    var status: Bool?
}
    
    



