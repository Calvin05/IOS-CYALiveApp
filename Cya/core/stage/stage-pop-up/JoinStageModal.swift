//
//  joinStageModal.swift
//  Cya
//
//  Created by Rigo on 25/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//
protocol ModalExpiredDelegate: class {
    func returnModalExpired(expired: Bool)
    func aceptPuplish()
}

import UIKit

class JoinStageModal: UIViewController {
    
    
    // MARK: -  Components
    private let textHeader: EdgeInsetLabel = EdgeInsetLabel()
    private let textJoin: EdgeInsetLabel = EdgeInsetLabel()
    private let btnAcept = UIButton(type: .system) as UIButton
    private let btnCancel = UIButton(type: .system) as UIButton
    private let contentView: UIView = UIView()
    var castService: CastService?
    weak var modalExpiredDelegate: ModalExpiredDelegate?
    
    var seconds: Int? = 15
    var timer = Timer()
    
    func setCastService(castService: CastService){
        self.castService = castService
        self.loadSocketCastOn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        seconds = 15
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.isOpaque = true
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDecrease), userInfo: nil, repeats: true)
    }
    
    @objc func timerDecrease(){
        seconds = seconds! - 1
        textJoin.text = "Expires in \(self.seconds!) seconds"
        if(seconds! <= 0){
            timer.invalidate()
//            castService!.declineStage()
            castService!.leaveStage()
            dismiss(animated: true, completion: {
                self.modalExpiredDelegate?.returnModalExpired(expired: true)
                self.invalidateTimer()
            })
        }
    }
    
    func invalidateTimer(){
        timer.invalidate()
        seconds = 15
        textJoin.text = "Expires in \(self.seconds!) seconds"
    }
    
    func loadSocketCastOn(){
        self.onKicked()
    }
    
    func onKicked(){
        castService!.onKicked(handler: {data, ack in
            self.invalidateTimer()
            self.dismiss(animated: true, completion: nil)
        })
    }
    
}



// MARK: -  Setup Components

extension JoinStageModal {
    
    func setupView(){
        settingsComponents()
        addSubViews()
        viewConstraint()
    }
    
    func settingsComponents(){
        
        // Change UIView background colour
        contentView.backgroundColor = UIColor.clear
        contentView.layer.cornerRadius = 25
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.clear.cgColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        textHeader.text = "Ready to join the Stage?"
        textHeader.font = UIFont(name: "Avenir-Book", size: 27)
        textHeader.topTextInset = 10
        textHeader.leftTextInset = 0
        textHeader.bottomTextInset = 10
        textHeader.rightTextInset = 0
        textHeader.backgroundColor = .clear
        textHeader.alpha = 0.9
        textHeader.textColor = .lightGray
        textHeader.textAlignment = .center
        
        textHeader.numberOfLines = 0
        textHeader.lineBreakMode = .byWordWrapping
        textHeader.sizeToFit()
        textHeader.translatesAutoresizingMaskIntoConstraints = false
        
        
        textJoin.text = "Expires in \(self.seconds!) seconds"
        textJoin.font = FontCya.CyaBody
        textJoin.backgroundColor = .clear
        textJoin.alpha = 0.9
        textJoin.textColor = .lightGray
        textJoin.textAlignment = .center
        
        textJoin.numberOfLines = 0
        textJoin.lineBreakMode = .byWordWrapping
        textJoin.sizeToFit()
        textJoin.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnAcept.setTitle("Join", for: .normal)
        btnAcept.setTitleColor(.lightGray, for: .normal)
        btnAcept.titleLabel?.font = FontCya.CyaTextButtonXXL
        btnAcept.addTarget(self, action: #selector(btnAccept), for: .touchUpInside)
        btnAcept.translatesAutoresizingMaskIntoConstraints = false
        btnAcept.layer.borderColor = UIColor.red.cgColor
        btnAcept.layer.cornerRadius = 100
        btnAcept.layer.borderWidth = 2
        btnAcept.layer.masksToBounds = true
        
        btnCancel.setTitle("Cancel", for: .normal)
        btnCancel.setTitleColor(.red, for: .normal)
        btnCancel.titleLabel?.font = FontCya.CyaTextButtonSmall
        btnCancel.addTarget(self, action: #selector(btnCancelModal), for: .touchUpInside)
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        btnCancel.layer.borderColor = UIColor.lightGray.cgColor
        btnCancel.layer.borderWidth = 0
        btnCancel.layer.masksToBounds = true
        
        
        
    }
    
    func addSubViews(){
        self.view.addSubview(contentView)
        contentView.addSubview(textHeader)
        contentView.addSubview(btnAcept)
        contentView.addSubview(textJoin)
        contentView.addSubview(btnCancel)
    }
}

// MARK: -  Setup Constraint
extension JoinStageModal {
    
    func viewConstraint(){
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        textHeader.bottomAnchor.constraint(equalTo: btnAcept.topAnchor, constant: -50).isActive = true
        textHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        textHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        btnAcept.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnAcept.heightAnchor.constraint(equalToConstant: 200).isActive = true
        btnAcept.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnAcept.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        textJoin.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textJoin.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textJoin.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textJoin.topAnchor.constraint(equalTo: btnAcept.topAnchor, constant: 125).isActive = true
        
 
        btnCancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnCancel.topAnchor.constraint(equalTo: textJoin.bottomAnchor, constant: -80).isActive = true
   
    }
    
}

// MARK: -  Actions Buttons
extension JoinStageModal {
    @objc func closeModal(sender:UIButton!) {
        castService!.declineStage()
        self.invalidateTimer()
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func btnAccept(sender:UIButton!) {
        castService!.acceptStage()
        self.invalidateTimer()
        dismiss(animated: true, completion: {
            self.modalExpiredDelegate?.aceptPuplish()
        })
        
    }
    
    @objc func btnCancelModal(sender:UIButton!) {
        castService!.leaveStage()
        self.invalidateTimer()
        dismiss(animated: true, completion: nil)
    }
    
    
}


