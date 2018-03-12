//
//  ErrorHelper.swift
//  Cya
//
//  Created by Cristopher Torres on 12/02/18.
//  Copyright © 2018 Cristopher Torres. All rights reserved.
//

import Foundation

struct ErrorHelper {
    
    private static var error: NSError?
    
    static func validateRequestError(data: Data, res: URLResponse)throws{
        var resStatusCode = 200
        
        resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
        if(resStatusCode != 200){
            try self.setErrorMessage(data: data)
        }
    }
    
    static func setErrorMessage(data: Data)throws {
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var errorMessage = ""
        
        do{
            errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data)
            
            if (errorResponse.code != nil || errorResponse.statusCode != nil){
                errorMessage = errorResponse.message!
            }else{
                errorMessage = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
            }
            
            self.error = NSError(domain: errorMessage, code: 400, userInfo: nil)
            
        }catch {
            errorMessage = "Connection Error"
            self.error = NSError(domain: errorMessage, code: 400, userInfo: nil)
            throw self.error!
        }
        
        throw self.error!
    }
    
    static func setCustomErrorMessage(message: String) {
        self.error = NSError(domain: message, code: 400, userInfo: nil)
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
