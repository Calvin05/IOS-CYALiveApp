//
//  acceptInterviewModal.swift
//  Cya
//
//  Created by Rigo on 24/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class AcceptInterviewModal: UIViewController {

    
    // MARK: -  Components
    private let textHeader: EdgeInsetLabel = EdgeInsetLabel()
    private let btnAcept = UIButton(type: .custom) as UIButton
    private let btnCancel = UIButton(type: .custom) as UIButton
    private let contentView: UIView = UIView()
    var castService: CastService?
    var acceptAgain: Bool = true
    
    func setCastService(castService: CastService){
        self.castService = castService
        self.loadSocketCastOn()
    }
    
    func loadSocketCastOn(){
        self.onInterviewDeclined()
        
        //Ver si se usa al parecer solo moderador
        castService!.onSessionJoin(handler: {data, ack in
        })
        
        castService!.onModList(handler: {data, ack in
        })
        
        castService!.onSubscribed(handler: {data, ack in
        })
        
        castService!.onInterviewHangup(handler: {data, ack in
        })

    }
    
    func onInterviewDeclined(){
        castService!.onInterviewDeclined(handler: {data, ack in
            self.dismiss(animated: true, completion: nil)
        })
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
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.black.withAlphaComponent(0.85)
        view.isOpaque = true
    }

}



// MARK: -  Setup Components

extension AcceptInterviewModal {
    
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
        
        textHeader.text = "CONGRATULATIONS! You have been accepted to go live."
        textHeader.font = UIFont(name: "Avenir-Book", size: 23)
        textHeader.topTextInset = 10
        textHeader.leftTextInset = 30
        textHeader.bottomTextInset = 10
        textHeader.rightTextInset = 10
        textHeader.backgroundColor = .clear
        textHeader.alpha = 0.9
        textHeader.textColor = .white
        textHeader.textAlignment = .center
        
        textHeader.numberOfLines = 0
        textHeader.lineBreakMode = .byWordWrapping
        textHeader.sizeToFit()
        textHeader.translatesAutoresizingMaskIntoConstraints = false
        
        
        btnAcept.setTitle("Accept in", for: .normal)
        btnAcept.setTitleColor(.lightGray, for: .normal)
        btnAcept.titleLabel?.font = FontCya.CyaTextButtonXL
        btnAcept.addTarget(self, action: #selector(btnAccept), for: .touchUpInside)
        btnAcept.translatesAutoresizingMaskIntoConstraints = false
        btnAcept.layer.borderColor = UIColor.lightGray.cgColor
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
        contentView.addSubview(btnCancel)
    }
}

// MARK: -  Setup Constraint
extension AcceptInterviewModal {
    
    func viewConstraint(){
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        textHeader.bottomAnchor.constraint(equalTo: btnAcept.topAnchor, constant: -80).isActive = true
        textHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        textHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        btnAcept.widthAnchor.constraint(equalToConstant: 200).isActive = true
        btnAcept.heightAnchor.constraint(equalToConstant: 200).isActive = true
        btnAcept.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnAcept.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        btnCancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnCancel.topAnchor.constraint(equalTo: btnAcept.bottomAnchor, constant: 80).isActive = true
        
    }
    
}

// MARK: -  Actions Buttons
extension AcceptInterviewModal {
    @objc func closeModal(sender:UIButton!) {
        self.acceptAgain = true
        castService!.declineInterview()
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func btnAccept(sender:UIButton!) {
        
//        castService!.onInterviewAnswered(handler: {data, ack in
//            self.dismiss(animated: true, completion: nil)
//        })
        
        castService!.answerInterview()
        
//        if(acceptAgain){
//            self.acceptAgain = false
//
//            castService!.onInterviewAnswered(handler: {data, ack in
//                self.acceptAgain = true
//                self.dismiss(animated: true, completion: nil)
//            })
//
//            castService!.onError(handler: {data, ack in
//                self.acceptAgain = true
//            })
//
//            castService!.answerInterview()
//
//
//        }
        
        
        
        
        
        
    }
    
    @objc func btnCancelModal(sender:UIButton!) {
        self.acceptAgain = true
        castService!.declineInterview()
        dismiss(animated: true, completion: nil)
    }
    
    
}

