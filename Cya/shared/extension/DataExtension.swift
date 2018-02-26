//
//  DataExtension.swift
//  Cya
//
//  Created by Cristopher Torres on 15/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
