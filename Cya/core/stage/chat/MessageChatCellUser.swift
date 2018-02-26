//
//  MessageChatCellUser.swift
//  Cya
//
//  Created by Rigo on 28/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

class MessageChatCellUser: UITableViewCell {
    
    // MARK: -  Label Cell
    let messageLabel: EdgeInsetLabel = EdgeInsetLabel()
    let avatar: UIImageView = UIImageView()
    
    let uvC:UIView = UIView ();
    let uvCir:UIView = UIView();
    
    // MARK: -  Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  Views -  Config
    fileprivate func setupView(){
        constraintComponent()
        configComponents()
    }
    
}


// MARK: Constraint
extension MessageChatCellUser {
    func constraintComponent(){
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(messageLabel)
        messageLabel.addSubview(avatar)
        
        contentView.addSubview(uvC)
        uvC.addSubview(uvCir)
        
        
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        
        messageLabel.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 90).isActive = true
        
        avatar.topAnchor.constraint(equalTo: messageLabel.topAnchor, constant: 6).isActive = true
        avatar.rightAnchor.constraint(equalTo:messageLabel.leftAnchor, constant: 26).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 20).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        uvC.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -20).isActive = true
        uvC.rightAnchor.constraint(equalTo:messageLabel.rightAnchor, constant: 15).isActive = true
        uvC.widthAnchor.constraint(equalToConstant: 20).isActive = true
        uvC.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        uvCir.rightAnchor.constraint(equalTo:uvC.rightAnchor, constant: 15).isActive = true
        uvCir.topAnchor.constraint(equalTo: uvC.topAnchor, constant: -9).isActive = true
        uvCir.widthAnchor.constraint(equalToConstant: 30).isActive = true
        uvCir.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}


// MARK: Config Components
extension MessageChatCellUser {
    func configComponents(){
        self.selectionStyle = .none
        self.selectionStyle = UITableViewCellSelectionStyle.none
        messageLabel.text = ""
        messageLabel.textColor = UIColor.lightGray
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.sizeToFit()
        
        messageLabel.font = FontCya.CyaTitlesH3Light
        
        messageLabel.backgroundColor? = .darkGray
        messageLabel.layer.cornerRadius = 10
        messageLabel.layer.borderWidth = 0
        messageLabel.layer.masksToBounds = true
        
        messageLabel.leftTextInset = 26
        messageLabel.bottomTextInset = 10
        messageLabel.rightTextInset = 30
        messageLabel.topTextInset = 10
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        avatar.backgroundColor = .gray
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 10
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        
        uvC.backgroundColor = .darkGray
        uvC.translatesAutoresizingMaskIntoConstraints = false
        
        uvCir.backgroundColor = .white
        uvCir.layer.masksToBounds = true
        uvCir.layer.cornerRadius = 10
        uvCir.frame.size.width = 20
        uvCir.frame.size.height = 20
        uvCir.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
}
