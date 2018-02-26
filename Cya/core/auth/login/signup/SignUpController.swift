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
    var backButtonView: BackButtonView?
    var cyaImage: UIImageView = UIImageView()
    
    var userNameTextField: UITextField = UITextField()
    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    
    var activeTextField: UITextField!
    
    var errorLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var signUpContainer: UIView = UIView()
    var signUpButton: UIButton = UIButton(type: .system) as UIButton
    
    var footerView: FooterViewComponent = FooterViewComponent()

    let authService: AuthService = AuthService()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        
    }
    
    @objc func createAccountAction(){
//        var mainView: UIStoryboard!
//        mainView = UIStoryboard(name: "Auth", bundle: nil)
//        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "GralInfoController") as UIViewController
//        self.show(viewcontroller, sender: nil)
        
        errorLabel.isHidden = true
        
        var userRegister: UserRegisterDisplayObject = UserRegisterDisplayObject()
        userRegister.email = emailTextField.text
        userRegister.password = passwordTextField.text
        userRegister.username = userNameTextField.text

        let dataObject: AnyObject = authService.register(userRegister: userRegister)

        if let errorResponse = dataObject as? ErrorResponseDisplayObject{
            setErrorMessage(errorResponse: errorResponse)
        }else{
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
        }
    }
    
    func setErrorMessage(errorResponse: ErrorResponseDisplayObject){
        errorLabel.isHidden = false
        
        if (errorResponse.code != nil || errorResponse.statusCode != nil){
            errorLabel.text = errorResponse.message
        }else{
            errorLabel.text = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
        }
        
    }

}



extension SignUpController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.Cya_Background_Light
        
        
        setGradientLayer()
        setViewContent()
        setBackButton()
        setCyaImage()
        setTextField()
        notificationKeyboard()
        setFooter()
        setSignUpButton()
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
        
        viewContent.backgroundColor = UIColor.clear
    }
    
    func setGradientLayer(){
        
        self.view.layer.addSublayer(gradientLayer)
        
        gradientLayer.frame = self.view.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.3, 1.2]
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
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func setCyaImage(){
        viewContent.addSubview(cyaImage)
        
        cyaImage.translatesAutoresizingMaskIntoConstraints = false
        
        cyaImage.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        cyaImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 50).isActive = true
        cyaImage.heightAnchor.constraint(equalToConstant: 90).isActive = true
        cyaImage.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        cyaImage.image = UIImage(named: "cya_icon_l")
        cyaImage.contentMode = .scaleAspectFit
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
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        passwordTextField.font = FontCya.CyaInput
        passwordTextField.backgroundColor = UIColor.white
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "New Password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.cyaMagenta])
        passwordTextField.layer.masksToBounds = true
        passwordTextField.textColor = UIColor.gray
        passwordTextField.layer.cornerRadius = 12
        passwordTextField.isSecureTextEntry = true
        
        passwordTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        passwordTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        passwordTextField.rightViewMode = UITextFieldViewMode.always
        
        
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -20).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.font = FontCya.CyaInput
        emailTextField.backgroundColor = UIColor.white
        emailTextField.placeholder = "Email Address"
        emailTextField.layer.masksToBounds = true
        emailTextField.textColor = UIColor.gray
        emailTextField.layer.cornerRadius = 12
        emailTextField.keyboardType = .emailAddress
        
        emailTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        emailTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        emailTextField.rightViewMode = UITextFieldViewMode.always
        
        userNameTextField.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -20).isActive = true
        userNameTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        userNameTextField.font = FontCya.CyaInput
        userNameTextField.backgroundColor = UIColor.white
        userNameTextField.placeholder = "Username"
        userNameTextField.layer.masksToBounds = true
        userNameTextField.textColor = UIColor.gray
        userNameTextField.layer.cornerRadius = 12
        
        userNameTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        userNameTextField.leftViewMode = UITextFieldViewMode.always
        
        userNameTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        userNameTextField.rightViewMode = UITextFieldViewMode.always
        
        
    }
    
    func setErrorMessage(){
        
        viewContent.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 50).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -50).isActive = true
        errorLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20).isActive = true
        
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.cyaMagenta
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.sizeToFit()
        errorLabel.text = ""
        errorLabel.font = FontCya.CyaError
    }
    
    func setFooter(){
        
        viewContent.addSubview(footerView)
        
        footerView.translatesAutoresizingMaskIntoConstraints = false
        
        footerView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        footerView.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        footerView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        footerView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        footerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        footerView.footerLabel.textColor = UIColor.white
        footerView.termsButton.setTitleColor(UIColor.white, for: .normal)
        footerView.privacy.setTitleColor(UIColor.white, for: .normal)
    }
    
    func setSignUpButton(){
        
        viewContent.addSubview(signUpContainer)
        signUpContainer.addSubview(signUpButton)
        
        signUpContainer.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        signUpContainer.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        signUpContainer.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true
        signUpContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        signUpContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
        
        signUpButton.layer.masksToBounds = true
        signUpButton.centerXAnchor.constraint(equalTo: signUpContainer.centerXAnchor, constant: 0).isActive = true
        signUpButton.centerYAnchor.constraint(equalTo: signUpContainer.centerYAnchor, constant: 0).isActive = true
        signUpButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        signUpButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        signUpButton.titleLabel?.font = FontCya.CyaInput
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        signUpButton.setTitle("Sign Up", for: .normal)
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

