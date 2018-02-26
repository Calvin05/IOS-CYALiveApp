//
//  ForgotPasswordController.swift
//  Cya
//
//  Created by Cristopher Torres on 22/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class ForgotPasswordController: UIViewController {
    
    var viewContent: UIView = UIView()
    var cyaImage: UIImageView = UIImageView()
    var messageLabel: EdgeInsetLabel = EdgeInsetLabel()
    var emailTextField: UITextField = UITextField()
    var backButtonView: BackButtonView?
    var returnMessageLabel: EdgeInsetLabel = EdgeInsetLabel()
    var sendButton: UIButton = UIButton(type: .system) as UIButton
    var isOk: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    @objc func sendButtonAction(){
        do{
            if(isOk){
                var HomeView: UIStoryboard!
                HomeView = UIStoryboard(name: "Auth", bundle: nil)
                let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
                
                self.show(homeGo, sender: nil)
            }else{
                
                let authService: AuthService = AuthService()
                let emailText = self.emailTextField.text
                try authService.passwordReset(email: emailText!)
                
                returnMessageLabel.isHidden = false
                returnMessageLabel.text = "An email has been sent to \(emailText!) with further instructions"
                returnMessageLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
                
                sendButton.setTitle("Ok", for: .normal)
                isOk = true
            }
            
            
        }catch let error as NSError{
            returnMessageLabel.isHidden = false
            returnMessageLabel.text = error.domain
            returnMessageLabel.textColor = UIColor.cyaMagenta
            print(error.domain)
        }
    }

}

extension ForgotPasswordController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.Cya_Placeholder_Background_Color
        
        setViewContent()
        setBackButton()
        setCyaImage()
        setMessageLabel()
        setEmailTextField()
        setReturnMessageLabel()
        setSendButton()
        
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
    
    func setBackButton(){
        
        self.backButtonView = BackButtonView()
        self.backButtonView?.setParent(parent: self)
        viewContent.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: viewContent.topAnchor).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func setCyaImage(){
        viewContent.addSubview(cyaImage)
        
        cyaImage.translatesAutoresizingMaskIntoConstraints = false
        
        cyaImage.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        cyaImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 60).isActive = true
        cyaImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        cyaImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        cyaImage.image = UIImage(named: "cya_icon_l")
        cyaImage.contentMode = .scaleAspectFit
    }
    
    func setMessageLabel(){
        viewContent.addSubview(messageLabel)
        
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        messageLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 15).isActive = true
        messageLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
        messageLabel.topAnchor.constraint(equalTo: cyaImage.bottomAnchor, constant: 40).isActive = true
        
        messageLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        messageLabel.numberOfLines = 0
        messageLabel.textAlignment = .center
        messageLabel.lineBreakMode = .byWordWrapping
        messageLabel.sizeToFit()
        messageLabel.text = "Please enter the email address associate with your account"
        messageLabel.font = FontCya.CyaTitlesH3
        
        
    }
    
    func setEmailTextField(){
        viewContent.addSubview(emailTextField)
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        
        emailTextField.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 30).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.font = FontCya.CyaInput
        emailTextField.backgroundColor = UIColor.lightGray
        emailTextField.placeholder = "   Email"
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        emailTextField.layer.cornerRadius = 12
        emailTextField.keyboardType = .emailAddress
    }
    
    func setReturnMessageLabel(){
        viewContent.addSubview(returnMessageLabel)
        
        returnMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        returnMessageLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 15).isActive = true
        returnMessageLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
        returnMessageLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 15).isActive = true
        
        returnMessageLabel.isHidden = true
        returnMessageLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        returnMessageLabel.numberOfLines = 0
        returnMessageLabel.textAlignment = .center
        returnMessageLabel.lineBreakMode = .byWordWrapping
        returnMessageLabel.sizeToFit()
//        returnMessageLabel.text = "Please enter the email address associate with your account"
        returnMessageLabel.font = FontCya.CyaTitlesH3
    }
    
    func setSendButton(){
        viewContent.addSubview(sendButton)
        
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        sendButton.topAnchor.constraint(equalTo: returnMessageLabel.bottomAnchor, constant: 40).isActive = true
        sendButton.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        sendButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        sendButton.titleLabel?.font = FontCya.CyaTextField
        sendButton.setTitleColor(.cyaMagenta, for: .normal)
        sendButton.addTarget(self, action: #selector(sendButtonAction), for: .touchUpInside)
        sendButton.setTitle("Send", for: .normal)
    }
}
