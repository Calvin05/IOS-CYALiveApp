//
//  EventDetail.swift
//  Cya
//
//  Created by Rigo on 27/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import Stripe

class EventDetail: UIViewController {
    
    var isError: Bool = false
    var isErrorWithBack = false
    var appConfig: NSMutableDictionary!
    var eventUrl: String!
    
    
    var headerContainer: UIView = UIView()
    var headerBackground: UIView = UIView()
    var headerLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var eventsButton: UIButton = UIButton()
    var profileButton: UIButton = UIButton()
    var avatarImage: UIImageView = UIImageView()
    
    var waitLabel: EdgeInsetLabel = EdgeInsetLabel()
    var window: UIWindow?
    var isLoginUse: Bool = false
    
    var viewContent: UIView = UIView()
    var intro: ViewHeaderDetail = ViewHeaderDetail()
    
    var scrollContainer: UIScrollView = UIScrollView()
    var dateAndBtnContainer: UIView = UIView()
    var lineView: UIView = UIView()
    var dateContainer: UIView = UIView()
    var monthEvent: EdgeInsetLabel = EdgeInsetLabel()
    var dayEvent: EdgeInsetLabel = EdgeInsetLabel()
    var start: EdgeInsetLabel = EdgeInsetLabel()
    var ends: EdgeInsetLabel = EdgeInsetLabel()
    var price: EdgeInsetLabel = EdgeInsetLabel()
    var titleEvent: EdgeInsetLabel = EdgeInsetLabel()
    var descEvent: EdgeInsetLabel = EdgeInsetLabel()
    
//    var contentAvatars : UIView = UIView()
    var contentAvatars : UIView = UIView()
    var avatarView: AvatarView?
    var avatarDefault: Role =  Role()
    var sigService: SigService?
    
    
    var viewInfoDetail:ViewInfoDetail = ViewInfoDetail()
    
    let btnBuy = UIButton(type: .system) as UIButton
    let viewShared : UIView = UIView()
    let shareBtn = UIButton(type: .custom) as UIButton
    let favoriteBtn = UIButton(type: .custom) as UIButton
    
    var screenWidth : CGFloat = 0.0
    var halfScreenWidth: CGFloat = 0.0
    let aspectRatio = AspectRatio(aspect: "HD Video")
    
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    
    var detailEvent: Event!
    var eventID: String?

    var _eventService: EventService         = EventService()
    var _purchaseService: PurchaseService   = PurchaseService()
    var dataPayByRSVP: PayByRSVPDisplayObject?
    var isTiketUserToEvent:StatusDisplayObject?
    
    var eventFinished: Bool?
    var eventStart: Bool?
    
    var timeEnd: NSDate!
    let timestamp = NSDate().timeIntervalSince1970
    
    
    var seconds: Int? = 60
    var timer = Timer()
    
    override func loadView() {
        super.loadView()
        initView()
        do{
            let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
            appConfig = NSMutableDictionary(contentsOfFile: path!)!
            eventUrl = appConfig.value(forKey: "eventUrl") as! String

            self.sigService = SigService(eventId: self.eventID!)
            loadSocketSigOn()

            detailEvent = try _eventService.getEvent(eventId: (self.eventID)!)
            
            setComponentsInfo()
            setContentAvatars()
        }catch{
            isError = true
        }
        
        

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.sigService?.socket.disconnect()
//        self.sigService = nil
        
        self.intro.playerMovie?.pause()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("---------viewDidAppear")
        
        if(self.isError){
            self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
            self.isError = false
        }else{
            if(detailEvent.trailer != nil && (detailEvent.trailer)! != "" && detailEvent.trailer != "Unknown Type: string,null"){
                intro.playVideo()
            }
        }
    }
    
