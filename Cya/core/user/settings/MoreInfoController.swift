//
//  MoreInfoController.swift
//  Cya
//
//  Created by Cristopher Torres on 11/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class MoreInfoController: UIViewController {
    
    var viewContent: UIView = UIView()
    let viewHeader: UIView = UIView()
    var settingsLabel: EdgeInsetLabel = EdgeInsetLabel()
    let aspectRatio = AspectRatio(aspect: "HD Video")
    var profileImage: UIImageView = UIImageView()
    var editButton: UIButton = UIButton(type: .system) as UIButton
    
    var labelsContainer: UIView = UIView()
    var nameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var passwordLabel: EdgeInsetLabel = EdgeInsetLabel()
    var dobLabel: EdgeInsetLabel = EdgeInsetLabel()
    var userNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var backButtonView: BackButtonView?
    var footer: FooterSettingsComponent = FooterSettingsComponent()
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    var userService: UserService = UserService()
    var user: User = User()
    
    var dobStr: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateText()
    }
    
    func setDOB(){
        
        if(user.dob != nil){
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            let date = dateFormatter.date(from: user.dob!)
            
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none
            
            dobStr = dateFormatter.string(from: date!)
        }
    }
    
    func updateText(){
        user = userService.getUserById(userId: UserDisplayObject.userId)
        nameLabel.text = "Name: \(user.first_name!) \(user.last_name!)"
        setDOB()
        dobLabel.text = "D.O.B: \(dobStr)"
        userNameLabel.text = "USERNAME: \(user.username!)"
        profileImage.downloadedFrom(defaultImage: "profile", link: user.avatar == nil ? "http://" : user.avatar!, contentMode: .scaleAspectFill)
    }
    
    @objc func editAction(){
        let viewcontroller : EditSettingsController = EditSettingsController()
        self.show(viewcontroller, sender: nil)
    }

}

extension MoreInfoController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.white
        
        setViewContent()
        setHeader()
        setSettingsLabel()
        setLayoutBottomBar()
        setFooter()
        setProfileImage()
        setLabels()
        setEditButton()
        setBackButton()
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.white
    }
    
    func setHeader(){
        
        viewContent.addSubview(viewHeader)
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        
        viewHeader.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        viewHeader.heightAnchor.constraint(equalToConstant: 20).isActive = true
        viewHeader.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        viewHeader.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        viewHeader.backgroundColor = UIColor.white
    }
    
    func setSettingsLabel(){
        viewContent.addSubview(settingsLabel)
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        settingsLabel.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 45).isActive = true
        settingsLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 20).isActive = true
        settingsLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        settingsLabel.textColor = UIColor.black
        settingsLabel.numberOfLines = 0
        settingsLabel.textAlignment = .left
        settingsLabel.lineBreakMode = .byWordWrapping
        settingsLabel.sizeToFit()
        settingsLabel.text = "Settings"
        settingsLabel.font = FontCya.CyaTextButtonRegXL
    }
    
    func setBackButton(){
        
        self.backButtonView = BackButtonView()
        self.backButtonView?.setParent(parent: self)
        viewContent.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: viewContent.topAnchor).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func setProfileImage(){
        
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(self.view.frame.size.width))
        
        viewContent.addSubview(profileImage)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        profileImage.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        profileImage.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        profileImage.layer.masksToBounds = true
        profileImage.downloadedFrom(defaultImage: "profile", link: user.avatar == nil ? "http://" : user.avatar!, contentMode: .scaleAspectFill)
    }
    
    func setEditButton(){
        viewContent.addSubview(editButton)
        
        editButton.translatesAutoresizingMaskIntoConstraints = false
        
        editButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        editButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        editButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -5).isActive = true
        
        editButton.titleLabel?.font = FontCya.CyaTitlesH2Light
        editButton.setTitleColor(.cyaMagenta, for: .normal)
        editButton.addTarget(self, action: #selector(editAction), for: .touchUpInside)
        editButton.setTitle("Edit", for: .normal)
        editButton.contentHorizontalAlignment = .left
    }
    
    func setLabels(){
        
        viewContent.addSubview(labelsContainer)
        labelsContainer.addSubview(nameLabel)
        labelsContainer.addSubview(passwordLabel)
        labelsContainer.addSubview(dobLabel)
        labelsContainer.addSubview(userNameLabel)
        
        labelsContainer.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        labelsContainer.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 20).isActive = true
        labelsContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 20).isActive = true
        labelsContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        labelsContainer.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: -5).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: labelsContainer.topAnchor, constant: 0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: labelsContainer.leftAnchor, constant: 0).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: labelsContainer.rightAnchor, constant: -35).isActive = true
        
        nameLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .left
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.sizeToFit()
        if(user.first_name != nil){
            if(user.last_name != nil){
                nameLabel.text = "Name: \(user.first_name!) \(user.last_name!)"
            }else{
                nameLabel.text = "Name: \(user.first_name!)"
            }
        }else if(user.last_name != nil){
            nameLabel.text = "Name: \(user.last_name!)"
        }
        
        nameLabel.font = FontCya.CyaTitlesH2
        
        
        passwordLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 40).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: labelsContainer.leftAnchor, constant: 0).isActive = true
        passwordLabel.rightAnchor.constraint(equalTo: labelsContainer.rightAnchor, constant: 0).isActive = true
        
        passwordLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        passwordLabel.numberOfLines = 0
        passwordLabel.textAlignment = .left
        passwordLabel.lineBreakMode = .byWordWrapping
        passwordLabel.sizeToFit()
        passwordLabel.text = "PASSWORD: ***************"
        passwordLabel.font = FontCya.CyaTitlesH2
        
        dobLabel.topAnchor.constraint(equalTo: passwordLabel.topAnchor, constant: 40).isActive = true
        dobLabel.leftAnchor.constraint(equalTo: labelsContainer.leftAnchor, constant: 0).isActive = true
        dobLabel.rightAnchor.constraint(equalTo: labelsContainer.rightAnchor, constant: 0).isActive = true
        
        dobLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        dobLabel.numberOfLines = 0
        dobLabel.textAlignment = .left
        dobLabel.lineBreakMode = .byWordWrapping
        dobLabel.sizeToFit()
        dobLabel.text = "D.O.B: \(dobStr)"
        dobLabel.font = FontCya.CyaTitlesH2
        
        userNameLabel.topAnchor.constraint(equalTo: dobLabel.topAnchor, constant: 40).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: labelsContainer.leftAnchor, constant: 0).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: labelsContainer.rightAnchor, constant: 0).isActive = true
        
        userNameLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        userNameLabel.numberOfLines = 0
        userNameLabel.textAlignment = .left
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.sizeToFit()
        if(user.username != nil){
            userNameLabel.text = "USERNAME: \(user.username!)"
        }
        userNameLabel.font = FontCya.CyaTitlesH2
        
        
    }
    
    func setLayoutBottomBar(){
        toolBarMenu.setCurrenView(currentView: "Settings")
        toolBarMenu.setParentView(parentView: self)
        viewContent.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: viewContent.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(toolBarMenuBackground)
        
        toolBarMenuBackground.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarMenuBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolBarMenuBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        toolBarMenuBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        toolBarMenuBackground.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        toolBarMenuBackground.backgroundColor = UIColor.darkGray
    }
    
    func setFooter(){
        
        viewContent.addSubview(footer)
        
        footer.translatesAutoresizingMaskIntoConstraints = false
        
        footer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: -8).isActive = true
        footer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        footer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
        
}
