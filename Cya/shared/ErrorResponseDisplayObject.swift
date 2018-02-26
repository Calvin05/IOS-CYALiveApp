//
//  ErrorResponseDisplayObject.swift
//  Cya
//
//  Created by Cristopher Torres on 28/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class ErrorResponseDisplayObject: Decodable{
    
    var message: String?
    var name: String?
    var code: Int?
    var statusCode: Int?
    var errors: [SubErrorResponseDisplayObject]?
    
    
}

class SubErrorResponseDisplayObject : Decodable{
    
    var message: String?
    var name: String?
    var code: String?
    var errors: [SubErrorResponseDisplayObject]?
    var description: String?
    
    
}