    func setComponentsInfo(){
        
        var isDateEvent = true
        
        if(detailEvent.end_at != nil){
            isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        }
        
        if (!isDateEvent){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecrease), userInfo: nil, repeats: true)
            customerBtnBuy()
        }else {
            actionInvisible()
        }
        
        
        if(self.detailEvent.trailer != nil && (self.detailEvent.trailer)! != "" && self.detailEvent.trailer != "Unknown Type: string,null"){
            intro.setCurrenView(currentView: "video", data: (self.detailEvent.trailer)!)
        }else if (self.detailEvent.thumbnail != nil && self.detailEvent.thumbnail != ""){
            intro.setCurrenView(currentView: "image", data: (self.detailEvent.thumbnail)!)
        }else {
            intro.setCurrenView(currentView: "image", data: "default")
            
        }
        
        if let startDate = detailEvent.start_at{
            if(startDate != ""){
                monthEvent.text = NSString.convertFormatOfDate(date: startDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "MMM")
                dayEvent.text = NSString.convertFormatOfDate(date: startDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "dd")
                
                let Hrs = NSString.convertFormatOfDate(date: startDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "h:mm a")
                start.text = "START: \(Hrs!)"
            }
        }
        
        if let endDate = detailEvent.end_at{
            if(endDate != ""){
                let Hrs = NSString.convertFormatOfDate(date: endDate, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "h:mm a")
                ends.text = "ENDS: \(Hrs!)"
            }
        }
        
        
        if (detailEvent.tiers != nil && detailEvent.tiers!.count > 0) {
            price.text = "PRICE: $\(detailEvent.tiers![0].price!)"
        } else{
            price.text = "PRICE: $0.00"
        }
        
        if let title = detailEvent.title{
           titleEvent.text = title
        }
        
        if let description = detailEvent.description{
            descEvent.text = description
        }
        
        
    }
    
    
    func setLayoutBottomBar(){
        toolBarMenu.toolBarMenuDelegate = self
        toolBarMenu.setCurrenView(currentView: "Event")
        toolBarMenu.setParentView(parentView: self)
        self.view.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(toolBarMenuBackground)
        
        toolBarMenuBackground.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarMenuBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolBarMenuBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        toolBarMenuBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        toolBarMenuBackground.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        toolBarMenuBackground.backgroundColor = UIColor.white
        
        
        
        
    }
    
    @objc func profile(){
        if(UserDisplayObject.username == ""){
            
            UserDisplayObject.token = ""
            UserDisplayObject.userId = ""
            UserDisplayObject.authorization = ""
            UserDisplayObject.avatar = ""
            UserDisplayObject.username = ""
            
            var HomeView: UIStoryboard!
            HomeView = UIStoryboard(name: "Auth", bundle: nil)
            let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
            
            self.show(homeGo, sender: nil)
        }else{
            let viewcontroller : GralInfoController = GralInfoController()
            self.show(viewcontroller, sender: nil)
        }
    }
    
    @objc func goEvents(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func loadSocketSigOn(){
//        self.onEventStatus()
    }
    
    func onEventStatus(){
        
        sigService!.onEventStatus(handler: {isWaiting, ack in
            if(!isWaiting!){
                // stage
//                if (self.detailEvent.type != 3){
                    self.setActionStartSyncServiceEventPage(type:0)
//                } else{
//                    self.actionInvisible()
//                }
                
            } else {
                // pre
//                if (self.detailEvent.type != 3){
                    self.setActionStartSyncServiceEventPage(type: 1)
//                } else{
//                    self.actionInvisible()
//                }
            }
        })
    }
    
}


extension EventDetail {
    
    func initView(){
        setViewContent()
//        setBackButton()
        setViewHeader()
        setButtonsHeader()
        setIntro()
        setWaitLabel()
        
        
        
        
//        setViewShared()
//        setShareBtn()
//        setFavoriteBtn()
        
        setLayoutBottomBar()
        setScrollContainer()
        
        setDateAndBtnContainer()
        setDateInfo()
        setDescription()
        
//        setContentAvatars()
//        setViewInfoDetail()
        setBtnBuy()
    }

    
}

