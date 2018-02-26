//
//  EventListDisplayObject.swift
//  Cya
//
//  Created by Cristopher Torres on 14/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class EventListDisplayObject: Decodable {
    var count: Int?
    var offset: Int?
    var limit: Int?
    var items: [Event]? = []
}
