//
//  ViewAvatarInfoDetail.swift
//  Cya
//
//  Created by Rigo on 16/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class ViewAvatarInfoDetail: UIView {
    

    var avatar: UIImageView = UIImageView()
    var star:  UIImageView = UIImageView()
    var userName : EdgeInsetLabel =  EdgeInsetLabel()
    var company : EdgeInsetLabel =  EdgeInsetLabel()
    
    var heighAvatar: Float = 0.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
                setupViewAvatar()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}


extension ViewAvatarInfoDetail {
    
    func setupViewAvatar(){
        
        self.addSubview(avatar)
        self.addSubview(star)
        self.addSubview(userName)
        self.addSubview(company)
        
        settingsViews()
        constraintViews()
        
    }
    
    func settingsViews(){
        
        self.backgroundColor = UIColor.clear
        
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        avatar.translatesAutoresizingMaskIntoConstraints = false
        star.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        company.translatesAutoresizingMaskIntoConstraints = false
        
        
        userName.textAlignment = .center
        userName.font = FontCya.CyaTextNameAvatar
        userName.textColor = .darkGray
        userName.numberOfLines = 0
        userName.lineBreakMode = .byWordWrapping
        userName.sizeToFit()
        userName.translatesAutoresizingMaskIntoConstraints = false
        
        company.textAlignment = .center
        company.font = FontCya.CyaTextNameAvatar
        company.textColor = .darkGray
        company.numberOfLines = 0
        company.lineBreakMode = .byWordWrapping
        company.sizeToFit()
        company.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configViews(data: Role){

        if data.avatar != nil && data.avatar != "" {
            avatar.downloadedFrom(link: data.avatar!)
        } else {
            avatar.backgroundColor = UIColor.clear
        }
        
        if data.role != nil && data.role != "" {
            star.image = UIImage(named: "start")
        } else {
            star.backgroundColor = UIColor.clear
        }
  
        if data.first_name != nil && data.first_name != "" {
            userName.text = "\(data.first_name!)"
        } else {
            userName.text = ""
        }
        
        if data.last_name != nil && data.last_name != "" {
            company.text = "\(data.last_name!)"
        } else {
            company.text = ""
        }
    }
    
    
    func constraintViews(){
        
        avatar.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        avatar.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        avatar.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        avatar.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true
        avatar.heightAnchor.constraint(equalTo: self.widthAnchor, constant: 0).isActive = true

        star.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5).isActive = true
        star.widthAnchor.constraint(equalToConstant: 10).isActive = true
        star.heightAnchor.constraint(equalToConstant: 10).isActive = true
        star.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        userName.topAnchor.constraint(equalTo: star.bottomAnchor, constant: 5).isActive = true
        userName.leftAnchor.constraint(equalTo: avatar.leftAnchor, constant: 0).isActive = true
        userName.rightAnchor.constraint(equalTo: avatar.rightAnchor, constant: 0).isActive = true
        
        company.topAnchor.constraint(equalTo: userName.bottomAnchor, constant: 1).isActive = true
        company.leftAnchor.constraint(equalTo: avatar.leftAnchor, constant: 0).isActive = true
        company.rightAnchor.constraint(equalTo: avatar.rightAnchor, constant: 0).isActive = true
    }
}

extension ViewAvatarInfoDetail {

}