extension EventDetail {
    
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

    
    func setViewHeader(){
        
        viewContent.addSubview(headerContainer)
        view.addSubview(headerBackground)
        headerContainer.addSubview(headerLabel)
        
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerBackground.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        headerContainer.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 20).isActive = true
        headerContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerContainer.backgroundColor = UIColor.cyaMagenta
        
        
        headerBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerBackground.bottomAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 0).isActive = true
        headerBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerBackground.backgroundColor = UIColor.cyaMagenta
        
        
        headerLabel.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor, constant: 0).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        headerLabel.textColor = UIColor.white
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.sizeToFit()
        headerLabel.text = "Details"
        headerLabel.font = FontCya.CyaMontMediumS22
    }
    
    func setButtonsHeader(){
        headerContainer.addSubview(eventsButton)
        headerContainer.addSubview(avatarImage)
        headerContainer.addSubview(profileButton)
        
        
        eventsButton.translatesAutoresizingMaskIntoConstraints = false
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        eventsButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        eventsButton.leftAnchor.constraint(equalTo: headerContainer.leftAnchor, constant: 20).isActive = true
        eventsButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        eventsButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        eventsButton.titleLabel?.font = FontCya.CyaBody
        eventsButton.setTitleColor(.white, for: .normal)
        eventsButton.titleLabel?.textAlignment = .left
        eventsButton.addTarget(self, action: #selector(goEvents), for: .touchUpInside)
        eventsButton.setTitle("Events", for: .normal)
        
        
        avatarImage.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        avatarImage.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        
        avatarImage.sd_setImage(with: URL(string: UserDisplayObject.avatar), placeholderImage: UIImage(named: "cya-profile-gray-s"))
        
        avatarImage.contentMode = .scaleAspectFit
        avatarImage.layer.cornerRadius = 15
        avatarImage.layer.masksToBounds = true
        
        
        profileButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        
        
        profileButton.layer.cornerRadius = 15
        profileButton.layer.masksToBounds = true
        profileButton.addTarget(self, action: #selector(profile), for: .touchUpInside)
    }
    
    func setIntro(){
        viewContent.addSubview(intro)
        
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(self.view.frame.size.width) )
        
        intro.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0 ).isActive = true
        intro.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        intro.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        intro.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        intro.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func setWaitLabel(){
        view.addSubview(waitLabel)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //        waitLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        waitLabel.topAnchor.constraint(equalTo: intro.topAnchor).isActive = true
        waitLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        waitLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        waitLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
        waitLabel.backgroundColor = UIColor.black
        waitLabel.textColor = UIColor.white
        waitLabel.numberOfLines = 1
        waitLabel.alpha = 0.5
        waitLabel.textAlignment = .center
        waitLabel.lineBreakMode = .byWordWrapping
        //        waitLabel.text =  "This event starts soon"
        waitLabel.font = FontCya.CyaBody
        let _eventDet = self.detailEvent
    }
    
    func setScrollContainer(){
        
        viewContent.addSubview(scrollContainer)
        
        
        scrollContainer.translatesAutoresizingMaskIntoConstraints    = false
        
        
        scrollContainer.topAnchor.constraint(equalTo: intro.bottomAnchor, constant: 0).isActive = true
        scrollContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        scrollContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        scrollContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
      
        scrollContainer.backgroundColor = UIColor.cyaLightGrayBg
    }
    
    func setDateAndBtnContainer(){
    
        scrollContainer.addSubview(dateAndBtnContainer)
        scrollContainer.addSubview(lineView)
        
        dateAndBtnContainer.translatesAutoresizingMaskIntoConstraints = false
        lineView.translatesAutoresizingMaskIntoConstraints = false
        
        dateAndBtnContainer.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 0).isActive = true
        dateAndBtnContainer.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 0).isActive = true
        dateAndBtnContainer.heightAnchor.constraint(equalToConstant: 115).isActive = true
        dateAndBtnContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        
        lineView.topAnchor.constraint(equalTo: dateAndBtnContainer.bottomAnchor, constant: -1).isActive = true
        lineView.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 10).isActive = true
        lineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        lineView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -10).isActive = true
        
        lineView.backgroundColor = UIColor.lightGray
    }
    
    func setDateInfo(){
        
        dateAndBtnContainer.addSubview(dateContainer)
        dateContainer.addSubview(monthEvent)
        dateContainer.addSubview(dayEvent)
        dateAndBtnContainer.addSubview(start)
        dateAndBtnContainer.addSubview(ends)
        dateAndBtnContainer.addSubview(price)
        
        
        dateContainer.translatesAutoresizingMaskIntoConstraints = false
        monthEvent.translatesAutoresizingMaskIntoConstraints = false
        dayEvent.translatesAutoresizingMaskIntoConstraints = false
        start.translatesAutoresizingMaskIntoConstraints = false
        ends.translatesAutoresizingMaskIntoConstraints = false
        price.translatesAutoresizingMaskIntoConstraints = false
        
        
        dateContainer.topAnchor.constraint(equalTo: dateAndBtnContainer.topAnchor, constant: 5).isActive = true
        dateContainer.leftAnchor.constraint(equalTo: dateAndBtnContainer.leftAnchor, constant: 5).isActive = true
        dateContainer.heightAnchor.constraint(equalToConstant: 60).isActive = true
        dateContainer.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        monthEvent.topAnchor.constraint(equalTo: dateContainer.topAnchor, constant: 12).isActive = true
        monthEvent.centerXAnchor.constraint(equalTo:dateContainer.centerXAnchor, constant: 0).isActive = true
        
        monthEvent.textColor = UIColor.gray
        monthEvent.font = FontCya.CyaTitlesH4
        monthEvent.numberOfLines = 0
        monthEvent.lineBreakMode = .byWordWrapping
        monthEvent.sizeToFit()
        
        
        dayEvent.topAnchor.constraint(equalTo: monthEvent.bottomAnchor, constant: 0).isActive = true
        dayEvent.centerXAnchor.constraint(equalTo:dateContainer.centerXAnchor, constant: 0).isActive = true
        
        dayEvent.textColor = UIColor.cyaMagenta
        dayEvent.font = FontCya.CyaMontRegS22
        dayEvent.numberOfLines = 0
        dayEvent.lineBreakMode = .byWordWrapping
        dayEvent.sizeToFit()
        
        
        start.topAnchor.constraint(equalTo: dateContainer.bottomAnchor, constant: 0).isActive = true
        start.leftAnchor.constraint(equalTo: dateAndBtnContainer.leftAnchor, constant: 15).isActive = true
        
        start.textColor = UIColor.red
        start.font = FontCya.CyaTitlesH5Light
        start.numberOfLines = 1
        start.lineBreakMode = .byWordWrapping
        start.sizeToFit()
        
        
        ends.topAnchor.constraint(equalTo: start.bottomAnchor, constant: 0).isActive = true
        ends.leftAnchor.constraint(equalTo: dateAndBtnContainer.leftAnchor, constant: 15).isActive = true
        
        ends.textColor = UIColor.red
        ends.font = FontCya.CyaTitlesH5Light
        ends.numberOfLines = 1
        ends.lineBreakMode = .byWordWrapping
        ends.sizeToFit()
        
        
        price.topAnchor.constraint(equalTo: ends.bottomAnchor, constant: 0).isActive = true
        price.leftAnchor.constraint(equalTo: dateAndBtnContainer.leftAnchor, constant: 15).isActive = true
        
        price.textColor = UIColor.red
        price.font = FontCya.CyaTitlesH5Light
        price.numberOfLines = 1
        price.lineBreakMode = .byWordWrapping
        price.sizeToFit()
        
    }
    
    func setDescription(){
        scrollContainer.addSubview(titleEvent)
        scrollContainer.addSubview(descEvent)
        
        titleEvent.translatesAutoresizingMaskIntoConstraints = false
        descEvent.translatesAutoresizingMaskIntoConstraints = false
        
        titleEvent.topAnchor.constraint(equalTo: dateAndBtnContainer.bottomAnchor, constant: 15).isActive = true
        titleEvent.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 20).isActive = true
        titleEvent.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        
        titleEvent.textColor = UIColor.Cya_Event_List_Event_Title_Text_Color
        titleEvent.numberOfLines = 0
        titleEvent.lineBreakMode = .byWordWrapping
        titleEvent.sizeToFit()
        titleEvent.font = FontCya.CyaTitlesH2
        
        descEvent.topAnchor.constraint(equalTo: titleEvent.bottomAnchor, constant: 15).isActive = true
        descEvent.leftAnchor.constraint(equalTo: scrollContainer.leftAnchor, constant: 15).isActive = true
        descEvent.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
        descEvent.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -16.0).isActive = true
        
        descEvent.font = FontCya.CyaBody
        //        _description.font = UIFont(name: "Montserrat-Light", size: 14)
        descEvent.textColor = .darkGray
        descEvent.numberOfLines = 0
        descEvent.lineBreakMode = .byWordWrapping
        descEvent.sizeToFit()
        descEvent.textAlignment = .justified
        
        
