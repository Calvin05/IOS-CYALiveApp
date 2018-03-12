//
//  TextFieldExtension.swift
//  Cya
//
//  Created by Rigo on 20/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {
    
    func underline(color: UIColor, borderWidth: CGFloat) {
        let border = CALayer()
        
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - borderWidth, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = borderWidth
        
        
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
//    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.view.endEditing(true)
//        return true
//    }
//    
//
//    func setDelegate(textField: UITextField) {
//        textField.delegate = self
//    }
//    
//    public func textFieldDidBeginEditing(_ textField: UITextField) {
//        self.activeTextField = textField
//    }
//    
//    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        self.activeTextField = textField        
//        return true
//    }

}

