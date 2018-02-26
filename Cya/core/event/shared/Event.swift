//
//  Event.swift
//  Cya
//
//  Created by Cristopher Torres on 12/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class Event: Decodable {
    
    var id: String?
    var typeMode: String?
    var title: String?
    var slug: String?
    var description: String?
    var copyright: String?
    var timezone: String?
    var start_at: String?
    var end_at: String?
    var trailer: String?
    var cover: String?
    var thumbnail: String?
    var poster: String?
    var isPublic: String?
    var published: Bool?
    var type: Int?
    var tiers: [Tiers]? = []
    var roles: [Role]? = []
//    var restrictions: [String]?
    var ticket: Bool?
}
