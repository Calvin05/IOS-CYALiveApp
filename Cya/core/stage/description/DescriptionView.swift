//
//  DescriptionView.swift
//  Cya
//
//  Created by Rigo on 07/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import Foundation


class DescriptionView: UIView {
    
    var textLabel: UITextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrenView(data:String) {
        textLabel.attributedText = data.convertHtml()
        textLabel.textColor = UIColor.cyaWhite
        textLabel.font =  FontCya.CyaBody
        textLabel.textAlignment = .justified
        textLabel.backgroundColor = UIColor.clear
    }
  

}

extension DescriptionView {
    
    func setupView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        let marginGuide = self.layoutMarginsGuide
        self.addSubview(textLabel)
        
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        textLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        textLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        textLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        textLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor).isActive = true
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        textLabel.sizeToFit()
        
//        textLabel.leftTextInset     = 10
//        textLabel.rightTextInset    = 10
//        textLabel.bottomTextInset   = 5
//        textLabel.topTextInset      = 5
//
        self.backgroundColor = UIColor.cyaDarkBg

    }

}

