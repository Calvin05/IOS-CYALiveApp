//
//  StatusStageView.swift
//  Cya
//
//  Created by Cristopher Torres on 03/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class StatusStageView: UIView {
    
    var statusStageLabel: EdgeInsetLabel = EdgeInsetLabel()
    var statusStageButton = UIButton(type: .system) as UIButton
    var castService: CastService?
    var sigService: SigService?
    var status: String = "init"
    var viewers: Int = 0
    var viewersLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setStatusStage()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setCastService(castService: CastService){
        self.castService = castService
        self.loadSocketCastOn()
    }
    
    func setSigService(sigService: SigService){
        self.sigService = sigService
        self.loadSocketSigOn()
    }
    
    func loadSocketSigOn(){
        self.onEventStatus()
        self.onGetViewers()
    }
    
    func onEventStatus(){
        sigService!.onEventStatus(handler: {data, ack in
        })
    }
    
    func onGetViewers(){
        sigService?.onGetViewers(handler: {data, ack in
            var dataProperties: [String: Any] = [:]
            dataProperties = data![0] as! [String: AnyObject]
            self.viewersLabel.text = String(describing: dataProperties["count"]!)
        })
    }
    
    func loadSocketCastOn(){
        self.onRequested()
        self.onLeft()
        self.onKicked()
        self.onDeclined()
        self.onApproved()
        self.onPublished()
        self.onInterviewDeclined()
    }
    
    func onRequested(){
        castService!.onRequested(handler: {data, ack in
            self.status = "requested"
            self.setStatusStageRequested()
        })
    }
    
    func onLeft(){
        castService!.onLeft(handler: {data, ack in
            self.status = "init"
            self.setStatusStageInit()
        })
    }
    
    func onKicked(){
        castService!.onKicked(handler: {data, ack in
            self.status = "init"
            self.setStatusStageInit()
        })
    }
    
    func onDeclined(){
        castService!.onDeclined(handler: {data, ack in
            self.status = "init"
            self.setStatusStageInit()
        })
    }
    
    func onApproved(){
        castService!.onApproved(handler: {data, ack in
            self.status = "approved"
            self.setStatusStageApproved()
        })
    }
    
    func onPublished(){
        castService!.onPublished(handler: {data, ack in
            
            var dataProperties = data as! [String: Any]
            
            let uid = dataProperties["uid"]
            
            if(uid != nil){
                let userId: String = String(describing: dataProperties["uid"]!)
                if(userId == UserDisplayObject.userId){
                    self.status = "published"
                    self.setStatusStagePublished()
                }
            }
        })
    }
    
    func onInterviewDeclined(){
        castService!.onInterviewDeclined(handler: {data, ack in
            if(self.status == "approved"){
                self.setStatusStageApproved()
            }else{
                self.status = "requested"
                self.setStatusStageRequested()
            }
            
        })
    }
    
    @objc func statusStageButtonAction(sender:UIButton!) {
        switch self.status {
        
        case "init":
            self.castService?.stageRequest()
        case "requested":
            self.castService?.leaveStage()
        case "approved":
            self.castService?.leaveStage()
        case "published":
//            self.castService?.declineStage()
            self.castService?.leaveStage()
        default:
            print("default")
        }
        
    }
}

// MARK: -  Setup View
extension StatusStageView{
    
    func setStatusStage(){
        
        self.addSubview(statusStageLabel)
        self.addSubview(statusStageButton)
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        
        statusStageLabel.textColor = UIColor.lightGray
        statusStageLabel.numberOfLines = 0
        statusStageLabel.textAlignment = .center
        statusStageLabel.lineBreakMode = .byWordWrapping
        statusStageLabel.sizeToFit()
        statusStageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        statusStageLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        statusStageLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        statusStageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        statusStageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -30).isActive = true
        
        
        statusStageButton.titleLabel?.font = FontCya.CyaTextButtonSmall
        statusStageButton.setTitleColor(.cyaMagenta, for: .normal)
        statusStageButton.addTarget(self, action: #selector(statusStageButtonAction), for: .touchUpInside)
        statusStageButton.translatesAutoresizingMaskIntoConstraints = false
        
        statusStageButton.layer.masksToBounds = true
        statusStageButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        statusStageButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        statusStageButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        self.setStatusStageInit()
        self.setViewers()
    }
    
    func setStatusStageInit(){
        
        statusStageLabel.text = "Join queue for chance to get on screen!"
        
        statusStageButton.setTitle("Join Queue", for: .normal)
        statusStageButton.layer.borderColor = UIColor.cyaMagenta.cgColor
        statusStageButton.layer.cornerRadius = 15
        statusStageButton.layer.borderWidth = 1
        statusStageButton.setAttributedTitle(nil, for: .normal)
        
        statusStageButton.topAnchor.constraint(equalTo: statusStageLabel.bottomAnchor, constant: 20).isActive = true
    }
    
    func setStatusStageApproved(){
        statusStageLabel.text = "You're approved, waiting for push"
    }
    
    func setStatusStagePublished(){
        statusStageLabel.text = "You are live"
    }
    
    func setStatusStageRequested(){
        let attributes: [NSAttributedStringKey: Any] = [
            NSAttributedStringKey.underlineColor: UIColor.cyaMagenta,
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]
        
        statusStageLabel.text = "You're in queue and will be contacted when chosen"
        
        let attributesString = NSMutableAttributedString(string: "Cancel", attributes: attributes)

        statusStageButton.setAttributedTitle(attributesString, for: .normal)
        statusStageButton.topAnchor.constraint(equalTo: statusStageLabel.bottomAnchor, constant: 10).isActive = true
        
        statusStageButton.layer.borderWidth = 0
    }
    
    func setViewers(){
        self.addSubview(viewersLabel)
        
        viewersLabel.translatesAutoresizingMaskIntoConstraints = false
        
        viewersLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        viewersLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        
        viewersLabel.font = FontCya.CyaTitlesH5Light
        viewersLabel.text = String(self.viewers)
        viewersLabel.textColor = UIColor.lightGray
        viewersLabel.numberOfLines = 0
        viewersLabel.textAlignment = .right
        viewersLabel.lineBreakMode = .byWordWrapping
        viewersLabel.sizeToFit()
        
        
    }
    
}