//        let labelTwo: UILabel = {
//            let label = UILabel()
//            label.text = "Scroll Bottom"
//            label.backgroundColor = .green
//            label.translatesAutoresizingMaskIntoConstraints = false
//            return label
//        }()
//        // add labelTwo to the scroll view
//        scrollContainer.addSubview(labelTwo)
//        
//        // pin labelTwo at 400-pts from the left
//        //        labelTwo.leadingAnchor.constraint(equalTo: scrollContainer.leadingAnchor, constant: 400.0).isActive = true
//        
//        // pin labelTwo at 1000-pts from the top
//        labelTwo.topAnchor.constraint(equalTo: descEvent.bottomAnchor, constant: 10).isActive = true
//        
//        // "pin" labelTwo to right & bottom with 16-pts padding
//        labelTwo.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -16.0).isActive = true
//        labelTwo.bottomAnchor.constraint(equalTo: scrollContainer.bottomAnchor, constant: -16.0).isActive = true
    }

    
    func setContentAvatars(){
        
        scrollContainer.addSubview(contentAvatars)
        
        if let roles = detailEvent.roles{
            
            for role: Role in roles {
                
                var roleAvatar: UIImageView = UIImageView()
                var fullName: EdgeInsetLabel = EdgeInsetLabel()
                var job: EdgeInsetLabel = EdgeInsetLabel()
                var notes: EdgeInsetLabel = EdgeInsetLabel()
                
                
                scrollContainer.addSubview(roleAvatar)
                scrollContainer.addSubview(fullName)
                scrollContainer.addSubview(job)
                scrollContainer.addSubview(notes)
                
                
                roleAvatar.translatesAutoresizingMaskIntoConstraints    = false
                fullName.translatesAutoresizingMaskIntoConstraints    = false
                job.translatesAutoresizingMaskIntoConstraints    = false
                notes.translatesAutoresizingMaskIntoConstraints    = false
                
                
                roleAvatar.topAnchor.constraint(equalTo: descEvent.bottomAnchor, constant: 20).isActive = true
                roleAvatar.heightAnchor.constraint(equalToConstant: 90).isActive = true
                roleAvatar.widthAnchor.constraint(equalToConstant: 90).isActive = true
                roleAvatar.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 15).isActive = true
                
                roleAvatar.contentMode = .scaleAspectFit
                roleAvatar.layer.masksToBounds = true
                if let avatar = role.avatar{
                    roleAvatar.sd_setImage(with: URL(string: avatar), placeholderImage: UIImage(named: "cya-profile-gray-s"))
                }else{
                    roleAvatar.sd_setImage(with: URL(string: ""), placeholderImage: UIImage(named: "cya-profile-gray-s"))
                }
                
                fullName.topAnchor.constraint(equalTo: roleAvatar.topAnchor, constant: 1).isActive = true
                fullName.leftAnchor.constraint(equalTo: roleAvatar.rightAnchor, constant: 10).isActive = true
                
                fullName.textColor = UIColor.Cya_Event_List_Event_Title_Text_Color
                fullName.numberOfLines = 0
                fullName.lineBreakMode = .byWordWrapping
                fullName.sizeToFit()
                fullName.font = FontCya.CyaTitlesH5
                
                if let firstName = role.first_name{
                    if let lastName = role.last_name{
                        fullName.text = "\(firstName) \(lastName)"
                    }else{
                        fullName.text = "\(firstName)"
                    }
                }
                
                job.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 0).isActive = true
                job.leftAnchor.constraint(equalTo: roleAvatar.rightAnchor, constant: 10).isActive = true
                
                job.textColor = UIColor.Cya_Event_List_Event_Title_Text_Color
                job.numberOfLines = 0
                job.lineBreakMode = .byWordWrapping
                job.sizeToFit()
                job.font = FontCya.CyaTitlesH5LightItalic
                
//                if let job = role.job{
//                    job.text = job
//                }
                
                notes.topAnchor.constraint(equalTo: job.bottomAnchor, constant: 0).isActive = true
                notes.leftAnchor.constraint(equalTo: roleAvatar.rightAnchor, constant: 10).isActive = true
                notes.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
                
                notes.textColor = UIColor.darkGray
                notes.numberOfLines = 0
                notes.lineBreakMode = .byWordWrapping
                notes.sizeToFit()
                notes.font = FontCya.CyaTitlesH5LightItalic
                
                if let note = role.notes{
                    notes.text = note
                }
            }
        }
        

