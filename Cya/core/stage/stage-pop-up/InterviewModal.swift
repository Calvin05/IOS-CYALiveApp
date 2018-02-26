//
//  PopUpViewController.swift
//  Cya
//
//  Created by Rigo on 23/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//
protocol InterviewModalDelegate: class {
    func returnInterviewModal()
}

import UIKit

class InterviewModal: UIViewController, SPTJanusClientDelegate, RTCEAGLVideoViewDelegate {
    
    // MARK: -  Components
    private let textHeader: EdgeInsetLabel = EdgeInsetLabel()
    private let btnCancel = UIButton(type: .system) as UIButton
    private let contentView: UIView = UIView()
//    var wvStages: UIWebView?
    
    
    var localView: RTCEAGLVideoView = RTCEAGLVideoView()
    var localVideoTrack: RTCVideoTrack?
    var remoteView: RTCEAGLVideoView = RTCEAGLVideoView()
    var remoteVideoTrack: RTCVideoTrack?
    var client: SPTJanusClient?
    var clientListener: SPTJanusClient?
    
    
    var castService: CastService?
    let aspectRatioSM = AspectRatio(aspect: "Standar Monitor")
    weak var interviewModalDelegate: InterviewModalDelegate?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        client = SPTJanusClient.init(delegate: self)
        clientListener = SPTJanusClient.init(delegate: self)
        localView.delegate = self
        remoteView.delegate = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCastService(castService: CastService){
        self.castService = castService
        self.loadSocketCastOn()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.isOpaque = true
    }
    
    
    
    
    func videoView(_ videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        
    }
    
    func appClient(_ client: SPTJanusClient!, didChange state: SPTJanusClientState) {
        print(state)
    }
    
    func appClient(_ client: SPTJanusClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        self.localVideoTrack = localVideoTrack
        self.localVideoTrack?.add(localView)
    }
    
    func appClient(_ client: SPTJanusClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack?.add(remoteView)
    }
    
    
    
    func appClient(_ client: SPTJanusClient!, didError error: Error!) {
        print("error")
    }
    
    
    
    
    func loadSocketCastOn(){
        self.onApproved()
        self.onInterviewDeclined()
        self.onInterviewAnswered()
    }
    
    func onApproved(){
        castService!.onApproved(handler: {data, ack in
            self.client?.disconnect()
            self.dismiss(animated: true, completion: {
                self.interviewModalDelegate?.returnInterviewModal()
            })
        })
    }
    
    func onInterviewDeclined(){
        castService!.onInterviewDeclined(handler: {data, ack in
            self.client?.disconnect()
            self.dismiss(animated: true, completion: {
                self.interviewModalDelegate?.returnInterviewModal()
            })
        })
    }
    
    func onInterviewAnswered(){
        castService!.onInterviewAnswered(handler: {data, ack in
            self.client?.createWebRTCPeerConnection(asInitiator: true, userInfo: data as! [AnyHashable : Any])
            
            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(5000)) {
                self.clientListener?.createWebRTCPeerConnection(asInitiator: false, userInfo: data as! [AnyHashable : Any])
            }
            
        })
    }
    

}



    // MARK: -  Setup Components

extension InterviewModal {
    
    func setupView(){
        settingsComponents()
        addSubViews()
        viewConstraint()
        
        setTextHeader()
        setWebRTC()
        setButtonCancel()
    }
    
    func setTextHeader(){
        
        contentView.addSubview(textHeader)
        
        textHeader.translatesAutoresizingMaskIntoConstraints = false
        textHeader.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 30).isActive = true
        textHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 50).isActive = true
        textHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        
        textHeader.text = "CONGRATULATIONS! You have been accepted to go live."
        textHeader.font = UIFont(name: "Avenir-Book", size: 23)
        
        
        
        
        textHeader.backgroundColor = .clear
        textHeader.alpha = 0.9
        textHeader.textColor = .white
        textHeader.textAlignment = .center
        
        textHeader.numberOfLines = 0
        textHeader.lineBreakMode = .byWordWrapping
        textHeader.sizeToFit()
    }
    
    func setWebRTC(){
        contentView.addSubview(remoteView)
        contentView.addSubview(localView)
        
        remoteView.translatesAutoresizingMaskIntoConstraints = false
        localView.translatesAutoresizingMaskIntoConstraints = false
        
        remoteView.topAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -20).isActive = true
        remoteView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        remoteView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        remoteView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        remoteView.layer.cornerRadius = 100
        remoteView.layer.masksToBounds = true
        remoteView.backgroundColor = UIColor.red
        
        
        localView.bottomAnchor.constraint(equalTo: remoteView.topAnchor, constant: -20).isActive = true
        localView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        localView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        localView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        localView.layer.cornerRadius = 50
        localView.layer.masksToBounds = true
        
        localView.backgroundColor = UIColor.red
        
        
        
        
    }
    
    func setButtonCancel(){
        contentView.addSubview(btnCancel)
        
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        
        btnCancel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnCancel.topAnchor.constraint(equalTo: remoteView.bottomAnchor, constant: 30).isActive = true
        
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(.red, for: .normal)
        btnCancel.titleLabel?.font = FontCya.CyaTextButton
        btnCancel.addTarget(self, action: #selector(btnCancelModal), for: .touchUpInside)
        btnCancel.layer.borderColor = UIColor.lightGray.cgColor
        btnCancel.layer.borderWidth = 0
        btnCancel.layer.masksToBounds = true
    }
    
    func settingsComponents(){

        // Change UIView background colour
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    func addSubViews(){
        self.view.addSubview(contentView)
        
    }
}

    // MARK: -  Setup Constraint
extension InterviewModal {
    
    func viewConstraint(){
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        
    }
    
}

    // MARK: -  Actions Buttons
extension InterviewModal {
    @objc func closeModal(sender:UIButton!) {
        self.client?.disconnect()
        castService!.declineInterview()
        dismiss(animated: true, completion: {
            self.interviewModalDelegate?.returnInterviewModal()
        })
    }
    
    @objc func btnCancelModal(sender:UIButton!) {
        self.client?.disconnect()
        castService!.declineInterview()
        dismiss(animated: true, completion: {
            self.interviewModalDelegate?.returnInterviewModal()
        })
    }
    
    
}
