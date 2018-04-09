//
//  LoginController.swift
//  Cya
//
//  Created by Cristopher Torres on 16/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase
import GoogleSignIn
import AVFoundation

class LoginController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {
    
    var viewContent: UIView = UIView()
    var cyaImage: UIImageView = UIImageView()
    var watchContainer: UIView = UIView()
    var watchNowButton: UIButton = UIButton(type: .system) as UIButton
    var signInButton: UIButton = UIButton(type: .system) as UIButton
    var lowerViewContainer: UIView = UIView()
    var createAccountContainer: UIView = UIView()
    var createAccountButton: UIButton = UIButton(type: .system) as UIButton
    var orContainer: UIView = UIView()
    var lineLeft: UIView = UIView()
    var lineRight: UIView = UIView()
    var orLaber: UILabel = UILabel()
    
//    var signInWithContainer: UIView = UIView()
//    var signInWithLabel: UILabel = UILabel()
//    var googleButton: GIDSignInButton = GIDSignInButton()
    var googleButton: UIButton = UIButton()
    var facebookButton: UIButton = UIButton()
    
//    var footerView: FooterViewComponent = FooterViewComponent()
    var footerContainer: UIView = UIView()
    var footerBackground: UIView = UIView()
    var footerLabel: EdgeInsetLabel = EdgeInsetLabel()
    var footerVersionLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var textFielContainer: UIView = UIView()
    var emailTextField: UITextField = UITextField()
    var passwordTextField: UITextField = UITextField()
    var errorLoginLabel: EdgeInsetLabel = EdgeInsetLabel()
    var fb_go_errorLoginLabel: EdgeInsetLabel = EdgeInsetLabel()
    var forgotPasswordButton: UIButton = UIButton(type: .system) as UIButton
    
    var signInButtonYcenter: NSLayoutConstraint?
    var createAccountButtonYcenter: NSLayoutConstraint?
    var createAccountButtonTop: NSLayoutConstraint?
    
    var createAccountContainerTop: NSLayoutConstraint?
    var createAccountContainerLogInTop: NSLayoutConstraint?
    
    var isLogin: Bool = false
    let authService: AuthService = AuthService()
    
    var activeTextField: UITextField!
    
