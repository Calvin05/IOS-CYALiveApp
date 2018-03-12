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
    var appConfig: NSMutableDictionary!
    var eventUrl: String!
    
    
    //    private var viewContent: UIScrollView = UIScrollView()
    var backButtonView: BackButtonView?
    var waitLabel: EdgeInsetLabel = EdgeInsetLabel()
    var window: UIWindow?
    var isLoginUse: Bool = false
    var viewBack: UIView = UIView()
    
    var viewContent: UIView = UIView()
    var viewHeader: ViewHeaderDetail = ViewHeaderDetail()
    
//    var contentAvatars : UIView = UIView()
    var contentAvatars : UIView = UIView()
    var avatarView: AvatarView?
    var avatarDefault: Role =  Role()
    var sigService: SigService?
    
    
    var userAvatars: [ViewAvatarInfoDetail] = []
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
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        eventUrl = appConfig.value(forKey: "eventUrl") as! String
        
        self.sigService = SigService(eventId: self.eventID!)
        loadSocketSigOn()
        
        detailEvent = _eventService.getEvent(eventId: (self.eventID)!)
        initView()

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        self.sigService?.socket.disconnect()
//        self.sigService = nil
        
        self.viewHeader.playerMovie?.pause()
        UIApplication.shared.statusBarStyle = UIStatusBarStyle.default
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        print("---------viewDidAppear")
        if(detailEvent.trailer != nil && (detailEvent.trailer)! != "" && detailEvent.trailer != "Unknown Type: string,null"){
            viewHeader.playVideo()
        }
        if(self.isError){
            self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
            self.isError = false
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
        
        toolBarMenuBackground.backgroundColor = UIColor.darkGray
        
        btnBuy.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        viewShared.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        
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
        setBackButton()
        setViewHeader()
        setWaitLabel()
        setContentAvatars()
        setViewInfoDetail()
        setBtnBuy()
        setViewShared()
        setShareBtn()
        setFavoriteBtn()
        setLayoutBottomBar()
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
    
    func setBackButton(){
        
        self.backButtonView = BackButtonView()
        self.backButtonView?.setParent(parent: self)
        viewContent.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.white
        
    }
    

    
    func setViewHeader(){
        viewContent.addSubview(viewHeader)
        
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(self.view.frame.size.width) )
        
        viewHeader.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 50 ).isActive = true
        viewHeader.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        viewHeader.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        viewHeader.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        
        
        if(self.detailEvent.trailer != nil && (self.detailEvent.trailer)! != "" && self.detailEvent.trailer != "Unknown Type: string,null"){
            viewHeader.setCurrenView(currentView: "video", data: (self.detailEvent.trailer)!)
        }else if (self.detailEvent.thumbnail != nil && self.detailEvent.thumbnail != ""){
            viewHeader.setCurrenView(currentView: "image", data: (self.detailEvent.thumbnail)!)
        }else {
            viewHeader.setCurrenView(currentView: "image", data: "default")

        }
    }
    
    func setWaitLabel(){
        view.addSubview(waitLabel)
        
        waitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //        waitLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        waitLabel.topAnchor.constraint(equalTo: backButtonView!.bottomAnchor).isActive = true
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

    
    func setContentAvatars(){
        
        viewContent.addSubview(contentAvatars)

        contentAvatars.topAnchor.constraint(equalTo: viewHeader.bottomAnchor, constant: 2).isActive = true
        contentAvatars.heightAnchor.constraint(equalToConstant: 160).isActive = true
        contentAvatars.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        contentAvatars.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        contentAvatars.translatesAutoresizingMaskIntoConstraints    = false
        
        contentAvatars.backgroundColor = UIColor.cyaLightGrayBg
        
        let layout = UICollectionViewFlowLayout()
        self.avatarView = AvatarView(collectionViewLayout: layout, avatarArray: (detailEvent.roles)!)
        addChildViewController(avatarView!)
        
        contentAvatars.addSubview(avatarView!.view)
        avatarView!.view.translatesAutoresizingMaskIntoConstraints = false
        
        avatarView!.view.topAnchor.constraint(equalTo: contentAvatars.topAnchor, constant: 0).isActive = true
        avatarView!.view.leftAnchor.constraint(equalTo: contentAvatars.leftAnchor, constant: 0).isActive = true
        avatarView!.view.rightAnchor.constraint(equalTo: contentAvatars.rightAnchor, constant: 0).isActive = true
        avatarView!.view.bottomAnchor.constraint(equalTo: contentAvatars.bottomAnchor, constant: 0).isActive = true
        
        avatarView!.didMove(toParentViewController: self)
        
        
    }
    
    func setViewInfoDetail(){
        viewContent.addSubview(viewInfoDetail)
        
        let _wContent: Float =  Float(self.view.frame.size.width)
        
        viewInfoDetail.topAnchor.constraint(equalTo: contentAvatars.bottomAnchor, constant: 10).isActive = true
        viewInfoDetail.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        viewInfoDetail.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        viewInfoDetail.translatesAutoresizingMaskIntoConstraints    = false
        
//        viewInfoDetail.setInfo(wContent: _wContent)
        viewInfoDetail.setCurrenView(data: self.detailEvent)
        
    }
    func setBtnBuy(){
        
        viewContent.addSubview(btnBuy)
        
        btnBuy.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        btnBuy.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnBuy.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
//        btnBuy.bottomAnchor.constraint(equalTo: toolBarMenu.bottomAnchor, constant: -50).isActive = true
        btnBuy.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnBuy.titleLabel!.font = FontCya.CyaTextButton
        btnBuy.setTitleColor(.Cya_Button_White_Normal, for: .normal)
        btnBuy.backgroundColor = .Cya_Primary_Color
        
        let isDateEvent = compareEventDate(dateEvent: detailEvent.end_at!)
        
        if (!isDateEvent){
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecrease), userInfo: nil, repeats: true)
            customerBtnBuy()
        }else {
           actionInvisible()
        }
        
        