//        contentAvatars.topAnchor.constraint(equalTo: scrollContainer.topAnchor, constant: 2).isActive = true
//        contentAvatars.heightAnchor.constraint(equalToConstant: 160).isActive = true
//        contentAvatars.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
//        contentAvatars.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
//        contentAvatars.translatesAutoresizingMaskIntoConstraints    = false
//
//        contentAvatars.backgroundColor = UIColor.cyaLightGrayBg
//
//        let layout = UICollectionViewFlowLayout()
//        self.avatarView = AvatarView(collectionViewLayout: layout, avatarArray: (detailEvent.roles)!)
//        addChildViewController(avatarView!)
//
//        contentAvatars.addSubview(avatarView!.view)
//        avatarView!.view.translatesAutoresizingMaskIntoConstraints = false
//
//        avatarView!.view.topAnchor.constraint(equalTo: contentAvatars.topAnchor, constant: 0).isActive = true
//        avatarView!.view.leftAnchor.constraint(equalTo: contentAvatars.leftAnchor, constant: 0).isActive = true
//        avatarView!.view.rightAnchor.constraint(equalTo: contentAvatars.rightAnchor, constant: 0).isActive = true
//        avatarView!.view.bottomAnchor.constraint(equalTo: contentAvatars.bottomAnchor, constant: 0).isActive = true
//
//        avatarView!.didMove(toParentViewController: self)
        
        
    }
    
    func setViewInfoDetail(){
        
        scrollContainer.addSubview(viewInfoDetail)
        
        let _wContent: Float =  Float(self.view.frame.size.width)
        
        viewInfoDetail.topAnchor.constraint(equalTo: contentAvatars.bottomAnchor, constant: 10).isActive = true
        viewInfoDetail.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        viewInfoDetail.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        viewInfoDetail.translatesAutoresizingMaskIntoConstraints    = false
        
//        viewInfoDetail.setInfo(wContent: _wContent)
        viewInfoDetail.setCurrenView(data: self.detailEvent)
        
    }
    func setBtnBuy(){
        
        dateAndBtnContainer.addSubview(btnBuy)
        
        
        btnBuy.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnBuy.widthAnchor.constraint(equalToConstant: 100).isActive = true
        btnBuy.rightAnchor.constraint(equalTo: dateAndBtnContainer.rightAnchor, constant: -20).isActive = true
        btnBuy.topAnchor.constraint(equalTo: dateAndBtnContainer.topAnchor, constant: 20).isActive = true
        btnBuy.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnBuy.titleLabel!.font = FontCya.CyaTextButton
        btnBuy.setTitleColor(.Cya_Button_White_Normal, for: .normal)
        btnBuy.backgroundColor = .Cya_Primary_Color
        btnBuy.layer.cornerRadius = 15
        
        
        
        
        
    }
    
