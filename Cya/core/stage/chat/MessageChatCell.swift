//
//  MessageChatCell.swift
//  Cya
//
//  Created by Rigo on 18/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class MessageChatCell: UITableViewCell {

// MARK: -  Label Cell
    let userNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    let messageLabel: EdgeInsetLabel = EdgeInsetLabel()
    let avatar: UIImageView = UIImageView()
    
//    let uvC:UIView = UIView ();
//    let uvCir:UIView = UIView();
    
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
extension MessageChatCell {
    func constraintComponent(){
        let marginGuide = contentView.layoutMarginsGuide
        contentView.addSubview(messageLabel)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(avatar)
        
//        contentView.addSubview(uvC)
//        uvC.addSubview(uvCir)
        
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        avatar.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 6).isActive = true
        avatar.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: 0).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 26).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 26).isActive = true
        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -10).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 5).isActive = true
        
        
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        messageLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: -10).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 5).isActive = true
        
        
//        uvC.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: -20).isActive = true
//        uvC.leftAnchor.constraint(equalTo:messageLabel.leftAnchor, constant: -15).isActive = true
//        uvC.widthAnchor.constraint(equalToConstant: 20).isActive = true
//        uvC.heightAnchor.constraint(equalToConstant: 20).isActive = true
//
//        uvCir.leftAnchor.constraint(equalTo:uvC.leftAnchor, constant: -15).isActive = true
//        uvCir.topAnchor.constraint(equalTo: uvC.topAnchor, constant: -9).isActive = true
//        uvCir.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        uvCir.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}


 // MARK: Config Components
extension MessageChatCell {
    func configComponents(){
        
        self.selectionStyle = .none
        self.selectionStyle = UITableViewCellSelectionStyle.none
        
        userNameLabel.text = "Question Massage"
        userNameLabel.textColor = UIColor.lightGray
        userNameLabel.numberOfLines = 0
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.sizeToFit()
        userNameLabel.font = UIFont(name: "Avenir-Book", size: 13)
        userNameLabel.backgroundColor? = .clear
        
        messageLabel.text = "Question Massage"
        messageLabel.textColor = UIColor.white
        messageLabel.numberOfLines = 0
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.sizeToFit()
        
        messageLabel.font = UIFont(name: "Avenir-Book", size: 15)
        
        messageLabel.backgroundColor? = .clear
//        messageLabel.layer.cornerRadius = 10
//        messageLabel.layer.borderWidth = 0
//        messageLabel.layer.masksToBounds = true
        
        messageLabel.leftTextInset = 30
        messageLabel.bottomTextInset = 10
        messageLabel.rightTextInset = 10
        messageLabel.topTextInset = 0
   
        

        avatar.backgroundColor = .clear
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 13
        
        
//        uvC.backgroundColor = .lightGray
//        uvC.translatesAutoresizingMaskIntoConstraints = false
//
//        uvCir.backgroundColor = .white
//        uvCir.layer.masksToBounds = true
//        uvCir.layer.cornerRadius = 10
//        uvCir.frame.size.width = 20
//        uvCir.frame.size.height = 20
//        uvCir.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
}
