//
//  SignUpController.swift
//  Cya
//
//  Created by Cristopher Torres on 27/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class SignUpController: UIViewController {
    
    var viewContent: UIView = UIView()
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    var cyaImage: UIImageView = UIImageView()
    var createAccountTitle: EdgeInsetLabel = EdgeInsetLabel()
    var cancelButton: UIButton = UIButton(type: .system) as UIButton
    
    var userNameTextField: UITextField = UITextField()
    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    
    var activeTextField: UITextField!
    
    var errorLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var signUpContainer: UIView = UIView()
    var signUpButton: UIButton = UIButton(type: .system) as UIButton
    
    var signingUpLaber: EdgeInsetLabel = EdgeInsetLabel()
    var footerView: FooterViewComponent = FooterViewComponent()

    let authService: AuthService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        userNameTextField.underline(color: UIColor.gray, borderWidth: CGFloat(1.0))
        emailTextField.underline(color: UIColor.gray, borderWidth: CGFloat(1.0))
        passwordTextField.underline(color: UIColor.gray, borderWidth: CGFloat(1.0))
    }
    
    @objc func createAccountAction(){
        do{
            //        var mainView: UIStoryboard!
            //        mainView = UIStoryboard(name: "Auth", bundle: nil)
            //        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "GralInfoController") as UIViewController
            //        self.show(viewcontroller, sender: nil)
            
            errorLabel.isHidden = true
            
            var userRegister: UserRegisterDisplayObject = UserRegisterDisplayObject()
            userRegister.email = emailTextField.text
            userRegister.password = passwordTextField.text
            userRegister.username = userNameTextField.text
            
            let dataObject: AnyObject = try authService.register(userRegister: userRegister)
            
            let loginDisplayObject: LoginDisplayObject = dataObject as! LoginDisplayObject
                
            UserDisplayObject.token = loginDisplayObject.token!
            UserDisplayObject.userId = loginDisplayObject.user_id!
            UserDisplayObject.authorization = "Bearer \(loginDisplayObject.token!)"
            
            let userService: UserService = UserService()
            
            let user: User = userService.getUserById(userId: loginDisplayObject.user_id!)
            UserDisplayObject.avatar = user.avatar!
            UserDisplayObject.username = user.username!
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "Auth", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "GralInfoController") as UIViewController
            self.show(viewcontroller, sender: nil)
            
        }catch let err{
            showErrorMessage()
        }

    }
    
    @objc func backAction(){
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorMessage(){
        errorLabel.isHidden = false
        
        if(ErrorHelper.error?.code == 500){
            self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
        }else{
            errorLabel.text = ErrorHelper.error?.domain
        }
        
    }

}



extension SignUpController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.cyaLightGrayBg
        
        
//        setGradientLayer()
        setViewContent()
        setCancelButton()
        setCyaImage()
        setTextField()
        notificationKeyboard()
        setSignUpButton()
        setTermsConditions()
        setErrorMessage()
        
        
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.cyaLightGrayBg
    }
    
    func setGradientLayer(){
        
        self.view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.2]
    }
    
    func setCancelButton(){
        
        viewContent.addSubview(cancelButton)
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        
        cancelButton.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        cancelButton.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        cancelButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        cancelButton.backgroundColor = UIColor.white
        
        cancelButton.titleLabel?.font = FontCya.CyaTitlesH4Light
        cancelButton.setTitleColor(.black, for: .normal)
        cancelButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        cancelButton.setTitle("Cancel", for: .normal)
        
    }
    
    func setCyaImage(){
        viewContent.addSubview(cyaImage)
        viewContent.addSubview(createAccountTitle)
        
        cyaImage.translatesAutoresizingMaskIntoConstraints = false
        createAccountTitle.translatesAutoresizingMaskIntoConstraints = false
        
        cyaImage.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        cyaImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 40).isActive = true
        cyaImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cyaImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        cyaImage.image = UIImage(named: "cya_icon_l")
        cyaImage.contentMode = .scaleAspectFit
        
        
        createAccountTitle.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        createAccountTitle.topAnchor.constraint(equalTo: cyaImage.bottomAnchor, constant: 20).isActive = true
        
        createAccountTitle.textColor = UIColor.gray
        createAccountTitle.numberOfLines = 0
        createAccountTitle.textAlignment = .center
        createAccountTitle.lineBreakMode = .byWordWrapping
        createAccountTitle.sizeToFit()
        createAccountTitle.text = "Create Account"
        createAccountTitle.font = FontCya.CyaTitlesH1
        
    }
    
    func setTextField(){
        
        viewContent.addSubview(passwordTextField)
        viewContent.addSubview(emailTextField)
        viewContent.addSubview(userNameTextField)
        
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        
        passwordTextField.delegate  = self
        userNameTextField.delegate  = self
        emailTextField.delegate     = self
        
        passwordTextField.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: -10).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        passwordTextField.font = FontCya.CyaInput
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Enter Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        passwordTextField.textColor = UIColor.gray
        passwordTextField.isSecureTextEntry = true
        
