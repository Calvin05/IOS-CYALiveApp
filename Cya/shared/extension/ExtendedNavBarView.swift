//
//  ExtendedNavBarView.swift
//  Cya
//
//  Created by Rigo on 28/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//
import Foundation
import UIKit

class ExtendedNavBarView: UIView {
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        layer.shadowOffset = CGSize(width: 0, height: CGFloat(1) / UIScreen.main.scale)
        layer.shadowRadius = 0
        
        layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        layer.shadowOpacity = 0.25
    }
}

