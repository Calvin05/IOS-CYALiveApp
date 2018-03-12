//
//  StageViewController.swift
//  Cya
//
//  Created by Jose Ivan Salazar on 10/05/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import WebKit
import AVKit
import youtube_ios_player_helper


class StageViewController: UIViewController, YTPlayerViewDelegate{
    
    var viewContent: UIView = UIView()
    var backButtonView: BackButtonView?
    var socketLoaded: Bool = false
    var chatServicesStage:ChatService?
    var syncService: SyncService?
    var eventService: EventService?
    var castService: CastService?
    var sigService: SigService?
    
    var acceptInterviewModal: AcceptInterviewModal?
    var interviewModal: InterviewModal?
    var joinStageModal: JoinStageModal?
    
    let viewNotification:UIView = UIView ();
    
    @IBOutlet var mainView: UIView!
    var wvStages: UIWebView = UIWebView()
    var vStageYoutubeTransp: UIView = UIView()
    var vStageYouTube: YTPlayerView = YTPlayerView()
    var vStageLive: UIView = UIView()
    var ivStageImage: UIImageView = UIImageView()
    var vStageMovie: UIView = UIView()
    var eventDescription: DescriptionView = DescriptionView()
//    var eventDescription: UITextView = UITextView()
    var statusStageView: StatusStageView?
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    var chatContainer: UIView = UIView()
    var viewersContainer: UIView = UIView()
    var viewerView: ViewerView?
    
    var playerMovie: AVPlayer?
    var playerLive : AVPlayer?
    var playerYoutube : AVPlayer?
    
    var playerLayerMovie: AVPlayerLayer?
    var playerLayerLive: AVPlayerLayer?
    var youtubeIsLoaded: Bool = false
    
    var eventContentDisplayObject: EventContentDisplayObject?
    
    var movieContent: ContentDisplayObject?
    var liveContent: ContentDisplayObject?
    var imageContent: ContentDisplayObject?
    var youtubeContent: ContentDisplayObject?
    
    var castEventService: EventServiceDisplayObject?
    var chatEventService: EventServiceDisplayObject?
    var syncEventService: EventServiceDisplayObject?
    
    var eventInfo: Event?
    var syncData: [String: Any] = [:]
    
    
    // Constantes
    let aspectRatio = AspectRatio(aspect: "HD Video")
    let aspectRatioSM = AspectRatio(aspect: "Standar Monitor")
    
    // Variables
    var constraintsToApply = [NSLayoutConstraint]()
    var landscapeConstraints = [NSLayoutConstraint]()
    var screenWidth : CGFloat = 0.0
    var halfScreenWidth: CGFloat = 0.0
    var activeTransType = "movie"
    
    var eventId: String?
    
    
    init(sigService: SigService, eventId: String) {
        super.init(nibName: nil, bundle: nil)
        view.backgroundColor = UIColor.cyaDarkBg
        
        self.eventId = eventId
        
        self.eventService = EventService()
        
        self.sigService = sigService
        
        self.vStageYouTube.delegate = self
        self.screenWidth = self.view.frame.size.width
        self.halfScreenWidth = self.screenWidth / 2
        
        self.setViewContent()
        self.setStagePelicula()
        self.setStageImagen()
        self.setStageYoutube()
        self.setStageLive()
        self.setwvStages()
        self.loadUrlWvStages()
        self.loadPopUpInterview()
        self.setLayoutBottomBar()
        self.setEventDescription()
        self.setStatusStageText()
        self.setViewersContainer()
        self.setChatContainer()
        
        
        self.sigService?.getViewers()
        
        self.setBackButton()
        
        self.eventService?.getEvent2(eventId: self.eventId!){data, err in
            self.eventInfo = data
            if(self.eventInfo != nil && self.eventInfo?.description != nil){
                DispatchQueue.main.async {
                    self.eventDescription.setCurrenView(data: (self.eventInfo?.description)!)
                }
            }
        }
        
        self.eventService?.getEventContents2(eventId: self.eventId!){data, err in
            if(err != nil ){
                self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
            }else{
                self.eventContentDisplayObject = data
                self.setContents()
                self.setSockets()
            }
        }
        
    }
    
