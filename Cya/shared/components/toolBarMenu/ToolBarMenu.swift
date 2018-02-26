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
    
    var isSettings: Bool = false
    
    let viewNotification:UIView = UIView ();
    var chatController: ChatController?
    
    var parentView: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setToolBarMenu()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCurrenView(currentView: String){
        switch currentView {
        case "Stage":
            setSettingsButton()
            setViewersButton()
            setChatButton()
            setStageButton()
            setInfoButton()
            setButtonPressed(button: "stage")
        case "PreStage":
            setSettingsButton()
            setChatButton()
            setStageButton()
            setInfoButton()
            setButtonPressed(button: "stage")
        case "Settings":
            setSettingsButton()
            setButtonPressed(button: "settings")
            isSettings = true
            
        default:
            setSettingsButton()
            
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
            let viewcontroller : SettingsController = SettingsController()
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
    
}

// MARK: -  Setup View
extension ToolBarMenu{
    
    func setToolBarMenu(){
        
        self.backgroundColor = UIColor.darkGray
        
        
        
        self.addSubview(cya_icon)
        
        cya_icon.translatesAutoresizingMaskIntoConstraints = false
        cya_icon.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 5).isActive = true
        cya_icon.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        cya_icon.heightAnchor.constraint(equalToConstant: 38).isActive = true
        cya_icon.widthAnchor.constraint(equalToConstant: 60).isActive = true
        
//        cya_icon.image = UIImage(named: "cya_icon")
//        cya_icon.contentMode = .scaleAspectFit
        
        cya_icon.setImage(UIImage(named: "cya_icon"), for: .normal)
        cya_icon.imageView?.contentMode = .scaleAspectFit
        cya_icon.addTarget(self, action: #selector(cyaButtonAction), for: .touchUpInside)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setInfoButton(){
        
        
        infoButton.setImage(UIImage(named: "cya_info"), for: .normal)
        infoButton.imageView?.contentMode = .scaleAspectFit
        infoButton.addTarget(self, action: #selector(infoButtonAction), for: .touchUpInside)
        
        self.addSubview(infoButton)
        
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        infoButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        infoButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
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
        stageButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
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
        chatButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        chatButton.heightAnchor.constraint(equalToConstant: 34).isActive = true
        chatButton.widthAnchor.constraint(equalToConstant: 34).isActive = true
        
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
        
        settingsButton.setImage(UIImage(named: "cya_settings"), for: .normal)
        settingsButton.imageView?.contentMode = .scaleAspectFit
        settingsButton.addTarget(self, action: #selector(settingsButtonAction), for: .touchUpInside)
        
        self.addSubview(settingsButton)
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        settingsButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(settingsButton.leftAnchor)
    }
    
    func setViewersButton(){
        
        viewersButton.setImage(UIImage(named: "cya_canvas"), for: .normal)
        viewersButton.imageView?.contentMode = .scaleAspectFit
        viewersButton.addTarget(self, action: #selector(viewersButtonAction), for: .touchUpInside)
        
        self.addSubview(viewersButton)
        
        viewersButton.translatesAutoresizingMaskIntoConstraints = false
        viewersButton.rightAnchor.constraint(equalTo: getRrightAnchorItem(), constant: getConstantRightAnchor()).isActive = true
        viewersButton.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        viewersButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        viewersButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        rightAnchorArray.append(viewersButton.leftAnchor)
    }
    
    
    
    func getConstantRightAnchor() -> CGFloat{
        let constantRightAnchor: CGFloat?
        if(rightAnchorArray.count == 0){
            constantRightAnchor = -8
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
        settingsButton.setImage(UIImage(named: "cya_settings"), for: .normal)
        viewersButton.setImage(UIImage(named: "cya_canvas"), for: .normal)
        
        
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
            settingsButton.setImage(UIImage(named: "cya_settings_pressed"), for: .normal)
        case "viewers":
            viewersButton.setImage(UIImage(named: "cya_canvas_pressed"), for: .normal)
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

