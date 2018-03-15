//
//  User.swift
//  Cya
//
//  Created by Cristopher Torres on 12/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class User: Decodable, Encodable {
    
    var user_id: String?
    var username: String?
    var avatar: String?
    var first_name: String?
    var last_name: String?
    var notes: String?
    var dob: String?
    var gender: String?
    var deleted: Int?
    var email: String?
    var password: String?
    
}