    var activityIndicator: ActivityIndicator?
    
    
    var Player: AVPlayer!
    var PlayerLayer: AVPlayerLayer!
    /*let overlay = UIView(frame: overlayTarget.frame)*/
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playerBackground()
//        self.activityIndicator = ActivityIndicator(view: self.view)
        setupView()
        notificationKeyboard()
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        emailTextField.underline(color: UIColor.white, borderWidth: CGFloat(1.0))
        passwordTextField.underline(color: UIColor.white, borderWidth: CGFloat(1.0))
    }
    
    func paddingUITextField(x: Int, y: Int, width: Int, height: Int) -> UIView{
        let paddingView = UIView(frame: CGRect(x:x, y:y, width:width, height:height))
        
        return paddingView
    }
    
    @objc func signIn(){
        
        self.fb_go_errorLoginLabel.isHidden = true
        login()
//        if(isLogin){
//            self.activityIndicator?.showActivityIndicator()
//            errorLoginLabel.isHidden = true
//            login()
//        }else{
//            setTextBox()
//            isLogin = true
//        }
    }
    
    @objc func watchNowButtonAction(){
        self.fb_go_errorLoginLabel.isHidden = true
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "EventList", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
        
        self.show(viewcontroller, sender: nil)
    }
    
    @objc func facebookLogin(){
        self.fb_go_errorLoginLabel.isHidden = true
        
//        let accessToken = FBSDKAccessToken.current()
//        guard let accessTokenString = accessToken?.tokenString else {return}
//        
//        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
//        
//        Auth.auth().signIn(with: credentials) { (user, error) in
//            if(error != nil){
//                print("error facebook")
//            }
//            print("correcto facebook")
//        }
        
        FBSDKLoginManager().logIn(withReadPermissions: ["email", "public_profile"], from: self, handler:  {(result, err) in
            if err != nil {
                ErrorHelper.setGeneralApiError()
                self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
                return
            }

//            FBSDKGraphRequest(graphPath: "/me", parameters: ["fields": "id, name, email"]).start(completionHandler: { (connection, result, err) in
//                if(err != nil) {
//                    print("failed")
//                    return
//                }
//                print(result)
//            })

            if(!(result?.isCancelled)!){
                
                self.authService.facebookLogin(token: (result?.token.tokenString!)!){data, err in
                    if(err != nil){
                        self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
                    }else{
                        DispatchQueue.main.async {
                            self.startApp(loginDisplayObject: data!)
                        }
                    }
                }
            }
        })
    }
    
    @objc func googleLogin(){
        self.fb_go_errorLoginLabel.isHidden = true
        GIDSignIn.sharedInstance().signIn()
        
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error {
            print("Failed to log into Google: ", err)
            self.fb_go_errorLoginLabel.isHidden = false
            self.fb_go_errorLoginLabel.text = "Google Login Error"
            return
        }
        
        print("Successfully logged into Google", user)
        guard let authentication = user.authentication else { return }
        
        self.authService.googleLogin(token: authentication.idToken){data, err in
            if(err != nil){
                self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
            }else{
                DispatchQueue.main.async {
                    self.startApp(loginDisplayObject: data!)
                }
            }
        }
    }
    
    
    func login(){
        
        let loginDisplayObject: LoginDisplayObject = authService.login(email: emailTextField.text!, password: passwordTextField.text!)
        if(loginDisplayObject.user_id == nil){
//            errorLoginLabel.isHidden = false
            if(ErrorHelper.error?.code != 500){
                ErrorHelper.setCustomErrorMessage(message: "There is a problem with your login credentials. Either your username or password is incorrect")
            }
            
            self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
        }else{
            startApp(loginDisplayObject: loginDisplayObject)
        }
    }
    
    func startApp(loginDisplayObject: LoginDisplayObject){
        UserDisplayObject.token = loginDisplayObject.token!
        UserDisplayObject.userId = loginDisplayObject.user_id!
        UserDisplayObject.authorization = "Bearer \(loginDisplayObject.token!)"
        
        let userService: UserService = UserService()
        
        let user: User = userService.getUserById(userId: loginDisplayObject.user_id!)
        UserDisplayObject.avatar = user.avatar!
        UserDisplayObject.username = user.username!
        UserDisplayObject.first_name = user.first_name!
        UserDisplayObject.last_name = user.last_name!
        
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "EventList", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
        self.show(viewcontroller, sender: nil)
        
    }
    
    @objc func createAccountAction(){
        self.fb_go_errorLoginLabel.isHidden = true
        let viewcontroller : UIViewController = SignUpController()
        self.show(viewcontroller, sender: nil)
//        var mainView: UIStoryboard!
//        mainView = UIStoryboard(name: "Auth", bundle: nil)
//        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "GralInfoController") as UIViewController
//        self.show(viewcontroller, sender: nil)
//        self.activityIndicator?.stopActivityIndicator()
    }
    
    @objc func forgotPasswordAction(){
        let viewcontroller : UIViewController = ForgotPasswordController()
        self.show(viewcontroller, sender: nil)
    }

}

extension LoginController {
    
    func playerBackground(){
        let URL = Bundle.main.url(forResource: "cya_background_videp", withExtension: "mp4")
        
        Player = AVPlayer.init(url: URL!)
        
        PlayerLayer = AVPlayerLayer(player: Player)
        PlayerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        PlayerLayer.frame = view.layer.frame
        
        Player.actionAtItemEnd = AVPlayerActionAtItemEnd.none
        
        Player.play()
        
        view.layer.insertSublayer(PlayerLayer, at: 0)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: Player.currentItem)
    }
    
    @objc func playerItemReachEnd(notification: NSNotification){
        Player.seek(to: kCMTimeZero)
    }
}


extension LoginController{
    func setupView(){
        
        view.backgroundColor = UIColor.white
        
        setViewContent()
        setCyaImage()
        setSignInButton()
        setLowerViewContainer()
//        setWatchNow()
        setSignInWith()
        setFooter()
        setCreateAccount()
        setTextBox()
        set_fb_go_errorLoginLabel()
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
    
    func setCyaImage(){
        viewContent.addSubview(cyaImage)
        
        cyaImage.translatesAutoresizingMaskIntoConstraints = false
        
        cyaImage.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        cyaImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 40).isActive = true
        cyaImage.heightAnchor.constraint(equalToConstant: 75).isActive = true
        cyaImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        cyaImage.image = UIImage(named: "cya_icon_l")
        cyaImage.contentMode = .scaleAspectFit
    }
    
    func setSignInButton(){
        
        viewContent.addSubview(signInButton)
        
        
        signInButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        signInButton.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        signInButtonYcenter = signInButton.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: -25)
        signInButtonYcenter?.isActive = true
        
        
        signInButton.widthAnchor.constraint(equalToConstant: 160).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
        
