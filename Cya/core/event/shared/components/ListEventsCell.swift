//
//  ListEventsCell.swift
//  Cya
//
//  Created by Rigo on 03/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

class ListEventsCell:  UITableViewCell {
    
    var viewContent: UIView = UIView()
    var imageAvatar: UIImageView = UIImageView()
    var dateContainer: UIView = UIView()
    var monthEvent: EdgeInsetLabel = EdgeInsetLabel()
    var dayEvent: EdgeInsetLabel = EdgeInsetLabel()
	var titleEvent: EdgeInsetLabel = EdgeInsetLabel()
	var descriptionEvent: EdgeInsetLabel = EdgeInsetLabel()
    var featuringLabel: EdgeInsetLabel = EdgeInsetLabel()
    var featuringLine: UIView = UIView()
    var contentRoles : UIView = UIView()
    var avatarRoles: AvatarView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)  
    }
    
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
        setupViewMaster()
        setupViewContent()
        setupImageAvatar()
        setupTimeEvent()
        setupTitleEvent()
//        setupDescriptionEvent()
        setupRoles()
    }
}

extension ListEventsCell {
    
    func setupViewMaster(){
        contentView.layer.shadowColor = UIColor.lightGray.cgColor
        contentView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        contentView.layer.shadowOpacity = 0.7
        contentView.layer.shadowRadius = 10
    }

    func setupViewContent(){
        
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        contentView.addSubview(viewContent)
        
        let marginGuide = contentView.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: 0).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -10).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 10).isActive = true
        
        viewContent.backgroundColor = UIColor.Cya_Placeholder_Background_Color
        viewContent.layer.borderColor = UIColor.lightGray.cgColor
        viewContent.layer.borderWidth = 0
        viewContent.layer.cornerRadius = 0
        viewContent.layer.masksToBounds = true
        
    }
    
    func setupImageAvatar(){
        viewContent.addSubview(imageAvatar)

        imageAvatar.translatesAutoresizingMaskIntoConstraints       = false
        
        imageAvatar.heightAnchor.constraint(equalToConstant: 205).isActive = true
        imageAvatar.widthAnchor.constraint(equalTo: viewContent.widthAnchor, constant: 0).isActive = true
        imageAvatar.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        imageAvatar.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        imageAvatar.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        
        imageAvatar.image = UIImage(named: "thumb-logo")
    }
    
    func setupTimeEvent(){
        
        viewContent.addSubview(dateContainer)
        dateContainer.addSubview(monthEvent)
        dateContainer.addSubview(dayEvent)
        
        
        dateContainer.translatesAutoresizingMaskIntoConstraints = false
        monthEvent.translatesAutoresizingMaskIntoConstraints = false
        dayEvent.translatesAutoresizingMaskIntoConstraints = false
        
        
        dateContainer.topAnchor.constraint(equalTo: imageAvatar.bottomAnchor, constant: 0).isActive = true
        dateContainer.leftAnchor.constraint(equalTo:imageAvatar.leftAnchor, constant: 0).isActive = true
        dateContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dateContainer.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        
        monthEvent.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 12).isActive = true
        monthEvent.centerXAnchor.constraint(equalTo:dateContainer.centerXAnchor, constant: 0).isActive = true
        
        monthEvent.textColor = UIColor.gray
        monthEvent.font = FontCya.CyaTitlesH4
        monthEvent.numberOfLines = 0
        monthEvent.lineBreakMode = .byWordWrapping
        monthEvent.sizeToFit()
//        monthEvent.layer.shadowOpacity = 0
        
        
        dayEvent.topAnchor.constraint(equalTo: monthEvent.bottomAnchor, constant: 0).isActive = true
        dayEvent.centerXAnchor.constraint(equalTo:dateContainer.centerXAnchor, constant: 0).isActive = true
        
        dayEvent.textColor = UIColor.cyaMagenta
        dayEvent.font = FontCya.CyaMontRegS22
        dayEvent.numberOfLines = 0
        dayEvent.lineBreakMode = .byWordWrapping
        dayEvent.sizeToFit()
