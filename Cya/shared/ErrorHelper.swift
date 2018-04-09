//
//  ErrorHelper.swift
//  Cya
//
//  Created by Cristopher Torres on 12/02/18.
//  Copyright © 2018 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

struct ErrorHelper {
    
    static var error: NSError?
    
    static func validateRequestError(data: Data?, res: URLResponse?)throws{
        var resStatusCode = 200
        
        if(res == nil){
            setConnectionError()
            throw self.error!
        }else{
            resStatusCode = ((res! as? HTTPURLResponse)?.statusCode)!
        }
        
        if(resStatusCode == 500){
            setGeneralApiError()
            throw self.error!
        }else if(resStatusCode != 200){
            try self.setErrorMessage(data: data)
        }
        
    }
    
    static func setErrorMessage(data: Data?)throws {
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var errorMessage = ""
        
        do{
            if(data == nil){
                throw NSError()
            }
            errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
            
            if (errorResponse.code != nil || errorResponse.statusCode != nil){
                errorMessage = errorResponse.message!
            }else{
                errorMessage = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
            }
            
            self.error = NSError(domain: errorMessage, code: 400, userInfo: nil)
            
        }catch {
            setGeneralApiError()
            throw self.error!
        }
        
        throw self.error!
    }
    
    static func setCustomErrorMessage(message: String) {
        self.error = NSError(domain: message, code: 400, userInfo: nil)
    }
    
    static func setConnectionError(){
        self.error = NSError(domain: "Connection Error", code: 500, userInfo: nil)
    }
    
    static func setGeneralApiError(){
        self.error = NSError(domain: "Cannot complete this command. Please try again later", code: 500, userInfo: nil)
    }
    
    static func showAlert() -> UIAlertController{
        let alert = UIAlertController()
        alert.title = "Error"
        alert.message = self.error?.domain
        
        let alertController = UIAlertController(title: "Error", message: self.error?.domain, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        return alertController
    }
    
    
}