        signInButton.layer.masksToBounds = true
        signInButton.layer.cornerRadius = 19
        signInButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        signInButton.setTitleColor(.black, for: .normal)
        signInButton.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        signInButton.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        signInButton.setTitle("Sign In", for: .normal)
    }
    
    func setLowerViewContainer(){
        viewContent.addSubview(lowerViewContainer)
        
        lowerViewContainer.translatesAutoresizingMaskIntoConstraints = false
        
        lowerViewContainer.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 0).isActive = true
        lowerViewContainer.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -50).isActive = true
        lowerViewContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        lowerViewContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
    }
    
//    func setWatchNow(){
//        viewContent.addSubview(watchContainer)
//        watchContainer.addSubview(watchNowButton)
//
//        watchContainer.translatesAutoresizingMaskIntoConstraints = false
//        watchNowButton.translatesAutoresizingMaskIntoConstraints = false
//
//        watchContainer.topAnchor.constraint(equalTo: cyaImage.bottomAnchor, constant: 0).isActive = true
//        watchContainer.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: 0).isActive = true
//        watchContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
//        watchContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
//
//        watchNowButton.layer.masksToBounds = true
//        watchNowButton.centerXAnchor.constraint(equalTo: watchContainer.centerXAnchor, constant: 0).isActive = true
//        watchNowButton.centerYAnchor.constraint(equalTo: watchContainer.centerYAnchor, constant: 0).isActive = true
//        watchNowButton.widthAnchor.constraint(equalToConstant: 210).isActive = true
//        watchNowButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
//
//        watchNowButton.titleLabel?.font = FontCya.CyaTextField
//        watchNowButton.setTitleColor(.cyaMagenta, for: .normal)
//        watchNowButton.addTarget(self, action: #selector(watchNowButtonAction), for: .touchUpInside)
//        watchNowButton.setTitle("Watch Now", for: .normal)
//        watchNowButton.backgroundColor = UIColor.white
//    }
    
    func setSignInWith(){
        
//        viewContent.addSubview(signInWithContainer)
//        signInWithContainer.addSubview(signInWithLabel)
        lowerViewContainer.addSubview(googleButton)
        lowerViewContainer.addSubview(facebookButton)
        lowerViewContainer.addSubview(orContainer)
        orContainer.addSubview(lineLeft)
        orContainer.addSubview(lineRight)
        orContainer.addSubview(orLaber)
        
//        signInWithContainer.translatesAutoresizingMaskIntoConstraints = false
//        signInWithLabel.translatesAutoresizingMaskIntoConstraints = false
        googleButton.translatesAutoresizingMaskIntoConstraints = false
        facebookButton.translatesAutoresizingMaskIntoConstraints = false
        orContainer.translatesAutoresizingMaskIntoConstraints = false
        lineLeft.translatesAutoresizingMaskIntoConstraints = false
        lineRight.translatesAutoresizingMaskIntoConstraints = false
        orLaber.translatesAutoresizingMaskIntoConstraints = false
        
//        signInWithContainer.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 0).isActive = true
//        signInWithContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
//        signInWithContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
//        signInWithContainer.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
//        signInWithLabel.topAnchor.constraint(equalTo: signInWithContainer.topAnchor, constant: 15).isActive = true
//        signInWithLabel.centerXAnchor.constraint(equalTo: signInWithContainer.centerXAnchor, constant: 0).isActive = true
//        signInWithLabel.leftAnchor.constraint(equalTo: signInWithContainer.leftAnchor, constant: 0).isActive = true
//        signInWithLabel.rightAnchor.constraint(equalTo: signInWithContainer.rightAnchor, constant: 0).isActive = true
//
//        signInWithLabel.textColor = UIColor.cyaMagenta
//        signInWithLabel.numberOfLines = 0
//        signInWithLabel.textAlignment = .center
//        signInWithLabel.lineBreakMode = .byWordWrapping
//        signInWithLabel.sizeToFit()
//        signInWithLabel.text = "Sign in with..."
//        signInWithLabel.font = FontCya.CyaBody
        
        
//        googleButton.layer.masksToBounds = true
        googleButton.bottomAnchor.constraint(equalTo: lowerViewContainer.centerYAnchor, constant: 0).isActive = true
        googleButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        googleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        googleButton.rightAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: -10).isActive = true
        
        googleButton.titleLabel?.font = FontCya.CyaIconSM
        googleButton.setTitleColor(.white, for: .normal)
        googleButton.addTarget(self, action: #selector(googleLogin), for: .touchUpInside)
        googleButton.setImage(UIImage(named: "google-icon"), for: .normal)
        googleButton.imageView?.contentMode = .scaleAspectFit
        
//        googleButton.style = .iconOnly
//        googleButton.colorScheme = .dark
//        googleButton.tintColor = UIColor.red
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        
        facebookButton.layer.masksToBounds = true
        facebookButton.bottomAnchor.constraint(equalTo: lowerViewContainer.centerYAnchor, constant: 0).isActive = true
        facebookButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        facebookButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        facebookButton.leftAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 10).isActive = true
        
        facebookButton.titleLabel?.font = FontCya.CyaIconSM
        facebookButton.setTitleColor(.white, for: .normal)
        facebookButton.addTarget(self, action: #selector(facebookLogin), for: .touchUpInside)
        facebookButton.setImage(UIImage(named: "facebook-icon"), for: .normal)
        facebookButton.imageView?.contentMode = .scaleAspectFit
        
        
        orContainer.bottomAnchor.constraint(equalTo: facebookButton.topAnchor, constant: -20).isActive = true
        orContainer.heightAnchor.constraint(equalToConstant: 20).isActive = true
        orContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        orContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
        
        
        orLaber.centerYAnchor.constraint(equalTo: orContainer.centerYAnchor, constant: 0).isActive = true
        orLaber.centerXAnchor.constraint(equalTo: orContainer.centerXAnchor, constant: 0).isActive = true
        orLaber.widthAnchor.constraint(equalToConstant: 73).isActive = true
        orLaber.heightAnchor.constraint(equalToConstant: 15).isActive = true
        
        orLaber.textColor = UIColor.white
        orLaber.numberOfLines = 0
        orLaber.textAlignment = .center
        orLaber.lineBreakMode = .byWordWrapping
        orLaber.sizeToFit()
        orLaber.text = "Or Sign In With"
        orLaber.font = FontCya.CyaTitlesS9Light
        
        lineLeft.centerYAnchor.constraint(equalTo: orContainer.centerYAnchor, constant: 0).isActive = true
        lineLeft.rightAnchor.constraint(equalTo: orLaber.leftAnchor, constant: 0).isActive = true
        lineLeft.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lineLeft.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lineLeft.backgroundColor = UIColor.white
        
        
        lineRight.centerYAnchor.constraint(equalTo: orContainer.centerYAnchor, constant: 0).isActive = true
        lineRight.leftAnchor.constraint(equalTo: orLaber.rightAnchor, constant: 0).isActive = true
        lineRight.widthAnchor.constraint(equalToConstant: 60).isActive = true
        lineRight.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        lineRight.backgroundColor = UIColor.white
    }
    
    func set_fb_go_errorLoginLabel(){
        viewContent.addSubview(fb_go_errorLoginLabel)
        
        fb_go_errorLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        
        fb_go_errorLoginLabel.topAnchor.constraint(equalTo: watchNowButton.bottomAnchor, constant: 20).isActive = true
        fb_go_errorLoginLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 20).isActive = true
        fb_go_errorLoginLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        
        fb_go_errorLoginLabel.isHidden = true
        fb_go_errorLoginLabel.textColor = UIColor.cyaMagenta
        fb_go_errorLoginLabel.numberOfLines = 0
        fb_go_errorLoginLabel.textAlignment = .center
        fb_go_errorLoginLabel.lineBreakMode = .byWordWrapping
        fb_go_errorLoginLabel.sizeToFit()
        fb_go_errorLoginLabel.text = ""
        fb_go_errorLoginLabel.font = FontCya.CyaError
        fb_go_errorLoginLabel.isHidden = true
    }
    
    func setTextBox(){
        
//        signInWithContainer.isHidden = true
//        watchContainer.isHidden = true
//        signInButtonYcenter?.constant = 50
//        createAccountButtonYcenter?.isActive = false
//        createAccountContainerTop?.isActive = false
//
//        createAccountContainerLogInTop = createAccountContainer.topAnchor.constraint(equalTo: orLaber.bottomAnchor, constant: 0)
//        createAccountContainerLogInTop?.isActive = true
//
//        createAccountButtonTop = createAccountButton.topAnchor.constraint(equalTo: orLaber.bottomAnchor, constant: 20)
//        createAccountButtonTop?.isActive = true
//
        self.view.layoutIfNeeded()
        
        
        viewContent.addSubview(textFielContainer)
        textFielContainer.addSubview(passwordTextField)
        textFielContainer.addSubview(emailTextField)
        textFielContainer.addSubview(errorLoginLabel)
        textFielContainer.addSubview(forgotPasswordButton)
        
        textFielContainer.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        errorLoginLabel.translatesAutoresizingMaskIntoConstraints = false
        forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        textFielContainer.topAnchor.constraint(equalTo: cyaImage.bottomAnchor, constant: 0).isActive = true
        textFielContainer.bottomAnchor.constraint(equalTo: signInButton.topAnchor, constant: 0).isActive = true
        textFielContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        textFielContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        
        passwordTextField.leftAnchor.constraint(equalTo: textFielContainer.leftAnchor, constant: 40).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: textFielContainer.rightAnchor, constant: -40).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: textFielContainer.centerYAnchor, constant: 5).isActive = true
        
        
        passwordTextField.text = "testtest"
        passwordTextField.font = FontCya.CyaTextField
        passwordTextField.textColor = UIColor.white
        passwordTextField.isSecureTextEntry = true
        passwordTextField.delegate = self
        passwordTextField.textAlignment = .center
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
        
        passwordTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        passwordTextField.leftViewMode = UITextFieldViewMode.always
        
        passwordTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        passwordTextField.rightViewMode = UITextFieldViewMode.always
        
        errorLoginLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5).isActive = true
        errorLoginLabel.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 5).isActive = true
        errorLoginLabel.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor, constant: -5).isActive = true

        errorLoginLabel.textColor = UIColor.cyaMagenta
        errorLoginLabel.numberOfLines = 0
        errorLoginLabel.textAlignment = .left
        errorLoginLabel.lineBreakMode = .byWordWrapping
        errorLoginLabel.sizeToFit()
        errorLoginLabel.text = "Email or Password Incorrect"
        errorLoginLabel.font = FontCya.CyaError
        errorLoginLabel.isHidden = true


        emailTextField.leftAnchor.constraint(equalTo: textFielContainer.leftAnchor, constant: 40).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: textFielContainer.rightAnchor, constant: -40).isActive = true
        emailTextField.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -30).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        emailTextField.text = "test53@synaptop.com"
        emailTextField.font = FontCya.CyaTextField
        emailTextField.textColor = UIColor.white
        emailTextField.keyboardType = UIKeyboardType.emailAddress
        emailTextField.delegate = self
        emailTextField.textAlignment = .center
        emailTextField.attributedPlaceholder = NSAttributedString(string: "username / email", attributes: [NSAttributedStringKey.foregroundColor: UIColor.blue])
        
       
        emailTextField.leftView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        emailTextField.leftViewMode = UITextFieldViewMode.always
        
        emailTextField.rightView = paddingUITextField(x: 0, y: 0, width: 15, height: Int(self.emailTextField.frame.height))
        emailTextField.rightViewMode = UITextFieldViewMode.always
        
        
        forgotPasswordButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 0).isActive = true
        forgotPasswordButton.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 5).isActive = true
        forgotPasswordButton.rightAnchor.constraint(equalTo: passwordTextField.rightAnchor, constant: 0).isActive = true
        
        forgotPasswordButton.titleLabel?.font = FontCya.CyaBody
        forgotPasswordButton.setTitleColor(.cyaMagenta, for: .normal)
        forgotPasswordButton.addTarget(self, action: #selector(forgotPasswordAction), for: .touchUpInside)
        forgotPasswordButton.setTitle("Forgot Password", for: .normal)
        forgotPasswordButton.contentHorizontalAlignment = .right
    }
    
    func setCreateAccount(){
        viewContent.addSubview(createAccountContainer)
        createAccountContainer.addSubview(createAccountButton)
        createAccountContainer.addSubview(watchContainer)
        watchContainer.addSubview(watchNowButton)
        
        createAccountContainer.translatesAutoresizingMaskIntoConstraints = false
        createAccountButton.translatesAutoresizingMaskIntoConstraints = false
        watchContainer.translatesAutoresizingMaskIntoConstraints = false
        watchNowButton.translatesAutoresizingMaskIntoConstraints = false
        
        createAccountContainerTop = createAccountContainer.topAnchor.constraint(equalTo: facebookButton.bottomAnchor, constant: 0)
        createAccountContainerTop?.isActive = true
        createAccountContainer.bottomAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 0).isActive = true
        createAccountContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        createAccountContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
        
        createAccountButton.layer.masksToBounds = true
        createAccountButton.centerXAnchor.constraint(equalTo: createAccountContainer.centerXAnchor, constant: 0).isActive = true
        
        createAccountButtonYcenter = createAccountButton.centerYAnchor.constraint(equalTo: createAccountContainer.centerYAnchor, constant: -35)
        createAccountButtonYcenter?.isActive = true
        
        createAccountButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        createAccountButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        createAccountButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        createAccountButton.setTitleColor(.white, for: .normal)
        createAccountButton.addTarget(self, action: #selector(createAccountAction), for: .touchUpInside)
        createAccountButton.setTitle("Create Account", for: .normal)
        
        
        watchContainer.topAnchor.constraint(equalTo: createAccountButton.bottomAnchor, constant: 0).isActive = true
        watchContainer.bottomAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 0).isActive = true
        watchContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor).isActive = true
        watchContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor).isActive = true
        
        watchNowButton.layer.masksToBounds = true
        watchNowButton.centerXAnchor.constraint(equalTo: watchContainer.centerXAnchor, constant: 0).isActive = true
        watchNowButton.centerYAnchor.constraint(equalTo: watchContainer.centerYAnchor, constant: 0).isActive = true
        watchNowButton.widthAnchor.constraint(equalToConstant: 210).isActive = true
        watchNowButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        watchNowButton.titleLabel?.font = FontCya.CyaTitlesH3Light
        watchNowButton.setTitleColor(.white, for: .normal)
        watchNowButton.addTarget(self, action: #selector(watchNowButtonAction), for: .touchUpInside)
        watchNowButton.setTitle("Skip", for: .normal)
    }
    
    func setFooter(){
        
//        viewContent.addSubview(footerView)
//
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//
//        footerView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
//        footerView.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
//        footerView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
//        footerView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
//        footerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//
//
//        footerView.footerLabel.textColor = UIColor.cyaMagenta
//        footerView.termsButton.setTitleColor(UIColor.cyaMagenta, for: .normal)
//        footerView.privacy.setTitleColor(UIColor.cyaMagenta, for: .normal)
        
        
        
        view.addSubview(footerBackground)
        viewContent.addSubview(footerContainer)
        
        footerContainer.addSubview(footerLabel)
        footerContainer.addSubview(footerVersionLabel)
        
        
        footerContainer.translatesAutoresizingMaskIntoConstraints = false
        footerBackground.translatesAutoresizingMaskIntoConstraints = false
        footerLabel.translatesAutoresizingMaskIntoConstraints = false
        footerVersionLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        footerBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        footerBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        footerBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        footerBackground.topAnchor.constraint(equalTo: footerContainer.bottomAnchor, constant: 0).isActive = true
        
        
        footerContainer.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        footerContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        footerContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        footerContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        footerLabel.topAnchor.constraint(equalTo: footerContainer.topAnchor, constant: 15).isActive = true
        footerLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        footerVersionLabel.topAnchor.constraint(equalTo: footerLabel.topAnchor, constant: 15).isActive = true
        footerVersionLabel.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        
        footerContainer.backgroundColor = UIColor.darkGray
        footerBackground.backgroundColor = UIColor.darkGray
        
        
        footerLabel.textColor = UIColor.white
        footerLabel.numberOfLines = 0
        footerLabel.textAlignment = .center
        footerLabel.lineBreakMode = .byWordWrapping
        footerLabel.sizeToFit()
        footerLabel.text = "@CyaLive 2018. All Rights Reserver. CyaLive"
        footerLabel.font = FontCya.CyaTitlesS9Light
        
        footerVersionLabel.textColor = UIColor.white
        footerVersionLabel.numberOfLines = 0
        footerVersionLabel.textAlignment = .center
        footerVersionLabel.lineBreakMode = .byWordWrapping
        footerVersionLabel.sizeToFit()
        footerVersionLabel.text = "V1.0"
        footerVersionLabel.font = FontCya.CyaTitlesS9Light
    }
}

extension LoginController: UITextFieldDelegate {
    
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
        textField.backgroundColor = UIColor.lightGray.withAlphaComponent(0.3)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
        textField.backgroundColor = UIColor.clear
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        print("textField Should Begin Editing Login")
        
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        print("touchesBegan Login")
//        activeTextField.resignFirstResponder()
        
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









