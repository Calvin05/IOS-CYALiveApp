//
//  UserIdNumber.swift
//  Cya
//
//  Created by Cristopher Torres on 11/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

import Foundation

class UserIdNumber: Decodable, Encodable {
    
    var user_id: Int?
    var username: String?
    var avatar: String?
    var first_name: String?
    var last_name: String?
    var notes: String?
    var dob: String?
    var gender: String?
    var deleted: Int?
    
}
