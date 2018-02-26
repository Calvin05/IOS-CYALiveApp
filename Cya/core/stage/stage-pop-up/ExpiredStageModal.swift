//
//  expiredStageModal.swift
//  Cya
//
//  Created by Rigo on 25/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit


class ExpiredStageModal: UIViewController {
    
    
    // MARK: -  Components
    private let textHeader: EdgeInsetLabel = EdgeInsetLabel()
    private let textJoin: EdgeInsetLabel = EdgeInsetLabel()
    private let textExpired: EdgeInsetLabel = EdgeInsetLabel()

    private let btnCancel = UIButton(type: .system) as UIButton
    private let contentView: UIView = UIView()
    
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

extension ExpiredStageModal {
    
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
        
        
        textJoin.text = "The timeout has expired"
        textJoin.font = FontCya.CyaBody
        textJoin.backgroundColor = .clear
        textJoin.alpha = 0.9
        textJoin.textColor = .lightGray
        textJoin.textAlignment = .center
        
        textJoin.numberOfLines = 0
        textJoin.lineBreakMode = .byWordWrapping
        textJoin.sizeToFit()
        textJoin.translatesAutoresizingMaskIntoConstraints = false
        
        textExpired.text = "Expired"
        textExpired.font = FontCya.CyaTextButtonXXL
        textExpired.backgroundColor = .clear
        textExpired.alpha = 0.9
        textExpired.textColor = .red
        textExpired.textAlignment = .center
        
        textExpired.numberOfLines = 0
        textExpired.lineBreakMode = .byWordWrapping
        textExpired.sizeToFit()
        textExpired.translatesAutoresizingMaskIntoConstraints = false
        
        
        
        btnCancel.setTitle("Ok", for: .normal)
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
        contentView.addSubview(textExpired)
        contentView.addSubview(textJoin)
        contentView.addSubview(btnCancel)
    }
}

// MARK: -  Setup Constraint
extension ExpiredStageModal {
    
    func viewConstraint(){
        
        contentView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        contentView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        contentView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        
        
        textHeader.bottomAnchor.constraint(equalTo: textExpired.topAnchor, constant: -130).isActive = true
        textHeader.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 30).isActive = true
        textHeader.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30).isActive = true
        
        textExpired.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textExpired.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textExpired.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        
        textJoin.widthAnchor.constraint(equalToConstant: 300).isActive = true
        textJoin.heightAnchor.constraint(equalToConstant: 200).isActive = true
        textJoin.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        textJoin.topAnchor.constraint(equalTo: textExpired.topAnchor, constant: 25).isActive = true
        
        
        btnCancel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btnCancel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        btnCancel.topAnchor.constraint(equalTo: textJoin.bottomAnchor, constant: -18).isActive = true
        
    }
    
}

// MARK: -  Actions Buttons
extension ExpiredStageModal {
    @objc func closeModal(sender:UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @objc func btnAccept(sender:UIButton!) {
        dismiss(animated: true, completion: nil)
        
    }
    
    @objc func btnCancelModal(sender:UIButton!) {
        dismiss(animated: true, completion: nil)
    }
    
    
}