//        passwordTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        passwordTextField.leftViewMode = UITextFieldViewMode.always
//
//        passwordTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        passwordTextField.rightViewMode = UITextFieldViewMode.always
        
        
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -30).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        emailTextField.font = FontCya.CyaInput
        emailTextField.attributedPlaceholder = NSAttributedString(string: "Enter Email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        emailTextField.textColor = UIColor.gray
        emailTextField.keyboardType = .emailAddress
        
//        emailTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        emailTextField.leftViewMode = UITextFieldViewMode.always
//
//        emailTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        emailTextField.rightViewMode = UITextFieldViewMode.always
        
        userNameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -30).isActive = true
        userNameTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        userNameTextField.font = FontCya.CyaInput
        userNameTextField.attributedPlaceholder = NSAttributedString(string: "Username", attributes: [NSAttributedStringKey.foregroundColor: UIColor.gray])
        userNameTextField.textColor = UIColor.gray
        
//        userNameTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        userNameTextField.leftViewMode = UITextFieldViewMode.always
//
//        userNameTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
//        userNameTextField.rightViewMode = UITextFieldViewMode.always
        
        
    }
    
    func setErrorMessage(){
        
        viewContent.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        errorLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -30).isActive = true
        
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.red
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.sizeToFit()
        errorLabel.text = ""
        errorLabel.font = FontCya.CyaTitlesH5Light
    }
    
    func setSignUpButton(){
        
        viewContent.addSubview(signUpContainer)
        signUpContainer.addSubview(signUpButton)
        
        signUpContainer.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        signUpContainer.bottomAnchor.constraint(equalTo: cancelButton.topAnchor, constant: 0).isActive = true
        signUpContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        signUpContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
        
        signUpButton.layer.masksToBounds = true
        signUpButton.centerXAnchor.constraint(equalTo: signUpContainer.centerXAnchor, constant: 0).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: signUpContainer.centerYAnchor, constant: -30).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        signUpButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        signUpButton.backgroundColor = UIColor.clear
        signUpButton.layer.cornerRadius = 19
        signUpButton.layer.borderWidth = 1
        signUpButton.layer.borderColor = UIColor.lightGray.cgColor
        signUpButton.layer.masksToBounds = true
        signUpButton.setTitleColor(.black, for: .normal)
        signUpButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        signUpButton.setTitle("Sign Up", for: .normal)
        
    }
    
    func setTermsConditions(){
        
        
        viewContent.addSubview(signingUpLaber)
        viewContent.addSubview(footerView)
        
        signingUpLaber.translatesAutoresizingMaskIntoConstraints = false
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        
        signingUpLaber.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: 20).isActive = true
        signingUpLaber.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        signingUpLaber.textColor = UIColor.gray
        signingUpLaber.numberOfLines = 0
        signingUpLaber.textAlignment = .center
        signingUpLaber.lineBreakMode = .byWordWrapping
        signingUpLaber.sizeToFit()
        signingUpLaber.text = "By signing up, you are agreeing to our"
        signingUpLaber.font = FontCya.CyaIconSM
        
        footerView.topAnchor.constraint(equalTo: signingUpLaber.bottomAnchor, constant: 0).isActive = true
        footerView.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        footerView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        footerView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        footerView.footerLabel.text = ""
        
        footerView.termsButton.titleLabel?.font = FontCya.CyaIconSM
        
        footerView.privacy.titleLabel?.font = FontCya.CyaIconSM
    }
    
    func paddingUITextField(x: Int, y: Int, width: Int, height: Int) -> UIView{
        let paddingView = UIView(frame: CGRect(x:x, y:y, width:width, height:height))
        
        return paddingView
    }
}

extension SignUpController: UITextFieldDelegate {
    
    func notificationKeyboard(){
        let center: NotificationCenter = NotificationCenter.default;
        
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let keyboardY = self.view.frame.size.height - keyboardSize.height
        let editingTextFieldY: CGFloat! = self.activeTextField!.frame.origin.y
        
        
        if self.view.frame.origin.y >= 0{
            if (editingTextFieldY > keyboardY - 60) {
                UIView.animate(withDuration: 0.25, delay: 0.0, options:
                    UIViewAnimationOptions.curveEaseIn, animations: {
                        self.view.frame = CGRect(x:0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 160)),
                                                 width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
        
    }
    
    @objc func keyboardWillHide(notification: Notification)
    {
        
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x:0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.activeTextField = textField
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        print("textFieldShouldBeginEditing")
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //        textField.resignFirstResponder()
        self.view.endEditing(true)
        return true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
}