    func setSockets(){
        self.chatServicesStage = ChatService(sessionId: (self.chatEventService?.session_id)!)
        DispatchQueue.main.async {
            if(self.chatServicesStage !=  nil){
                self.toolBarMenu.setChatService(chatService: self.chatServicesStage!)
            }
        }
        
        self.syncService = SyncService(sessionId: (self.syncEventService?.session_id)!)
        self.loadSocketSyncOn()
        
        self.castService = CastService(sid: (self.castEventService?.session_id)!, eventId: self.eventId!, webToken: (self.eventContentDisplayObject?.token)!)
        
        self.setPopUpInterviewServices()
        
        self.statusStageView?.setCastService(castService: self.castService!)
        
        self.socketLoaded = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(self.socketLoaded){
            self.setSockets()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
//        self.eventService?.getEvent2(eventId: self.eventId!){data, err in
//            self.eventInfo = data
//            self.setContents()
//        }
        
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) {_ in
            if UIDevice.current.orientation.isLandscape {
                self.landscapeSettings()
            } else {
                self.portraitSettings()
            }
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        if(self.playerMovie != nil){
            playerMovie?.pause()
        }
        
        if(self.youtubeIsLoaded){
            vStageYouTube.pauseVideo()
        }
        
        if(self.playerLive != nil){
            playerLive?.pause()
        }
        syncService?.socket.disconnect()
        syncService = nil
        chatServicesStage?.socket.disconnect()
        chatServicesStage = nil
        castService?.socket.disconnect()
        castService = nil
    }
    
    func setBackButton(){
        
        self.backButtonView = BackButtonView()
        self.backButtonView?.setParent(parent: self)
        view.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: viewContent.topAnchor).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func loadPopUpInterview(){
        self.acceptInterviewModal = AcceptInterviewModal()
        self.interviewModal = InterviewModal()
        self.interviewModal?.interviewModalDelegate = self
        self.joinStageModal = JoinStageModal()
        self.joinStageModal?.modalExpiredDelegate = self
    }
    
    func setPopUpInterviewServices(){
        self.acceptInterviewModal?.setCastService(castService: self.castService!)
        self.interviewModal?.setCastService(castService: self.castService!)
        self.joinStageModal?.setCastService(castService: self.castService!)
        
        castService!.onInterviewCalled(handler: {data, ack in
            self.acceptInterviewModal?.modalPresentationStyle = .overCurrentContext
            self.present(self.acceptInterviewModal!, animated: true, completion: nil)
        })
        
        castService!.onInterviewAnswered(handler: {data, ack in
            self.interviewModal?.modalPresentationStyle = .overCurrentContext
            self.present(self.interviewModal!, animated: true, completion: nil)
        })
        
        castService!.onPushed(handler: {data, ack in
            self.joinStageModal?.modalPresentationStyle = .overCurrentContext
            self.present(self.joinStageModal!, animated: true, completion: nil)
        })
    }
    
    func setStatusStageText(){
        statusStageView = StatusStageView()
        
        statusStageView?.setSigService(sigService: self.sigService!)
        self.view.addSubview(statusStageView!)
        
        setStatusStageTextConstraint()
    }
    
    func setStatusStageTextConstraint(){
        
        statusStageView!.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        statusStageView!.topAnchor.constraint(equalTo: wvStages.bottomAnchor, constant: 0).isActive = true
        statusStageView!.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        statusStageView!.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        statusStageView!.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
    }
    
    func setChatContainer(){
        chatContainer.isHidden = true
        chatContainer.backgroundColor = UIColor.clear
        chatContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(chatContainer)
        
        chatContainer.topAnchor.constraint(equalTo: vStageMovie.bottomAnchor, constant: 0).isActive = true
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
        
    }
    
    func setViewersContainer(){
        
        
        viewersContainer.isHidden = true
        viewersContainer.backgroundColor = UIColor.clear
        viewersContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(viewersContainer)
        
        viewersContainer.topAnchor.constraint(equalTo: vStageMovie.bottomAnchor, constant: 0).isActive = true
        viewersContainer.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0).isActive = true
        viewersContainer.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0).isActive = true
        viewersContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        
        
        let layout = UICollectionViewFlowLayout()
        self.viewerView = ViewerView(collectionViewLayout: layout)
        self.viewerView?.setSigService(sigService: sigService!)
        addChildViewController(viewerView!)
        
        viewersContainer.addSubview(viewerView!.view)
        viewerView!.view.translatesAutoresizingMaskIntoConstraints = false
        
