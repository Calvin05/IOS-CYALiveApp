//
//  AvatarCell.swift
//  Cya
//
//  Created by Rigo on 11/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import  UIKit

class AvatarCell: UICollectionViewCell{
    
    var avatarContent : UIView = UIView()
    var avatar: UIImageView = UIImageView()
    var firstName: EdgeInsetLabel = EdgeInsetLabel()
    var lastName: EdgeInsetLabel = EdgeInsetLabel()
    var star:  UIImageView = UIImageView()
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        contentView.addSubview(avatarContent)
        avatarContent.addSubview(avatar)
        avatarContent.addSubview(firstName)
        avatarContent.addSubview(lastName)
        
        avatarContent.translatesAutoresizingMaskIntoConstraints = false
        avatarContent.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 1).isActive = true
        avatarContent.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -1).isActive = true
        avatarContent.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -1).isActive = true
        avatarContent.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 1).isActive = true
        avatarContent.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        
        
        let wAvatar = self.frame.width-2
        
        avatar.topAnchor.constraint(equalTo: avatarContent.topAnchor, constant: 1).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 56).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 56).isActive = true
        avatar.centerXAnchor.constraint(equalTo: avatarContent.centerXAnchor).isActive = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        avatar.layer.masksToBounds = true
        avatar.image = UIImage(named: "profile")
        avatar.contentMode = .scaleAspectFill
        //        avatar.layer.cornerRadius = wAvatar/2
        avatar.layer.borderWidth = 0
        avatar.layer.cornerRadius = 28
        avatar.layer.masksToBounds = true
        
//        self.addSubview(star)
//
//        star.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 10).isActive = true
//        star.widthAnchor.constraint(equalToConstant: 10).isActive = true
//        star.heightAnchor.constraint(equalToConstant: 10).isActive = true
//        star.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
//        star.translatesAutoresizingMaskIntoConstraints = false
        
        firstName.translatesAutoresizingMaskIntoConstraints = false
        firstName.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 12).isActive = true
        firstName.centerXAnchor.constraint(equalTo: avatarContent.centerXAnchor, constant: 0).isActive = true
        
        firstName.text = ""
        firstName.font = FontCya.CyaTextNameAvatar
        firstName.textColor = .darkGray
        firstName.numberOfLines = 0
        firstName.textAlignment = .center
        firstName.lineBreakMode = .byWordWrapping
        firstName.sizeToFit()
        
        lastName.translatesAutoresizingMaskIntoConstraints = false
        lastName.topAnchor.constraint(equalTo: firstName.bottomAnchor, constant: 2).isActive = true
        lastName.centerXAnchor.constraint(equalTo: avatarContent.centerXAnchor, constant: 0).isActive = true
        
        lastName.text = ""
        lastName.font = FontCya.CyaTextNameAvatar
        lastName.textColor = .darkGray
        lastName.numberOfLines = 0
        lastName.textAlignment = .center
        lastName.lineBreakMode = .byWordWrapping
        lastName.sizeToFit()
    }
}

