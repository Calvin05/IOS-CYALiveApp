//
//  ChatMessageDisplayObject.swift
//  Cya
//
//  Created by Cristopher Torres on 28/09/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class ChatMessageDisplayObject: Decodable, Encodable {

    var id: String?
    var chat_id: String?
    var content: String?
    var created_time: String?
    var user_id: String?
    var profile: ChatProfileDisplayObject?
    
}
