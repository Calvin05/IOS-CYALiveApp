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
    
    func paddingUITextField(x: Int, y: Int, width: Int, height: Int) -> UIView{
        let paddingView = UIView(frame: CGRect(x:x, y:y, width:width, height:height))
        
        return paddingView
    }
    
    func setTextFieldProfile(){
        
        self.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        self.layer.masksToBounds = true
        self.font = FontCya.CyaTitlesH3
        self.textColor = UIColor.cyaMagenta
        self.textAlignment = .left
        self.backgroundColor = UIColor.white
        self.layer.cornerRadius = 11
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
        
        self.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.frame.height))
        self.leftViewMode = UITextFieldViewMode.always

        self.rightView = paddingUITextField(x: 0, y: 0, width: 12, height: Int(self.frame.height))
        self.rightViewMode = UITextFieldViewMode.always
        
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

