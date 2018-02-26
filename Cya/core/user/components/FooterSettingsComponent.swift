//
//  FooterSettingsComponent.swift
//  Cya
//
//  Created by Cristopher Torres on 11/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class FooterSettingsComponent: UIView {
    
    var termsConditionsButton: UIButton = UIButton(type: .system) as UIButton
    var aboutCyaButton: UIButton = UIButton(type: .system) as UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FooterSettingsComponent{
    
    func setUpView(){
        
        self.addSubview(termsConditionsButton)
        self.addSubview(aboutCyaButton)
        
        termsConditionsButton.translatesAutoresizingMaskIntoConstraints = false
        aboutCyaButton.translatesAutoresizingMaskIntoConstraints = false
        
        termsConditionsButton.layer.masksToBounds = true
        termsConditionsButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        termsConditionsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        termsConditionsButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 8).isActive = true
        termsConditionsButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        termsConditionsButton.titleLabel?.font = FontCya.CyaTitlesH5Light
        termsConditionsButton.setTitleColor(.Cya_Event_List_Live_Text_Shadow_Color, for: .normal)
        termsConditionsButton.addTarget(self, action: #selector(termsButtonAction), for: .touchUpInside)
        termsConditionsButton.setTitle("Terms & Conditions", for: .normal)
        termsConditionsButton.contentHorizontalAlignment = .right
        
        
        aboutCyaButton.layer.masksToBounds = true
        aboutCyaButton.leftAnchor.constraint(equalTo: termsConditionsButton.rightAnchor, constant: 10).isActive = true
        aboutCyaButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        aboutCyaButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        aboutCyaButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
        
        aboutCyaButton.titleLabel?.font = FontCya.CyaTitlesH5Light
        aboutCyaButton.setTitleColor(.Cya_Event_List_Live_Text_Shadow_Color, for: .normal)
        aboutCyaButton.addTarget(self, action: #selector(aboutButtonAction), for: .touchUpInside)
        aboutCyaButton.setTitle(" About Cya Inc.", for: .normal)
        aboutCyaButton.contentHorizontalAlignment = .left
    }
    
    @objc func termsButtonAction(){
        if let url = URL(string: "https://www.synaptop.com/terms/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func aboutButtonAction(){
        if let url = URL(string: "https://www.synaptop.com/about/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
}