        viewerView!.view.topAnchor.constraint(equalTo: viewersContainer.topAnchor, constant: 20).isActive = true
        viewerView!.view.leftAnchor.constraint(equalTo: viewersContainer.leftAnchor, constant: 40).isActive = true
        viewerView!.view.rightAnchor.constraint(equalTo: viewersContainer.rightAnchor, constant: -40).isActive = true
        viewerView!.view.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: -20).isActive = true
        
        viewerView!.didMove(toParentViewController: self)
        
    }
    
    
    func setLayoutBottomBar(){
        toolBarMenu.toolBarMenuDelegate = self
        
        toolBarMenu.setCurrenView(currentView: "Stage")
        toolBarMenu.setParentView(parentView: self)
        self.view.addSubview(toolBarMenu)
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
    

    // Layout Settings...
    //
    
    func portraitSettings(){
        self.navigationController?.navigationBar.isHidden = true
        wvStages.isHidden = false
        statusStageView?.isHidden = false
        NSLayoutConstraint.deactivate(landscapeConstraints)
        setStagePelicula()
        setStageImagen()
        setStageYoutube()
        setStageLive()
        self.view.layoutIfNeeded()
        self.setLayer()
        self.setBackButton()
    }

    func landscapeSettings(){
        self.navigationController?.navigationBar.isHidden = true
        wvStages.isHidden = true
        statusStageView?.isHidden = true
        
        let trailingC = vStageMovie.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let bottomC = vStageMovie.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        landscapeConstraints.append(trailingC)
        landscapeConstraints.append(bottomC)

        let youtubeTrailingC = vStageYouTube.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let youtubeBottomC = vStageYouTube.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        landscapeConstraints.append(youtubeTrailingC)
        landscapeConstraints.append(youtubeBottomC)

        let youtubeTrailingCTransp = vStageYoutubeTransp.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let youtubeBottomCTransp = vStageYoutubeTransp.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        landscapeConstraints.append(youtubeTrailingCTransp)
        landscapeConstraints.append(youtubeBottomCTransp)

        let liveTrailingC = vStageLive.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let liveBottomC = vStageLive.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        landscapeConstraints.append(liveTrailingC)
        landscapeConstraints.append(liveBottomC)

        let imageTrailingC = ivStageImage.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0)
        let imageBottomC = ivStageImage.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        landscapeConstraints.append(imageTrailingC)
        landscapeConstraints.append(imageBottomC)

        NSLayoutConstraint.activate(landscapeConstraints)
        self.view.layoutIfNeeded()
        self.setLayer()
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.clear
    }
    
    func setStagePelicula(){
        vStageMovie.backgroundColor = UIColor.black
        view.addSubview(vStageMovie)
        
        vStageMovie.translatesAutoresizingMaskIntoConstraints = false
        
        vStageMovie.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vStageMovie.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        vStageMovie.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(screenWidth) )
        vStageMovie.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
    }
    
    func setStageImagen(){
        ivStageImage.backgroundColor = UIColor.black
        view.addSubview(ivStageImage)
        
        ivStageImage.translatesAutoresizingMaskIntoConstraints = false
        
        ivStageImage.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        ivStageImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        ivStageImage.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(screenWidth) )
        ivStageImage.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
    }
    
    func setStageYoutube(){
        vStageYouTube.backgroundColor = UIColor.black
        view.addSubview(vStageYoutubeTransp)
        view.addSubview(vStageYouTube)
        
        vStageYouTube.translatesAutoresizingMaskIntoConstraints = false
        
        vStageYouTube.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vStageYouTube.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        vStageYouTube.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(screenWidth) )
        vStageYouTube.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        
        vStageYoutubeTransp.backgroundColor = UIColor(white: 1, alpha: 0)
