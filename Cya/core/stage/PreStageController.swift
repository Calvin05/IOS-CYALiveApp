//
//  PreStageController.swift
//  Cya
//
//  Created by Cristopher Torres on 29/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class PreStageController: UIViewController {
    
    var viewContent: UIView = UIView()
    var backButtonView: BackButtonView?
    var waitLabel: EdgeInsetLabel = EdgeInsetLabel()
    var waitLabelBackgroud: UIView = UIView()
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    
    var viewHeader: ViewHeaderDetail = ViewHeaderDetail()
    let aspectRatio = AspectRatio(aspect: "HD Video")
    var height16_9: Float?
    var sigService: SigService?
    var event: Event?
    var eventService: EventService = EventService()
    var roleView: RoleView?
    
    var iSkinContainer: UIView = UIView()
    var iSkinLabel: EdgeInsetLabel = EdgeInsetLabel()
    var iSkinImage: UIImageView = UIImageView()
    
    var roleContainer: UIView = UIView()
    
    var chatServices: ChatService?
    var eventContentDisplayObject: EventContentDisplayObject?
    var chatContainer: UIView = UIView()
    var eventDescription: DescriptionView = DescriptionView()
    
    init(sigService: SigService, eventId: String) {
        super.init(nibName: nil, bundle: nil)
        self.height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(self.view.frame.size.width))
        self.sigService = sigService
        loadSocketSigOn()
        self.setEvent(eventId: eventId)
        self.setChatService()
        self.setupView()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        if(event?.trailer != nil && (event?.trailer)! != ""){
            viewHeader.playVideo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        viewHeader.playerMovie?.pause()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func setEvent(eventId: String){
        event = eventService.getEvent(eventId: eventId)
        
        if(event?.trailer != nil && (event?.trailer)! != ""){
            viewHeader.setCurrenView(currentView: "video", data: (event?.trailer)!)
        }else if (event?.thumbnail != nil && event?.thumbnail != ""){
            viewHeader.setCurrenView(currentView: "image", data: (event?.thumbnail)!)
        }else {
            viewHeader.setCurrenView(currentView: "image", data: "default")
        }
    }
    
    func setChatService(){
        self.eventContentDisplayObject = eventService.getEventContents(eventId: self.event!.id!)
        
        for eventServiceDisplayObject: EventServiceDisplayObject in (eventContentDisplayObject!.services)!{
            if(eventServiceDisplayObject.name == "chat"){
                let chatSessionId = eventServiceDisplayObject.session_id
                self.chatServices = ChatService(sessionId: chatSessionId!)
                break
            }
        }
    }
    
    func loadSocketSigOn(){
        self.onEventStatus()
    }
    
    func onEventStatus(){
        sigService!.onEventStatus(handler: {isWaiting, ack in
            if(!isWaiting!){
                self.goEvent()
            }
        })
    }
    
    func goEvent(){
        let viewcontroller : UIViewController = StageViewController(sigService: sigService!, eventId: self.event!.id!)
        self.show(viewcontroller, sender: nil)
    }

}

extension PreStageController {
    
    func setupView(){
        
        view.backgroundColor = UIColor.cyaDarkBg
        
        setViewContent()
        setWaitLabel()
        setViewHeader()
        setBackButton()
        setLayoutBottomBar()
        setEventDescription()
        setRoles()
//        setISkin()
        setChatContainer()
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.clear
    }
    
