//
//  ChatTableViewCell.swift
//  Cya
//
//  Created by Rigo on 03/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class QuestionsTableViewCell: UITableViewCell {
    
    // MARK: -  Label Cell
    
    
    
    let userNameLabel: UILabel = {
       let label = UILabel()
        label.text = "User Name Text"
        label.textColor = .gray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
 
    let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "Question Massage"
        label.textColor = .black
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.sizeToFit()
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        //label.sizeToFit()
        return label
    }()
    
    let profileImage: UIImageView = {
        let img = UIImageView()
        //img.image? = #imageLiteral(resourceName: "user")
        img.backgroundColor = .gray
        img.layer.cornerRadius = 20
        img.layer.masksToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    
    
    // MARK: -  Init
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: -  Add Views
    fileprivate func setupView(){
        
        
       addSubview(messageLabel)
       addSubview(profileImage)
       addSubview(userNameLabel)
        
     
    
        profileImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        //profileImage.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        profileImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
      
        
    
        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13).isActive = true
        messageLabel.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 10).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 10).isActive = true
        //messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
        userNameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 1).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 2).isActive = true
        			userNameLabel.rightAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 18).isActive = true
        userNameLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
       
    }

}
