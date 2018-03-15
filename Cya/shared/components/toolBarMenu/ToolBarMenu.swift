//
//  ToolBarMenu.swift
//  Cya
//
//  Created by Cristopher Torres on 08/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

@objc protocol ToolBarMenuDelegate: class {
    @objc optional func infoButtonAction()
    @objc optional func stageButtonAction()
    @objc optional func chatButtonAction()
    @objc optional func qnsButtonAction()
    @objc optional func viewersButtonAction()
}

import UIKit

class ToolBarMenu: UIView{
    
    var cya_icon: UIButton = UIButton()
    var infoButton: UIButton = UIButton()
    var qnsButton: UIButton = UIButton()
    var settingsButton: UIButton = UIButton()
    var stageButton: UIButton = UIButton()
    var chatButton: UIButton = UIButton()
    var viewersButton: UIButton = UIButton()
    var rightAnchorArray: [NSLayoutXAxisAnchor] = []
    weak var toolBarMenuDelegate: ToolBarMenuDelegate?
    var isChatSelected: Bool = false
    var logoutButton: UIButton = UIButton(type: .system) as UIButton
    var eventListButton: UIButton = UIButton()
    var avatarImage: UIImageView = UIImageView()
    
    var isSettings: Bool = false
    
    let viewNotification:UIView = UIView ();
    var chatController: ChatController?
    
    var parentView: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        avatarImage.sd_setImage(with: URL(string: UserDisplayObject.avatar), placeholderImage: UIImage(named: "cya-profile-gray-s"))
        setToolBarMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrenView(currentView: String){
        switch currentView {
        case "Stage":
//            setLeftIcon()
            setEventListButton()
            setSettingsButton()
            setViewersButton()
            setInfoButton()
            setStageButton()
            setChatButton()
            setButtonPressed(button: "stage")
        case "PreStage":
//            setLeftIcon()
            setEventListButton()
            setSettingsButton()
            setChatButton()
            setStageButton()
            setInfoButton()
            setButtonPressed(button: "stage")
        case "Settings":
//            setSettingsButton()
//            setButtonPressed(button: "settings")
//            isSettings = true
            setLeftIcon()
            setLogoutButton()
        case "Event":
            setCenterIcon()
            
        default:
//            setSettingsButton()
            setLeftIcon()
        }
    }
    
    func setChatController(chatControler: ChatController){
        self.chatController = chatControler
        self.chatController!.delegate = self
    }
    
    func setChatService(chatService: ChatService){
        self.chatController?.setChatService(chatService: chatService)
    }
    
    func setParentView(parentView: UIViewController){
        self.parentView = parentView
    }
    
    @objc func infoButtonAction(sender:UIButton!) {
        toolBarMenuDelegate?.infoButtonAction!()
        setButtonPressed(button: "info")
        
    }
    
    @objc func settingsButtonAction(sender:UIButton!) {
        setButtonPressed(button: "settings")
        if(!isSettings){
//            let viewcontroller : SettingsController = SettingsController()
//            self.parentView?.show(viewcontroller, sender: nil)
            
            let viewcontroller : GralInfoController = GralInfoController()
            self.parentView?.show(viewcontroller, sender: nil)
        }
    }
    
    @objc func stageButtonAction(sender:UIButton!) {
        toolBarMenuDelegate?.stageButtonAction!()
        setButtonPressed(button: "stage")
    }
    
    @objc func chatButtonAction(sender:UIButton!) {
        self.toolBarMenuDelegate?.chatButtonAction!()
        self.setButtonPressed(button: "chat")
    }
    
    @objc func qnsButtonAction(sender:UIButton!) {
        toolBarMenuDelegate?.qnsButtonAction!()
    }
    
    @objc func viewersButtonAction(sender:UIButton!) {
        toolBarMenuDelegate?.viewersButtonAction!()
        setButtonPressed(button: "viewers")
    }
    
    @objc func cyaButtonAction(){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "EventList", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
        self.parentView?.show(viewcontroller, sender: nil)
    }
    