//    func setViewShared(){
//        viewContent.addSubview(viewShared)
//
//        viewShared.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
//        viewShared.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        viewShared.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
////        viewShared.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -50).isActive = true
//        viewShared.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
//        viewShared.translatesAutoresizingMaskIntoConstraints = false
//
//        viewShared.backgroundColor =  UIColor.cyaLightGrayBg
//    }
    
    
//    func setShareBtn(){
//        viewShared.addSubview(shareBtn)
//
//        shareBtn.rightAnchor.constraint(equalTo: viewShared.centerXAnchor, constant: 0).isActive = true
//        shareBtn.leftAnchor.constraint(equalTo: viewShared.leftAnchor, constant: 0).isActive = true
//        shareBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        shareBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        shareBtn.centerYAnchor.constraint(equalTo: viewShared.centerYAnchor, constant: 0).isActive = true
//        shareBtn.translatesAutoresizingMaskIntoConstraints          = false
//
//        shareBtn.setImage(UIImage(named: "cya_shared"), for: .normal)
//        shareBtn.imageView?.contentMode = .scaleAspectFit
//        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
//        shareBtn.tintColor = UIColor.cyaMagenta
//    }
//    func setFavoriteBtn(){
//        viewShared.addSubview(favoriteBtn)
//
//        favoriteBtn.leftAnchor.constraint(equalTo: viewShared.centerXAnchor, constant: 0).isActive = true
//        favoriteBtn.rightAnchor.constraint(equalTo: viewShared.rightAnchor, constant: 0).isActive = true
//        favoriteBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        favoriteBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
//        favoriteBtn.centerYAnchor.constraint(equalTo: viewShared.centerYAnchor, constant: 0).isActive = true
//        favoriteBtn.translatesAutoresizingMaskIntoConstraints       = false
//
//        favoriteBtn.setImage(UIImage(named: "cya_favorites"), for: .normal)
//        favoriteBtn.imageView?.contentMode = .scaleAspectFit
//        favoriteBtn.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
//
//    }
    
    func customerBtnBuy(){
        
        if UserDisplayObject.username == "" {
            setActionNotLogin()
        } else {
            isTicketUser()
        }
    

    }
    
    
    
    func setActionNotLogin(){
        btnBuy.setTitle("Buy", for: .normal)
        btnBuy.addTarget(self, action: #selector(actionNotLogin), for: .touchUpInside)
    }
    
    func setActionPurchaseRSVP(){
        btnBuy.setTitle("RSVP", for: .normal)
        btnBuy.addTarget(self, action: #selector(actionPurchaseRSVP), for: .touchUpInside)
    }
    func setActionPurchaseStripe(){
        btnBuy.setTitle("Price", for: .normal)
        btnBuy.addTarget(self, action: #selector(actionPurchaseStripe), for: .touchUpInside)
    }
    
    func setActionStartSyncServiceEventPage(type:Int){
        
        btnBuy.setTitle("Join", for: .normal)
        if(type == 0 ){
            btnBuy.addTarget(self, action: #selector(actionStartSyncServiceEventPage), for: .touchUpInside)
        } else {
            btnBuy.addTarget(self, action: #selector(actionStartSyncServiceEventPagePre), for: .touchUpInside)
        }
        
    }
    
    
    
    @objc func actionPurchaseRSVP(){
        
        let isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        
        if (!isDateEvent){
            let orderForm : OrderFormPayByRSVPDisplayObject = OrderFormPayByRSVPDisplayObject()
            self.dataPayByRSVP = PayByRSVPDisplayObject()
            
            self.dataPayByRSVP?.eventId = detailEvent.id!
            self.dataPayByRSVP?.userId = UserDisplayObject.userId
            
            orderForm.eventId = detailEvent.id!
            orderForm.userId = UserDisplayObject.userId
            
            orderForm.orderForm = self.dataPayByRSVP
            self._purchaseService.payByRSVP(payByRSVPData: orderForm)
            
            isTicketUser()
            print("Action Purchase 'RSVP'")
        }else {
            alertEventFinished()
        }
        
        
    }
    @objc func actionPurchaseStripe(){
        
        let isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        
        if (!isDateEvent){
            print("Action Purchase 'Stripe'")
            let checkoutController = CheckoutController(event: detailEvent)
            self.show(checkoutController, sender: nil)
        }else {
            alertEventFinished()
        }
        
        

    }
    @objc func actionStartSyncServiceEventPage(){
        let isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        
        if (!isDateEvent){
            let viewcontroller : UIViewController = StageViewController(sigService: self.sigService!, eventId: self.detailEvent.id!)
            self.show(viewcontroller, sender: nil)
            
            
        }else {
            alertEventFinished()
        }
        
    }
    
    @objc func actionStartSyncServiceEventPagePre(){
        let isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        
        if (!isDateEvent){
            let viewcontrollerPre : UIViewController = PreStageController(sigService: self.sigService!, eventId: self.detailEvent.id!)
            self.show(viewcontrollerPre, sender: nil)
        }else {
            alertEventFinished()
        }
        
    }
    
    @objc func actionInvisible(){
        btnBuy.setTitle("Disabled", for: .normal)
        btnBuy.alpha = 0.7
//        btnBuy.isHidden = true
        alertEventFinished()
    }
    
    @objc func actionNotLogin(){
        var HomeView: UIStoryboard!
        HomeView = UIStoryboard(name: "Auth", bundle: nil)
        let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
        
        self.show(homeGo, sender: nil)
    }
    
    func isTicketUser(){
        
        do{
//            self.isTiketUserToEvent = try self._purchaseService.getTicketUser(eventId: self.detailEvent.id!, userId: UserDisplayObject.userId)
                    self.isTiketUserToEvent = StatusDisplayObject()
                    self.isTiketUserToEvent?.status = true
            //if the user does not have a ticket for the event
            if(!(self.isTiketUserToEvent?.status)!){
                
                // we verify that the event has more than one level
                if  (detailEvent.tiers!.count > 0){
                    // We verify that the price is equal to "0.00"
                    if(detailEvent.tiers![0].price == "0.00"){
                        // If the price is equal to 0.00
                        setActionPurchaseRSVP()
                    } else {
                        // If the price different than "0.00"
                        // send us to the checkout screen
                        setActionPurchaseStripe()
                    }
                    
                } else {
                    // if it has no level
                    actionInvisible()
                }
                
            } else {
                //if the user has a ticket for the event
                self.onEventStatus()
            }
        }catch{
            self.isError = true
        }
        
        
  
        
    }

}



extension EventDetail: ToolBarMenuDelegate {
    
    @objc func backAction(){
        dismiss(animated: true, completion: nil)
    }
    
    func performSegueToReturnBack()  {
        if let nav = self.navigationController {
            nav.popViewController(animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    
    func compareEventStar() -> Bool{
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let now = dateformatter.string(from: NSDate() as Date)
        let nowDate = dateformatter.date(from: now)
        
        if(detailEvent.start_at == nil){
            return false
        }
        
        let eventDate = dateformatter.date(from: detailEvent.start_at!)
        
        switch eventDate?.compare(nowDate!) {
        case .orderedAscending?     :
            print("Date eventDate is earlier than date nowDate")
            self.eventStart = true
            timer.invalidate()
            waitLabel.text = "LIVE NOW"
            
            
        case .orderedDescending?    :
            print("Date eventDate is later than date nowDate")
            self.eventStart = false
            timerEventFormater()
            
            
        case .orderedSame?          :
            print("The two dates are the same")
            self.eventStart = false
            timerEventFormater()
        case .none:
            
            print("")
        }
        return self.eventStart!
        
    }
    
    
    func compareEventDate(dateEvent: String) -> Bool{
        
        
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let now = dateformatter.string(from: NSDate() as Date)
        let nowDate = dateformatter.date(from: now)
        let eventDate = dateformatter.date(from: dateEvent)
        
        
        switch eventDate?.compare(nowDate!) {
        case .orderedAscending?     :
            print("Date eventDate is earlier than date nowDate")
            self.eventFinished = true
            waitLabel.text = "Finished"
            
        case .orderedDescending?    :
            print("Date eventDate is later than date nowDate")
            self.eventFinished = false
            compareEventStar()
            
            
        case .orderedSame?          :
            print("The two dates are the same")
            self.eventFinished = false
            compareEventStar()
        case .none:
            actionInvisible()
            print("")
        }
        return self.eventFinished!
    }
    
    
    
    
    func timerEventFormater(){
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let now = dateformatter.string(from: NSDate() as Date)
        let nowDate = dateformatter.date(from: now)
        let eventDate = dateformatter.date(from: detailEvent.start_at!)
        
//        let eventDate = dateformatter.date(from: detailEvent.start_at!)
        
        let dateComponentsFormatter = DateComponentsFormatter()
        dateComponentsFormatter.unitsStyle = DateComponentsFormatter.UnitsStyle.full
        
        //Especificamos la propiedad allowedUnits pasándole un array de unidades de tiempo
        dateComponentsFormatter.allowedUnits = [NSCalendar.Unit.year, NSCalendar.Unit.month, NSCalendar.Unit.day, NSCalendar.Unit.hour, NSCalendar.Unit.minute, NSCalendar.Unit.second]
        
        //Realizamos la llamada a stringFromDate() y almacenamos el resultado en autoFormattedDifference
        let autoFormattedDifference = dateComponentsFormatter.string(from: nowDate!, to: eventDate!)
        waitLabel.text = "\(autoFormattedDifference!)"
        print(autoFormattedDifference)
    }
    
    
    @objc func setTimeLeft() {
        
        
        
        let timeNow = NSDate()
        
        // Only keep counting if timeEnd is bigger than timeNow
        //        if timeEnd.compare(timeNow as Date) != ComparisonResult.orderedDescending {
        
        let dateComponents = NSDateComponents()
        dateComponents.day = 4
        dateComponents.month = 5
        dateComponents.year = 2017
        dateComponents.hour = 10
        dateComponents.minute = 20
        dateComponents.second = 0
        
        if let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian),
            let date = gregorianCalendar.date(from: dateComponents as DateComponents) {
            let weekday = gregorianCalendar.component(.weekday, from: date)
            print(weekday) // 5, which corresponds to Thursday in the Gregorian Calendar
            
            //                let calendar = NSCalendar.current
            //                //            let components = calendar.components([.day, .hour, .minute, .second], fromDate: timeNow, toDate: timeEnd, options: [])
            //                let unitFlags = Set<Calendar.Component>([.day, .month, .year, .hour])
            //                let components = calendar.components(unitFlags, from: timestamp ,  to: timeEnd )
            //
            var dayText = String(dateComponents.day) + "d "
            var hourText = String(dateComponents.hour) + "h "
            
            // Hide day and hour if they are zero
            if dateComponents.day <= 0 {
                dayText = ""
                if dateComponents.hour <= 0 {
                    hourText = ""
                }
            }
            waitLabel.text = dayText + hourText + String(dateComponents.minute) + "m "
            
            
        }
        
        //        } else {
        //            waitLabel.text = "Ended"
        //        }
    }
    
    
    func alertEventFinished(){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("touchesBegan")
        //        activeTextField.resignFirstResponder()
        
    }
    
    
    @objc func timerDecrease(){
        seconds = seconds! - 1
        if(seconds! <= 0){
            seconds = 60
            compareEventStar()
        }
    }
    

}

// MARK: - Share Event & Add Favori
extension EventDetail {
    @objc func shareAction(sender:UIButton!) {
        let textToShare = "Join me at this Event!!"
        
        if let myEvent = NSURL(string: "\(self.eventUrl!)/\(self.eventID!)") {
            let objectsToShare = [textToShare, myEvent] as [Any]
            let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
            
            activityVC.popoverPresentationController?.sourceView = sender
            self.present(activityVC, animated: true, completion: nil)
        }
    }
    
    @objc func favoriteAction(sender:UIButton!) {
        print("Add Favorito")
    }
}