//        mainView.bringSubview(toFront: vStageYoutubeTransp)
        
        vStageYoutubeTransp.translatesAutoresizingMaskIntoConstraints = false
        
        vStageYoutubeTransp.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vStageYoutubeTransp.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        vStageYoutubeTransp.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9Transp = aspectRatio.getHeightFromWidth(elementWidth: Float(screenWidth) )
        vStageYoutubeTransp.heightAnchor.constraint(equalToConstant: CGFloat(height16_9Transp)).isActive = true
    }
    
    func setStageLive(){
        vStageLive.backgroundColor = UIColor.black
        view.addSubview(vStageLive)
        
        vStageLive.translatesAutoresizingMaskIntoConstraints = false
        
        vStageLive.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        vStageLive.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        vStageLive.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(screenWidth) )
        vStageLive.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
    }
    
    func loadUrlWvStages(){
        let eventHelper: EventHelper = EventHelper()
        
        eventHelper.getUrlMainStage(eventId: eventId!, userId: UserDisplayObject.userId){data, err in
            DispatchQueue.main.async {
                if(err != nil){
                    self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
                }else{
                    self.wvStages.loadRequest(URLRequest(url: data!))
                }
                    
                
            }
        }
    }
    
    func setwvStages(){
        view.addSubview(wvStages)
        wvStages.translatesAutoresizingMaskIntoConstraints = false
        wvStages.topAnchor.constraint(equalTo: vStageMovie.bottomAnchor, constant: 0).isActive = true
        wvStages.widthAnchor.constraint(equalToConstant: screenWidth).isActive = true
        let height16_9 = aspectRatioSM.getHeightFromWidth(elementWidth: Float(screenWidth))
        wvStages.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        wvStages.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
    }
    
    
    
    func setEventDescription(){
        view.addSubview(eventDescription)
        eventDescription.isHidden = true
        eventDescription.topAnchor.constraint(equalTo: vStageMovie.bottomAnchor, constant: 0).isActive = true
        eventDescription.leadingAnchor.constraint(equalTo:self.view.leadingAnchor, constant: 0).isActive = true
        eventDescription.trailingAnchor.constraint(equalTo:self.view.trailingAnchor, constant: 0).isActive = true
        eventDescription.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
    }
    
    func loadSocketSyncOn(){
        self.onStateUpdate()
        self.onJoinRoom()
    }
    
    func onStateUpdate(){
        syncService?.onStateUpdate(handler: {data, ack in
            self.syncData = data![0] as! [String: AnyObject]
            self.switchMode()
        })
    }
    
    func onJoinRoom(){
        syncService?.onJoinRoom(handler: {data, ack in
            self.syncData = data![0] as! [String: AnyObject]
            self.switchMode()
        })
    }
    
    func switchMode(){
        
        vStageMovie.isHidden = true
        vStageYouTube.isHidden = true
        vStageYoutubeTransp.isHidden = true
        vStageLive.isHidden = true
        ivStageImage.isHidden = true
        
        if(self.playerMovie != nil && self.syncData["mode"] as! String != "movie"){
            playerMovie?.pause()
        }
        
        if(self.youtubeIsLoaded && self.syncData["mode"] as! String != "youtube"){
            vStageYouTube.pauseVideo()
        }
        
        if(self.playerLive != nil && self.syncData["mode"] as! String != "live"){
            playerLive?.pause()
        }
        
        switch(syncData["mode"] as! String){
        case "image":
            ivStageImage.isHidden = false
            self.showImage()
        case "movie":
            vStageMovie.isHidden = false
            self.playMovie()
        case "live":
            vStageLive.isHidden = false
            self.playLive()
        case "youtube":
            vStageYouTube.isHidden = false
            vStageYoutubeTransp.isHidden = false
            self.playYoutube()
        default:
            ivStageImage.isHidden = false
        }
    }
    
    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {
//        if(self.syncData["mod_play"] == "true"){
//            vStageYouTube.playVideo()
//        }
    }
    
    func playYoutube(){
        let youtube: [String: Any] = syncData["youtube"] as! [String: Any]
        
        if(!self.youtubeIsLoaded){
            vStageYouTube.load(withVideoId: (self.youtubeContent?.data)!, playerVars:
                ["playsinline": 1 as AnyObject,
                 "showinfo": 0 as AnyObject,
                 "controls": 0 as AnyObject,
                 "disablekb": 1 as AnyObject,
                 "fs": 0 as AnyObject,
                 "modestbranding": 1 as AnyObject,
                 "iv_load_policy": 3 as AnyObject,
                 "rel": 0 as AnyObject
                ])
            
            self.youtubeIsLoaded = true
        }else {
            if(youtube["time"] != nil){
                vStageYouTube.seek(toSeconds: youtube["time"] as! Float, allowSeekAhead: true)
            }
            
            if(youtube["isPlaying"] as! Int == 0){
                vStageYouTube.pauseVideo()
            }else{
                vStageYouTube.playVideo()
            }
        }
    
    }
    
    func showImage(){
        
        let image: [String: Any] = syncData["image"] as! [String: Any]
        var urlStr: String = ""
        var isUrl: Bool = true
        
        if(self.imageContent?.data != nil && self.imageContent?.data! != ""){
            urlStr = (self.imageContent?.data)!
        }else if((image["url"]) != nil && image["url"] as! String != ""){
            urlStr = image["url"] as! String
        }else if (self.eventInfo?.cover != nil && self.eventInfo?.cover! != ""){
            urlStr = (self.eventInfo?.cover!)!
        }else{
            let image = UIImage(named: "cover_img_placeholder")
            self.ivStageImage.image = image
            isUrl = false
        }
        
        if(isUrl){
            let url = URL(string: urlStr)!
            
            let task = URLSession.shared.dataTask(with: url){ (data, res, err) in
                
                if(data != nil){
                    let image = UIImage(data: data!)
                    if(image != nil){
                        DispatchQueue.main.async(execute: {
                            self.ivStageImage.image = image
                        })
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func setContents(){
        
        for contentDisplayObject: ContentDisplayObject in (eventContentDisplayObject!.contents)!{
            if(contentDisplayObject.type == "movie-hls"){
                self.movieContent = contentDisplayObject
            }
            if(contentDisplayObject.type == "image"){
                self.imageContent = contentDisplayObject
            }
            if(contentDisplayObject.type == "restream-hls"){
                self.liveContent = contentDisplayObject
            }
            if(contentDisplayObject.type == "youtube"){
                self.youtubeContent = contentDisplayObject
            }
        }

        for eventServiceDisplayObject: EventServiceDisplayObject in (eventContentDisplayObject!.services)!{
            if(eventServiceDisplayObject.name == "cast"){
                self.castEventService = eventServiceDisplayObject
            }
            if(eventServiceDisplayObject.name == "chat"){
                self.chatEventService = eventServiceDisplayObject
            }
            if(eventServiceDisplayObject.name == "sync"){
                self.syncEventService = eventServiceDisplayObject
            }
        }
    }
    
    func playLive(){
        
        if(self.playerLive == nil){
            
            playerLive = AVPlayer(url: URL(string: (self.liveContent?.data)!)!)
            
            self.playerLayerLive = AVPlayerLayer(player: playerLive)
            
            playerLayerLive?.frame = vStageLive.bounds
            
            vStageLive.layer.addSublayer(self.playerLayerLive!)
        }
        
        playerLive?.play()
        
    }
    
    func playMovie(){
        let movie: [String: Any] = syncData["movie"] as! [String : Any]
        
        if(self.playerMovie == nil){
            
            playerMovie = AVPlayer(url: URL(string: (self.movieContent?.data)!)!)
            
            self.playerLayerMovie = AVPlayerLayer(player: playerMovie)
            
            playerLayerMovie?.frame = vStageMovie.bounds
            
            vStageMovie.layer.addSublayer(self.playerLayerMovie!)
        }
        
        if(movie["time"] != nil){
            playerMovie?.seek(to: CMTimeMakeWithSeconds(movie["time"] as! Double, (playerMovie?.currentItem?.asset.duration.timescale)!))
        }
        
        if(movie["isPlaying"] as! Int == 0){
            playerMovie?.pause()
        }else{
            playerMovie?.play()
        }
    }
    
    func setLayer(){
        if(self.playerMovie != nil){
            self.playerLayerMovie?.frame = vStageMovie.bounds
        }
        
        if(self.playerLive != nil){
            self.playerLayerLive?.frame = vStageLive.bounds
        }
    }
}

extension StageViewController: ModalExpiredDelegate {
    func returnModalExpired(expired: Bool) {
        let expiredStageModal = ExpiredStageModal()
        expiredStageModal.modalPresentationStyle = .overCurrentContext
        self.present(expiredStageModal, animated: true, completion: nil)
    }
}

extension StageViewController: ToolBarMenuDelegate {
    
    func hideViews(){
        wvStages.isHidden = true
        statusStageView?.isHidden = true
        eventDescription.isHidden = true
        chatContainer.isHidden = true
        viewersContainer.isHidden = true
    }
    
    func infoButtonAction() {
        hideViews()
        eventDescription.isHidden = false
    }
    
    func chatButtonAction() {
        chatContainer.isHidden = false
    }
    
    func stageButtonAction() {
        hideViews()
        wvStages.isHidden = false
        statusStageView?.isHidden = false
    }
    
    func viewersButtonAction() {
        hideViews()
        viewersContainer.isHidden = false
        viewerView?.reloadCollectionView()
    }
}

extension StageViewController: InterviewModalDelegate {
    func returnInterviewModal() {
//        setwvStages()
//        setStatusStageTextConstraint()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)        
    }
}