//        dayEvent.layer.shadowOpacity = 0
        
    }
    func setupTitleEvent(){
        viewContent.addSubview(titleEvent)
        
        titleEvent.translatesAutoresizingMaskIntoConstraints        = false
        
        titleEvent.topAnchor.constraint(equalTo: imageAvatar.bottomAnchor, constant: 15).isActive = true
        titleEvent.leftAnchor.constraint(equalTo:dateContainer.rightAnchor, constant: 5).isActive = true
        titleEvent.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        titleEvent.textColor = UIColor.Cya_Event_List_Event_Title_Text_Color
        titleEvent.numberOfLines = 0
        titleEvent.lineBreakMode = .byWordWrapping
        titleEvent.sizeToFit()
        titleEvent.font = FontCya.CyaTitlesH2

        
    }
//    func setupDescriptionEvent(){
//        viewContent.addSubview(descriptionEvent)
//
//        descriptionEvent.translatesAutoresizingMaskIntoConstraints  = false
//
//        descriptionEvent.topAnchor.constraint(equalTo: titleEvent.bottomAnchor, constant: 5).isActive = true
//        descriptionEvent.leftAnchor.constraint(equalTo:TimeEvent.leftAnchor, constant: 0).isActive = true
//        descriptionEvent.rightAnchor.constraint(equalTo:viewContent.rightAnchor, constant: -10).isActive = true
//
//        descriptionEvent.textColor = UIColor.cyaLightGrayText
//        descriptionEvent.numberOfLines = 0
//        descriptionEvent.lineBreakMode = .byWordWrapping
//        descriptionEvent.sizeToFit()
//    }
    
    func setupRoles(){
        
        viewContent.addSubview(featuringLine)
        viewContent.addSubview(featuringLabel)
        viewContent.addSubview(contentRoles)
        
        
        contentRoles.translatesAutoresizingMaskIntoConstraints    = false
        featuringLabel.translatesAutoresizingMaskIntoConstraints    = false
        featuringLine.translatesAutoresizingMaskIntoConstraints    = false
        
        
        featuringLine.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 10).isActive = true
        featuringLine.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        featuringLine.topAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: 10).isActive = true
        featuringLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        featuringLine.backgroundColor = UIColor.lightGray
        
        
        featuringLabel.centerYAnchor.constraint(equalTo: featuringLine.centerYAnchor, constant: 0).isActive = true
        featuringLabel.centerXAnchor.constraint(equalTo:featuringLine.centerXAnchor, constant: 0).isActive = true
        
        featuringLabel.textColor = UIColor.gray
        featuringLabel.font = FontCya.CyaTextNameAvatar
        featuringLabel.numberOfLines = 0
        featuringLabel.lineBreakMode = .byWordWrapping
        featuringLabel.sizeToFit()
//        featuringLabel.layer.shadowOpacity = 0
        featuringLabel.text = "FEATURING"
        
        
        contentRoles.topAnchor.constraint(equalTo: featuringLabel.bottomAnchor, constant: 5).isActive = true
        contentRoles.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contentRoles.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        contentRoles.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        
        contentRoles.backgroundColor = UIColor.cyaLightGrayBg
        
        
//        avatarRoles!.view.translatesAutoresizingMaskIntoConstraints = false
//        
//        avatarRoles!.view.topAnchor.constraint(equalTo: contentRoles.topAnchor, constant: 0).isActive = true
//        avatarRoles!.view.leftAnchor.constraint(equalTo: contentRoles.leftAnchor, constant: 0).isActive = true
//        avatarRoles!.view.rightAnchor.constraint(equalTo: contentRoles.rightAnchor, constant: 0).isActive = true
//        avatarRoles!.view.bottomAnchor.constraint(equalTo: contentRoles.bottomAnchor, constant: 0).isActive = true
        
        
    }

}