//        customerBtnBuy()
        
    }
    
    func setViewShared(){
        viewContent.addSubview(viewShared)
        
        viewShared.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        viewShared.heightAnchor.constraint(equalToConstant: 50).isActive = true
        viewShared.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
//        viewShared.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -50).isActive = true
        viewShared.translatesAutoresizingMaskIntoConstraints = false
        
        viewShared.backgroundColor =  UIColor.cyaLightGrayBg
    }
    
    
    func setShareBtn(){
        viewShared.addSubview(shareBtn)
        
        shareBtn.rightAnchor.constraint(equalTo: viewShared.centerXAnchor, constant: 0).isActive = true
        shareBtn.leftAnchor.constraint(equalTo: viewShared.leftAnchor, constant: 0).isActive = true
        shareBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        shareBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        shareBtn.centerYAnchor.constraint(equalTo: viewShared.centerYAnchor, constant: 0).isActive = true
        shareBtn.translatesAutoresizingMaskIntoConstraints          = false
        
        shareBtn.setImage(UIImage(named: "cya_shared"), for: .normal)
        shareBtn.imageView?.contentMode = .scaleAspectFit
        shareBtn.addTarget(self, action: #selector(shareAction), for: .touchUpInside)
        shareBtn.tintColor = UIColor.cyaMagenta
    }
    func setFavoriteBtn(){
        viewShared.addSubview(favoriteBtn)
        
        favoriteBtn.leftAnchor.constraint(equalTo: viewShared.centerXAnchor, constant: 0).isActive = true
        favoriteBtn.rightAnchor.constraint(equalTo: viewShared.rightAnchor, constant: 0).isActive = true
        favoriteBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteBtn.widthAnchor.constraint(equalToConstant: 30).isActive = true
        favoriteBtn.centerYAnchor.constraint(equalTo: viewShared.centerYAnchor, constant: 0).isActive = true
        favoriteBtn.translatesAutoresizingMaskIntoConstraints       = false
        
        favoriteBtn.setImage(UIImage(named: "cya_favorites"), for: .normal)
        favoriteBtn.imageView?.contentMode = .scaleAspectFit
        favoriteBtn.addTarget(self, action: #selector(favoriteAction), for: .touchUpInside)
        
    }
    
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
            let viewcontroller : UIViewController = PreStageController(sigService: self.sigService!, eventId: self.detailEvent.id!)
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