    func setEventDescription(){
        viewContent.addSubview(eventDescription)
        eventDescription.isHidden = true
        eventDescription.topAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 0).isActive = true
        eventDescription.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0).isActive = true
        eventDescription.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0).isActive = true
        eventDescription.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        
        eventDescription.setCurrenView(data: (event?.description)!)
        
    }
    
    func setBackButton(){
        
        self.backButtonView = BackButtonView()
        self.backButtonView?.setParent(parent: self)
        viewContent.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: waitLabel.topAnchor, constant: 5).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func setWaitLabel(){
        viewContent.addSubview(waitLabel)
        view.addSubview(waitLabelBackgroud)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        waitLabelBackgroud.translatesAutoresizingMaskIntoConstraints = false
        
        waitLabel.topAnchor.constraint(equalTo: viewContent.topAnchor).isActive = true
        waitLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        waitLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        waitLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        waitLabelBackgroud.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        waitLabelBackgroud.bottomAnchor.constraint(equalTo: waitLabel.topAnchor).isActive = true
        waitLabelBackgroud.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        waitLabelBackgroud.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        waitLabel.backgroundColor = UIColor.cyaMagenta
        waitLabel.textColor = UIColor.white
        waitLabel.numberOfLines = 1
        waitLabel.textAlignment = .center
        waitLabel.lineBreakMode = .byWordWrapping
        waitLabel.text = "This event starts soon"
        waitLabel.font = FontCya.CyaBody
        
        waitLabelBackgroud.backgroundColor = UIColor.cyaMagenta
    }
    
    func setViewHeader(){
        
        viewContent.addSubview(viewHeader)
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        
        viewHeader.topAnchor.constraint(equalTo: waitLabel.bottomAnchor).isActive = true
        viewHeader.heightAnchor.constraint(equalToConstant: CGFloat(height16_9!)).isActive = true
        viewHeader.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        viewHeader.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
    }
    
   
    
    func setLayoutBottomBar(){
        toolBarMenu.toolBarMenuDelegate = self
        
        toolBarMenu.setCurrenView(currentView: "PreStage")
        toolBarMenu.setParentView(parentView: self)
        viewContent.addSubview(toolBarMenu)
        toolBarMenu.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        toolBarMenu.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(toolBarMenuBackground)
        
        toolBarMenuBackground.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarMenuBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolBarMenuBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        toolBarMenuBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        toolBarMenuBackground.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        toolBarMenuBackground.backgroundColor = UIColor.darkGray
    }
    
    func setRoles(){
        
        viewContent.addSubview(roleContainer)
        
        roleContainer.translatesAutoresizingMaskIntoConstraints = false
        
        roleContainer.topAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 0).isActive = true
        roleContainer.leftAnchor.constraint(equalTo: viewHeader.leftAnchor, constant: 0).isActive = true
        roleContainer.rightAnchor.constraint(equalTo: viewHeader.rightAnchor, constant: 0).isActive = true
        let heightRole = self.view.frame.size.width * 0.75
        roleContainer.heightAnchor.constraint(equalToConstant: heightRole).isActive = true
        
        roleContainer.backgroundColor = UIColor.black
        
        
        let layout = UICollectionViewFlowLayout()
        self.roleView = RoleView(collectionViewLayout: layout, roleArray: (event?.roles)!)
        addChildViewController(roleView!)
        
        roleContainer.addSubview(roleView!.view)
        roleView!.view.translatesAutoresizingMaskIntoConstraints = false
        
        roleView!.view.topAnchor.constraint(equalTo: roleContainer.topAnchor, constant: 0).isActive = true
        roleView!.view.leftAnchor.constraint(equalTo: roleContainer.leftAnchor, constant: 0).isActive = true
        roleView!.view.rightAnchor.constraint(equalTo: roleContainer.rightAnchor, constant: 0).isActive = true
        roleView!.view.bottomAnchor.constraint(equalTo: roleContainer.bottomAnchor, constant: 0).isActive = true
        
        roleView!.didMove(toParentViewController: self)
    }
    
    func setISkin(){
        
        viewContent.addSubview(iSkinContainer)
        iSkinContainer.addSubview(iSkinLabel)
        iSkinContainer.addSubview(iSkinImage)
        
        iSkinContainer.translatesAutoresizingMaskIntoConstraints = false
        iSkinLabel.translatesAutoresizingMaskIntoConstraints = false
        iSkinImage.translatesAutoresizingMaskIntoConstraints = false
        
        iSkinContainer.topAnchor.constraint(equalTo: roleContainer.bottomAnchor, constant: 0).isActive = true
        iSkinContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        iSkinContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        iSkinContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        
        iSkinLabel.bottomAnchor.constraint(equalTo: iSkinContainer.centerYAnchor, constant: -5).isActive = true
        iSkinLabel.centerXAnchor.constraint(equalTo: iSkinContainer.centerXAnchor, constant: 0).isActive = true
        
        iSkinLabel.textColor = UIColor.white
        iSkinLabel.numberOfLines = 0
        iSkinLabel.textAlignment = .center
        iSkinLabel.lineBreakMode = .byWordWrapping
        iSkinLabel.sizeToFit()
        iSkinLabel.font = FontCya.CyaTitlesH5
        iSkinLabel.text = "Brought to you by:"
        
        
        iSkinImage.topAnchor.constraint(equalTo: iSkinLabel.bottomAnchor, constant: 2).isActive = true
        iSkinImage.centerXAnchor.constraint(equalTo: iSkinContainer.centerXAnchor, constant: 0).isActive = true
        iSkinImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        iSkinImage.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        iSkinImage.layer.masksToBounds = true
        iSkinImage.image = UIImage(named: "profile")
        iSkinImage.contentMode = .scaleAspectFill
    }
    
    func setChatContainer(){
        chatContainer.isHidden = true
        chatContainer.backgroundColor = UIColor.clear
        chatContainer.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(chatContainer)
        
        chatContainer.topAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 0).isActive = true
        chatContainer.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0).isActive = true
        chatContainer.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0).isActive = true
        chatContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        
        let chatController: ChatController = ChatController()
        
        
        addChildViewController(chatController)
        
        chatContainer.addSubview(chatController.view)
        chatController.view.translatesAutoresizingMaskIntoConstraints = false
        
        chatController.view.topAnchor.constraint(equalTo: chatContainer.topAnchor).isActive = true
        chatController.view.leftAnchor.constraint(equalTo: chatContainer.leftAnchor, constant: 0).isActive = true
        chatController.view.rightAnchor.constraint(equalTo: chatContainer.rightAnchor, constant: 0).isActive = true
        chatController.view.bottomAnchor.constraint(equalTo: chatContainer.bottomAnchor, constant: 0).isActive = true
        
        chatController.didMove(toParentViewController: self)
        
        toolBarMenu.setChatController(chatControler: chatController)
        self.toolBarMenu.setChatService(chatService: self.chatServices!)
        
    }
    
}

extension PreStageController: ToolBarMenuDelegate {
    
    func hideViews(){
        roleContainer.isHidden = true
        chatContainer.isHidden = true
        eventDescription.isHidden = true
    }

    func infoButtonAction() {
        hideViews()
        eventDescription.isHidden = false
//        goEvent()
    }

    func chatButtonAction() {
        chatContainer.isHidden = false
    }
    
    func stageButtonAction() {
        hideViews()
        roleContainer.isHidden = false
    }
}