    @objc func logout(){
        UserDisplayObject.token = ""
        UserDisplayObject.userId = ""
        UserDisplayObject.authorization = ""
        UserDisplayObject.avatar = ""
        UserDisplayObject.username = ""
        
        var HomeView: UIStoryboard!
        HomeView = UIStoryboard(name: "Auth", bundle: nil)
        let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
        
        self.parentView?.show(homeGo, sender: nil)
    }
    
}

// MARK: -  Setup View
extension ToolBarMenu{
    
    func setToolBarMenu(){
        
        self.backgroundColor = UIColor.white
        
        
        self.addSubview(cya_icon)
        
        cya_icon.translatesAutoresizingMaskIntoConstraints = false
        
        cya_icon.setImage(UIImage(named: "cya_icon"), for: .normal)
        cya_icon.imageView?.contentMode = .scaleAspectFit
        cya_icon.addTarget(self, action: #selector(cyaButtonAction), for: .touchUpInside)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setLeftIcon(){
        cya_icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cya_icon.heightAnchor.constraint(equalToConstant: 38).isActive = true
        cya_icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cya_icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
    }
    
    func setCenterIcon(){
        cya_icon.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        cya_icon.heightAnchor.constraint(equalToConstant: 38).isActive = true
        cya_icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        cya_icon.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
    }
    
    func setEventListButton(){
        
        self.addSubview(eventListButton)
        
        eventListButton.translatesAutoresizingMaskIntoConstraints = false
        
        eventListButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        eventListButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eventListButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        eventListButton.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        eventListButton.setImage(UIImage(named: "cya-event-list-gray"), for: .normal)
        eventListButton.imageView?.contentMode = .scaleAspectFit
        eventListButton.addTarget(self, action: #selector(cyaButtonAction), for: .touchUpInside)
        
    }
    
    func setInfoButton(){
        
        
        infoButton.setImage(UIImage(named: "cya_info"), for: .normal)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        
        self.addSubview(infoButton)
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        infoButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        infoButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        infoButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(infoButton.leftAnchor)
    }
    
    func setQnsButton(){
        
        
        qnsButton.setImage(UIImage(named: "cya_chat"), for: .normal)
        qnsButton.imageView?.contentMode = .scaleAspectFit
        qnsButton.addTarget(self, action: #selector(qnsButtonAction), for: .touchUpInside)
        
        self.addSubview(qnsButton)
        
        qnsButton.translatesAutoresizingMaskIntoConstraints = false
        qnsButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        qnsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        qnsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        qnsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(qnsButton.leftAnchor)
    }
    
    func setStageButton(){
        
        stageButton.setImage(UIImage(named: "cya_stage"), for: .normal)
        stageButton.imageView?.contentMode = .scaleAspectFit
        stageButton.addTarget(self, action: #selector(stageButtonAction), for: .touchUpInside)
        
        self.addSubview(stageButton)
        
        stageButton.translatesAutoresizingMaskIntoConstraints = false
        stageButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        stageButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        stageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stageButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(stageButton.leftAnchor)
    }
    
    func setChatButton(){
        
        chatButton.setImage(UIImage(named: "cya_chat"), for: .normal)
        chatButton.imageView?.contentMode = .scaleAspectFit
        chatButton.addTarget(self, action: #selector(chatButtonAction), for: .touchUpInside)
        
        self.addSubview(chatButton)
        
        chatButton.translatesAutoresizingMaskIntoConstraints = false
        chatButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        chatButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewNotification.backgroundColor = .clear
        viewNotification.layer.masksToBounds = true
        viewNotification.layer.cornerRadius = 3
        viewNotification.translatesAutoresizingMaskIntoConstraints = false
        
        chatButton.addSubview(viewNotification)
        
        viewNotification.widthAnchor.constraint(equalToConstant: 6).isActive = true
        viewNotification.heightAnchor.constraint(equalToConstant: 6).isActive = true
        viewNotification.topAnchor.constraint(equalTo: chatButton.topAnchor, constant: 0).isActive = true
        viewNotification.rightAnchor.constraint(equalTo: chatButton.rightAnchor, constant: -2).isActive = true
        
        
        rightAnchorArray.append(chatButton.leftAnchor)
    }
    
    func setSettingsButton(){
        
        settingsButton.setImage(avatarImage.image, for: .normal)
//        settingsButton.setImage(UIImage(named: "cya-profile-gray-s"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        settingsButton.layer.cornerRadius = 15
        settingsButton.layer.masksToBounds = true
        
        self.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(settingsButton.leftAnchor)
    }
    
    func setViewersButton(){
        
        viewersButton.setImage(UIImage(named: "cya-profile-gray-s"), for: .normal)
        viewersButton.imageView?.contentMode = .scaleAspectFit
        viewersButton.addTarget(self, action: #selector(viewersButtonAction), for: .touchUpInside)
        
        self.addSubview(viewersButton)
        
        viewersButton.translatesAutoresizingMaskIntoConstraints = false
        viewersButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        viewersButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        viewersButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewersButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(viewersButton.leftAnchor)
    }
    
    func setLogoutButton(){
        
        self.addSubview(logoutButton)
        
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        logoutButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        logoutButton.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0).isActive = true
        logoutButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 90).isActive = true
        
        
        logoutButton.addTarget(self, action: #selector(logout), for: .touchUpInside)
        logoutButton.titleLabel?.font = FontCya.CyaBody
        logoutButton.setTitleColor(.darkGray, for: .normal)
        logoutButton.setTitle("Logout", for: .normal)
        
        
        rightAnchorArray.append(logoutButton.leftAnchor)
    }
    
    
    
    func getConstantRightAnchor() -> CGFloat{
        let constantRightAnchor: CGFloat?
        if(rightAnchorArray.count == 0){
            constantRightAnchor = -15
        }else{
            constantRightAnchor = -20
        }
        
        return constantRightAnchor!
    }
    
    func getRrightAnchorItem() -> NSLayoutXAxisAnchor{
        let rightAnchorItem: NSLayoutXAxisAnchor?
        
        if(rightAnchorArray.count == 0){
            rightAnchorItem = self.rightAnchor
        }else{
            rightAnchorItem = rightAnchorArray[rightAnchorArray.count - 1]
        }
        
        return rightAnchorItem!
    }
    
    func setButtonPressed(button: String){
        
        isChatSelected = false
        
        infoButton.setImage(UIImage(named: "cya_info"), for: .normal)
        stageButton.setImage(UIImage(named: "cya_stage"), for: .normal)
        chatButton.setImage(UIImage(named: "cya_chat"), for: .normal)
        
        settingsButton.setImage(avatarImage.image, for: .normal)
//        settingsButton.setImage(UIImage(named: "cya_settings"), for: .normal)
        
        viewersButton.setImage(UIImage(named: "cya-profile-gray-s"), for: .normal)
        
        
        switch button {
        case "info":
            infoButton.setImage(UIImage(named: "cya_info_pressed"), for: .normal)
        case "stage":
            stageButton.setImage(UIImage(named: "cya_stage_pressed"), for: .normal)
        case "chat":
            chatButton.setImage(UIImage(named: "cya_chat_pressed"), for: .normal)
            isChatSelected = true
            viewNotification.backgroundColor = UIColor.clear
        case "settings":
            settingsButton.setImage(avatarImage.image, for: .normal)
//            settingsButton.setImage(UIImage(named: "cya_settings_pressed"), for: .normal)
        case "viewers":
            viewersButton.setImage(UIImage(named: "cya-profile-pressed"), for: .normal)
        default:
            print()
        }
        
    }
}

extension ToolBarMenu:  notificationMessageDelegate {

    func notificationMessages(newColor: UIColor) {
        let color: UIColor = newColor
        if(!isChatSelected){
            viewNotification.backgroundColor = color
        }
        
    }

}

