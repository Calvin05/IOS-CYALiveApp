//
//  PayByStripeDisplayObject.swift
//  Cya
//
//  Created by Rigo on 16/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
class PayByStripeDisplayObject: Codable {
    
        
        var stripeToken: String?
        var rawPrice: String?
        var quantity: Int?
        var finalPrice: String?
        var currency: String?
        var userId: String?
        var eventId: String?

}
