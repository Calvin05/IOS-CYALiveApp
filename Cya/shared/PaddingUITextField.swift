//
//  PaddingUITextField.swift
//  Cya
//
//  Created by Cristopher Torres on 26/02/18.
//  Copyright © 2018 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

struct PaddingUITextField {
    
    static func getPadding(x: Int, y: Int, width: Int, height: Int) -> UIView{
        let paddingView = UIView(frame: CGRect(x:x, y:y, width:width, height:height))
        
        return paddingView
    }
}

