//
//  SettingsController.swift
//  Cya
//
//  Created by Cristopher Torres on 11/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
    
    var viewContent: UIView = UIView()
    let viewHeader: UIView = UIView()
    let aspectRatio = AspectRatio(aspect: "HD Video")
    var profileImage: UIImageView = UIImageView()
    var nameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var aboutMeTitleLabel: EdgeInsetLabel = EdgeInsetLabel()
    var aboutMe: UITextView = UITextView()
    var moreInfoButton: UIButton = UIButton(type: .system) as UIButton
    var logOutButton: UIButton = UIButton(type: .system) as UIButton
    
    var backButtonView: BackButtonView?
    var footer: FooterSettingsComponent = FooterSettingsComponent()
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    var userService: UserService = UserService()
    var user: User = User()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func moreInfoAction(){
        let viewcontroller : MoreInfoController = MoreInfoController()
        self.show(viewcontroller, sender: nil)
    }
    
    @objc func logOutAction(){
        UserDisplayObject.token = ""
        UserDisplayObject.userId = ""
        UserDisplayObject.authorization = ""
        UserDisplayObject.avatar = ""
        UserDisplayObject.username = ""
        
        var HomeView: UIStoryboard!
        HomeView = UIStoryboard(name: "Auth", bundle: nil)
        let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
        
        self.show(homeGo, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateText()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        aboutMe.scrollRangeToVisible(NSRange(location:0, length:0))
    }
    
    func updateText(){
        user = userService.getUserById(userId: UserDisplayObject.userId)
        nameLabel.text = "\(user.first_name == nil ? "" : user.first_name!) \(user.last_name == nil ? "" : user.last_name!)"
        aboutMe.text = user.notes == nil ? "" : user.notes!
        profileImage.downloadedFrom(defaultImage: "profile", link: user.avatar == nil ? "http://" : user.avatar!, contentMode: .scaleAspectFill)
    }

}

extension SettingsController{
    
    func setupView(){
        
//        view.backgroundColor = UIColor.Cya_Placeholder_Background_Color
        view.backgroundColor = UIColor.white
        
        setViewContent()
        setHeader()
        setLayoutBottomBar()
        setFooter()
        setProfileImage()
        setNameLabel()
        setMoreInfo()
        setLogOut()
        setAboutMe()
        setBackButton()
        
        
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true
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
        
        profileImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 20).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        profileImage.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        profileImage.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        profileImage.layer.masksToBounds = true
        profileImage.downloadedFrom(defaultImage: "profile", link: user.avatar == nil ? "http://" : user.avatar!, contentMode: .scaleAspectFill)
    }
    
    func setNameLabel(){
        
        viewContent.addSubview(nameLabel)
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 18).isActive = true
        nameLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 60).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -65).isActive = true
        
        nameLabel.textColor = UIColor.cyaMagenta
        nameLabel.numberOfLines = 0
        nameLabel.textAlignment = .center
        nameLabel.lineBreakMode = .byWordWrapping
        nameLabel.sizeToFit()
        nameLabel.text = "\(user.first_name == nil ? "" : user.first_name!) \(user.last_name == nil ? "" : user.last_name!)"
        nameLabel.font = FontCya.CyaTitlesH1Light
    }
    
    func setMoreInfo(){
        viewContent.addSubview(moreInfoButton)
        
        moreInfoButton.translatesAutoresizingMaskIntoConstraints = false
        
        moreInfoButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        moreInfoButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: -30).isActive = true
        moreInfoButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -5).isActive = true
        
        moreInfoButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        moreInfoButton.setTitleColor(.cyaMagenta, for: .normal)
        moreInfoButton.addTarget(self, action: #selector(moreInfoAction), for: .touchUpInside)
        moreInfoButton.setTitle("More Info.", for: .normal)
        moreInfoButton.contentHorizontalAlignment = .right
    }
    
    func setLogOut(){
        viewContent.addSubview(logOutButton)
        
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        
        logOutButton.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 0).isActive = true
        logOutButton.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 5).isActive = true
        logOutButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        logOutButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        logOutButton.setTitleColor(.cyaMagenta, for: .normal)
        logOutButton.addTarget(self, action: #selector(logOutAction), for: .touchUpInside)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.contentHorizontalAlignment = .right
    }
    
    func setAboutMe(){
        
        viewContent.addSubview(aboutMeTitleLabel)
        viewContent.addSubview(aboutMe)
        
        aboutMeTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMe.translatesAutoresizingMaskIntoConstraints = false
        
        aboutMeTitleLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        aboutMeTitleLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        aboutMeTitleLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        aboutMeTitleLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        aboutMeTitleLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        aboutMeTitleLabel.numberOfLines = 0
        aboutMeTitleLabel.textAlignment = .center
        aboutMeTitleLabel.lineBreakMode = .byWordWrapping
        aboutMeTitleLabel.sizeToFit()
        aboutMeTitleLabel.text = "About Me"
        aboutMeTitleLabel.font = FontCya.CyaTitlesH3
        
        aboutMe.backgroundColor = UIColor.clear
        aboutMe.topAnchor.constraint(equalTo: aboutMeTitleLabel.bottomAnchor, constant: 10).isActive = true
        aboutMe.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        aboutMe.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 10).isActive = true
        aboutMe.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -10).isActive = true
        aboutMe.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: -5).isActive = true
        aboutMe.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        aboutMe.textAlignment = .center
        aboutMe.text = user.notes == nil ? "" : user.notes!
        aboutMe.font = FontCya.CyaTitlesH3Light
        aboutMe.isEditable = false
        
        aboutMe.scrollsToTop = true
        
        
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
        
        view.addSubview(footer)
        
        footer.translatesAutoresizingMaskIntoConstraints = false
        
        footer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: -8).isActive = true
        footer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        footer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}
