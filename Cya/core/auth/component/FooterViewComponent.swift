//
//  FooterViewComponent.swift
//  Cya
//
//  Created by Cristopher Torres on 27/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class FooterViewComponent: UIView {

    var termsButton: UIButton = UIButton(type: .system) as UIButton
    var privacy: UIButton = UIButton(type: .system) as UIButton
    var footerLabel: EdgeInsetLabel = EdgeInsetLabel()
    var fontColor: UIColor = UIColor.gray

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension FooterViewComponent{
    
    func setUpView(){
        
        self.addSubview(termsButton)
        self.addSubview(privacy)
        self.addSubview(footerLabel)
        
        termsButton.translatesAutoresizingMaskIntoConstraints = false
        privacy.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        termsButton.layer.masksToBounds = true
        termsButton.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -7).isActive = true
        termsButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        termsButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        termsButton.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        termsButton.titleLabel?.font = FontCya.CyaTitlesH5Light
        termsButton.setTitleColor(fontColor, for: .normal)
        termsButton.addTarget(self, action: #selector(termsButtonAction), for: .touchUpInside)
        termsButton.setTitle("TERMS OF SERVICE", for: .normal)
        termsButton.contentHorizontalAlignment = .right
        
        
        
        
        privacy.layer.masksToBounds = true
        privacy.bottomAnchor.constraint(equalTo: footerLabel.topAnchor, constant: -7).isActive = true
        privacy.leftAnchor.constraint(equalTo: termsButton.rightAnchor, constant: 0).isActive = true
        privacy.widthAnchor.constraint(equalToConstant: 160).isActive = true
        privacy.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        privacy.titleLabel?.font = FontCya.CyaTitlesH5Light
        privacy.setTitleColor(fontColor, for: .normal)
        privacy.addTarget(self, action: #selector(privacyButtonAction), for: .touchUpInside)
        privacy.setTitle(" ~ PRIVACY POLICY", for: .normal)
        privacy.contentHorizontalAlignment = .left
        
        
        footerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -15).isActive = true
        footerLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        footerLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        footerLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        footerLabel.textColor = fontColor
        footerLabel.numberOfLines = 0
        footerLabel.textAlignment = .center
        footerLabel.lineBreakMode = .byWordWrapping
        footerLabel.sizeToFit()
        footerLabel.text = "Cya Inc. All Rights Reserver. 2017"
        footerLabel.font = FontCya.CyaTitlesH5Light
    }
    
    @objc func termsButtonAction(){
        if let url = URL(string: "https://www.synaptop.com/terms/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func privacyButtonAction(){
        if let url = URL(string: "https://www.synaptop.com/privacy-policy/") {
            UIApplication.shared.open(url, options: [:])
        }
    }
}
