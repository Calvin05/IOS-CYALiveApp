//
//  EventContentDisplayObject.swift
//  Cya
//
//  Created by Cristopher Torres on 03/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class EventContentDisplayObject: Decodable {
    
    var mod: Bool?
    var host: Bool?
    var star: Bool?
    var token: String?
    var contents: [ContentDisplayObject]? = []
    var services: [EventServiceDisplayObject]? = []
    
}
