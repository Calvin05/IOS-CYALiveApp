//
//  GralInfoController.swift
//  Cya
//
//  Created by Cristopher Torres on 27/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class GralInfoController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var viewContent: UIView = UIView()
    
    var headerView: UIView = UIView()
    var headerViewBackground: UIView = UIView()
    var headerLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var avatarButton: UIButton = UIButton()
    var avatarImage: UIImageView = UIImageView()
//    var avatarImage: UIImage?
    var idLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var userNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var userNameTextFiel: UITextField = UITextField()
    
    var firstNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var firstNameTextField: UITextField = UITextField()
    
    var lastNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var lastNameTextField: UITextField = UITextField()
    
    var emailLabel: EdgeInsetLabel = EdgeInsetLabel()
    var emailTextField: UITextField = UITextField()
    
    var passwordLabel: EdgeInsetLabel = EdgeInsetLabel()
    var passwordTextField: UITextField = UITextField()
    
    var dobLabel: EdgeInsetLabel = EdgeInsetLabel()
    var dobTextField: UITextField = UITextField()
    var dobValue: String = ""
    var datePicker: UIDatePicker = UIDatePicker()
    var aboutMeTextField: UITextView = UITextView()
    
    var genderLabel: EdgeInsetLabel = EdgeInsetLabel()
    var genderContainer: UIView = UIView()
    var femaleButton: UIButton = UIButton()
    var maleButton: UIButton = UIButton()
    var otherButton: UIButton = UIButton()
    
    var errorLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var gender: String = "F"
    
    var doneContainer: UIView = UIView()
    var skipButton: UIButton = UIButton(type: .system) as UIButton
    var doneButton: UIButton = UIButton(type: .system) as UIButton
    
    var activeTextField: UITextField!
    var _activeTextView: UITextView!
    
    var uploadAvatar: Bool = false
    
    var footerView: FooterViewComponent = FooterViewComponent()
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    
    var user: User = User()
    var userService: UserService = UserService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        user = userService.getUserById(userId: UserDisplayObject.userId)
        self.setupView()
        notificationKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateText()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(true)
//
//        userNameTextFiel.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//        firstNameTextField.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//        lastNameTextField.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//        emailTextField.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//        passwordTextField.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//        dobTextField.underline(color: UIColor.darkGray, borderWidth: CGFloat(1.0))
//    }
    
    func updateText(){
        
        
//        userNameTextFiel.text = user.username
        idLabel.text = "ID: \(user.user_id!)"
        userNameLabel.text = user.username
        firstNameTextField.text = user.first_name
        lastNameTextField.text = user.last_name
        emailTextField.text = user.email
        passwordTextField.text = user.password
        dobValue = user.dob!
        dobTextField.text = NSString.convertFormatOfDate(date: user.dob!, originalFormat: "yyyy-MM-dd", destinationFormat: "MMMM, dd, yyyy")
        
        let buttonTemp = UIButton()
        if(user.gender == "F"){
            buttonTemp.tag = 0
            self.setGenderValue(sender: buttonTemp)
        }else if(user.gender == "M"){
            buttonTemp.tag = 1
            self.setGenderValue(sender: buttonTemp)
        }else if(user.gender == "O"){
            buttonTemp.tag = 2
            self.setGenderValue(sender: buttonTemp)
        }
        
        
    }
    
    @objc func setGenderValue(sender: UIButton){
        
        femaleButton.backgroundColor = UIColor.white
        femaleButton.layer.borderColor = UIColor.gray.cgColor
        femaleButton.setTitleColor(.gray, for: .normal)
        
        maleButton.backgroundColor = UIColor.white
        maleButton.layer.borderColor = UIColor.gray.cgColor
        maleButton.setTitleColor(.gray, for: .normal)
        
        otherButton.backgroundColor = UIColor.white
        otherButton.layer.borderColor = UIColor.gray.cgColor
        otherButton.setTitleColor(.gray, for: .normal)
        
        switch sender.tag {
        case 0:
            
            femaleButton.backgroundColor = UIColor.cyaMagenta
            femaleButton.layer.borderColor = UIColor.cyaMagenta.cgColor
            femaleButton.setTitleColor(.white, for: .normal)
            gender = "F"
        case 1:
            maleButton.backgroundColor = UIColor.cyaMagenta
            maleButton.layer.borderColor = UIColor.cyaMagenta.cgColor
            maleButton.setTitleColor(.white, for: .normal)
            gender = "M"
        case 2:
            otherButton.backgroundColor = UIColor.cyaMagenta
            otherButton.layer.borderColor = UIColor.cyaMagenta.cgColor
            otherButton.setTitleColor(.white, for: .normal)
            gender = "O"
        default:
            break
        }
    }
    
    @objc func skipAction(){
        var mainView: UIStoryboard!
        mainView = UIStoryboard(name: "EventList", bundle: nil)
        let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
        self.show(viewcontroller, sender: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.avatarImage.image = image_data
//        self.avatarImage = image_data
        self.uploadAvatar = true
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func saveGralInfo(){
        
        do{
            let userGralInfo: User = User()
            
            userGralInfo.dob = dobValue
            userGralInfo.first_name = firstNameTextField.text == "" ? nil : firstNameTextField.text
            userGralInfo.gender = gender
            userGralInfo.last_name = lastNameTextField.text == "" ? nil : lastNameTextField.text
            userGralInfo.notes = aboutMeTextField.text == "" ? nil : aboutMeTextField.text
            userGralInfo.user_id = UserDisplayObject.userId
            userGralInfo.email = emailTextField.text == "" ? nil : emailTextField.text
            
            if(uploadAvatar){
                let uploadService: UploadService = UploadService()
                let avatarData: AnyObject = uploadService.uploadAvatar(image: self.avatarImage.image!)
                
                if let errorResponse = avatarData as? ErrorResponseDisplayObject{
                }else{
                    userGralInfo.avatar = avatarData as! String
                }
            }
            
            
            let dataObject: AnyObject = try userService.userUpdate(user: userGralInfo)
            
            let user: UserIdNumber = dataObject as! UserIdNumber
                
            if(user.user_id != nil){
                UserDisplayObject.avatar = user.avatar!
                UserDisplayObject.username = user.username!
            }
            
            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "EventList", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
            self.show(viewcontroller, sender: nil)
            
        }catch{
            showErrorMessage()
        }
        
    }
    
    func showErrorMessage(){
        errorLabel.isHidden = false
        
        if(ErrorHelper.error?.code == 500){
            self.present(ErrorHelper.showAlert(), animated: true, completion: nil)
        }else{
            errorLabel.text = ErrorHelper.error?.domain
        }
        
    }
    
    @objc func donePickerPressed(){
        
        let calendar: Calendar = Calendar.current
        let year = calendar.component(.year, from: datePicker.date)
        let month = calendar.component(.month, from: datePicker.date)
        let day = calendar.component(.day, from: datePicker.date)
        
        var monthStr = String(format: "%02d", month)
        let dayStr = String(format: "%02d", day)
        dobValue = "\(year)-\(monthStr)-\(dayStr)"
        
        dobTextField.text = NSString.convertFormatOfDate(date: dobValue, originalFormat: "yyyy-MM-dd", destinationFormat: "MMMM, dd, yyyy")
        
        self.view.endEditing(true)
    }
    
    @objc func avatarButtonAction(){
        
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

}

extension GralInfoController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.cyaLightGrayBg
        
        setViewContent()
        setHeader()
        
        setDatePicker()
        setAvatar()
        setTextField()
        setGender()
        setDOB()
        
        
//        setFooter()
        
        setBottomBar()
        setDoneButton()
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
    
    func setHeader(){
        
        view.addSubview(headerView)
        view.addSubview(headerViewBackground)
        headerView.addSubview(headerLabel)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerViewBackground.translatesAutoresizingMaskIntoConstraints = false
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        headerView.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 20).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        headerView.backgroundColor = UIColor.cyaMagenta
        
        
        headerViewBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerViewBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        headerViewBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerViewBackground.bottomAnchor.constraint(equalTo: headerView.topAnchor, constant: 0).isActive = true

        headerViewBackground.backgroundColor = UIColor.cyaMagenta
        
        
        headerLabel.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor, constant: 3).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        headerLabel.textColor = UIColor.white
        headerLabel.numberOfLines = 0
        headerLabel.textAlignment = .center
        headerLabel.lineBreakMode = .byWordWrapping
        headerLabel.sizeToFit()
        headerLabel.text = "Profile"
        headerLabel.font = FontCya.CyaMontMediumS22

        
    }
    
    func setAvatar(){
        
        viewContent.addSubview(avatarImage)
        viewContent.addSubview(avatarButton)
        viewContent.addSubview(idLabel)
        
        avatarImage.translatesAutoresizingMaskIntoConstraints = false
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        idLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        avatarImage.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        avatarImage.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15).isActive = true
        avatarImage.heightAnchor.constraint(equalToConstant: 110).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        avatarImage.layer.cornerRadius = 55
        
        avatarImage.sd_setImage(with: URL(string: user.avatar!), placeholderImage: UIImage(named: "cya-profile-gray-s"))
        
        avatarImage.layer.masksToBounds = true
        avatarImage.contentMode = .scaleAspectFit
        
        
        avatarButton.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        avatarButton.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 15).isActive = true
        avatarButton.heightAnchor.constraint(equalToConstant: 110).isActive = true
        avatarButton.widthAnchor.constraint(equalToConstant: 110).isActive = true
        
        avatarButton.layer.cornerRadius = 55
//        avatarButton.setImage(UIImage(named: "cya-profile-gray-s"), for: .normal)
        avatarButton.layer.masksToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFit
        avatarButton.addTarget(self, action: #selector(avatarButtonAction), for: .touchUpInside)
        
        
        idLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
        idLabel.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 10).isActive = true
        
        idLabel.textColor = UIColor.gray
        idLabel.numberOfLines = 0
        idLabel.textAlignment = .right
        idLabel.lineBreakMode = .byWordWrapping
        idLabel.sizeToFit()
        idLabel.text = "ID: Guest1234565767"
        idLabel.font = FontCya.CyaTitlesH5LightItalic
    }
    
    func setTextField(){
        
        viewContent.addSubview(userNameLabel)
        viewContent.addSubview(userNameTextFiel)
        viewContent.addSubview(firstNameLabel)
        viewContent.addSubview(firstNameTextField)
        viewContent.addSubview(lastNameLabel)
        viewContent.addSubview(lastNameTextField)
        viewContent.addSubview(emailLabel)
        viewContent.addSubview(emailTextField)
        viewContent.addSubview(passwordLabel)
        viewContent.addSubview(passwordTextField)
        
        viewContent.addSubview(aboutMeTextField)
        
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameTextFiel.translatesAutoresizingMaskIntoConstraints = false
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        
        aboutMeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        userNameLabel.topAnchor.constraint(equalTo: avatarButton.bottomAnchor, constant: 0).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        userNameLabel.textColor = UIColor.gray
        userNameLabel.numberOfLines = 0
        userNameLabel.textAlignment = .center
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.sizeToFit()
        userNameLabel.text = "User Name"
        userNameLabel.font = FontCya.CyaTitlesH6Light
        
//
//        userNameTextFiel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 3).isActive = true
//        userNameTextFiel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
//        userNameTextFiel.rightAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: -20).isActive = true
//
//        userNameTextFiel.text = "rigo_sony@hotmail.com"
//        userNameTextFiel.font = FontCya.CyaBody
//        userNameTextFiel.textColor = UIColor.lightGray
//        userNameTextFiel.delegate = self
//        userNameTextFiel.textAlignment = .left
//        userNameTextFiel.isEnabled = false
        
        
        firstNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        firstNameLabel.textColor = UIColor.gray
        firstNameLabel.numberOfLines = 0
        firstNameLabel.textAlignment = .right
        firstNameLabel.lineBreakMode = .byWordWrapping
        firstNameLabel.sizeToFit()
        firstNameLabel.text = "First Name"
        firstNameLabel.font = FontCya.CyaTitlesH5Light
        
        
        firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 4).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: -5).isActive = true
        
        
        firstNameTextField.delegate = self
        firstNameTextField.setTextFieldProfile()
        
        
        lastNameLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 10).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 15).isActive = true
        
        lastNameLabel.textColor = UIColor.gray
        lastNameLabel.numberOfLines = 0
        lastNameLabel.textAlignment = .right
        lastNameLabel.lineBreakMode = .byWordWrapping
        lastNameLabel.sizeToFit()
        lastNameLabel.text = "Last Name"
        lastNameLabel.font = FontCya.CyaTitlesH5Light
        
        
        lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 4).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 5).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
        lastNameTextField.delegate = self
        lastNameTextField.setTextFieldProfile()
        
        
        emailLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 10).isActive = true
        emailLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        emailLabel.textColor = UIColor.gray
        emailLabel.numberOfLines = 0
        emailLabel.textAlignment = .right
        emailLabel.lineBreakMode = .byWordWrapping
        emailLabel.sizeToFit()
        emailLabel.text = "Account Email"
        emailLabel.font = FontCya.CyaTitlesH5Light
        
        
        emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 3).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        emailTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
        emailTextField.delegate = self
        emailTextField.setTextFieldProfile()
        
        
        passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10).isActive = true
        passwordLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        passwordLabel.textColor = UIColor.gray
        passwordLabel.numberOfLines = 0
        passwordLabel.textAlignment = .right
        passwordLabel.lineBreakMode = .byWordWrapping
        passwordLabel.sizeToFit()
        passwordLabel.text = "Account Password"
        passwordLabel.font = FontCya.CyaTitlesH5Light
        
        
        passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 3).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        passwordTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
        passwordTextField.delegate = self
        passwordTextField.isSecureTextEntry = true
        passwordTextField.setTextFieldProfile()
        
        
    }
    
    func setGender(){
        
        viewContent.addSubview(genderLabel)
        viewContent.addSubview(genderContainer)
        genderContainer.addSubview(femaleButton)
        genderContainer.addSubview(maleButton)
        genderContainer.addSubview(otherButton)
        
        
        genderLabel.translatesAutoresizingMaskIntoConstraints = false
        genderContainer.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        otherButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        genderLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10).isActive = true
        genderLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        genderLabel.textColor = UIColor.gray
        genderLabel.numberOfLines = 0
        genderLabel.textAlignment = .right
        genderLabel.lineBreakMode = .byWordWrapping
        genderLabel.sizeToFit()
        genderLabel.text = "Gender"
        genderLabel.font = FontCya.CyaTitlesH5Light
        
        
        genderContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        genderContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        genderContainer.heightAnchor.constraint(equalToConstant: 35).isActive = true
        genderContainer.topAnchor.constraint(equalTo: genderLabel.bottomAnchor, constant: 3).isActive = true
        
        let genderContainerWidth = self.view.layoutMarginsGuide.layoutFrame.size.width - 50
        
        
        maleButton.leftAnchor.constraint(equalTo: genderContainer.leftAnchor, constant: 0).isActive = true
        maleButton.widthAnchor.constraint(equalToConstant: genderContainerWidth / 3 + 1).isActive = true
        maleButton.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: -5).isActive = true
        
        maleButton.setTitle("Male", for: .normal)
        maleButton.setTitleColor(.gray, for: .normal)
        maleButton.titleLabel?.font = FontCya.CyaTitlesH4Light
        maleButton.backgroundColor = UIColor.white
        maleButton.layer.borderColor = UIColor.gray.cgColor
        maleButton.layer.cornerRadius = 4
        maleButton.layer.borderWidth = 1
        maleButton.tag = 1
        maleButton.addTarget(self, action: #selector(setGenderValue), for: .touchUpInside)
        
        
        femaleButton.rightAnchor.constraint(equalTo: genderContainer.rightAnchor, constant: 0).isActive = true
        femaleButton.widthAnchor.constraint(equalToConstant: genderContainerWidth / 3 + 1).isActive = true
        femaleButton.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: -5).isActive = true
        
        femaleButton.setTitle("Female", for: .normal)
        femaleButton.setTitleColor(.gray, for: .normal)
        femaleButton.titleLabel?.font = FontCya.CyaTitlesH4Light
        femaleButton.backgroundColor = UIColor.white
        femaleButton.layer.borderColor = UIColor.gray.cgColor
        femaleButton.layer.cornerRadius = 4
        femaleButton.layer.borderWidth = 1
        femaleButton.tag = 0
        femaleButton.addTarget(self, action: #selector(setGenderValue), for: .touchUpInside)
        
        
        otherButton.centerXAnchor.constraint(equalTo: genderContainer.centerXAnchor, constant: 0).isActive = true
        otherButton.widthAnchor.constraint(equalToConstant: genderContainerWidth / 3 + 1).isActive = true
        otherButton.bottomAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: -5).isActive = true
        
        otherButton.setTitle(" Other", for: .normal)
        otherButton.setTitleColor(.white, for: .normal)
        otherButton.titleLabel?.font = FontCya.CyaTitlesH4Light
        otherButton.backgroundColor = UIColor.cyaMagenta
        otherButton.layer.borderColor = UIColor.cyaMagenta.cgColor
        otherButton.layer.borderWidth = 1
        otherButton.tag = 2
        otherButton.addTarget(self, action: #selector(setGenderValue), for: .touchUpInside)
    }
    
    func setDOB(){
        
        viewContent.addSubview(dobLabel)
        viewContent.addSubview(dobTextField)
        
        
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        dobTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        dobLabel.topAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: 10).isActive = true
        dobLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 35).isActive = true
        
        dobLabel.textColor = UIColor.gray
        dobLabel.numberOfLines = 0
        dobLabel.textAlignment = .right
        dobLabel.lineBreakMode = .byWordWrapping
        dobLabel.sizeToFit()
        dobLabel.text = "Date of Birth"
        dobLabel.font = FontCya.CyaTitlesH5Light
        
        
        dobTextField.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 4).isActive = true
        dobTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        dobTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
        dobTextField.delegate = self
        dobTextField.setTextFieldProfile()
    }
    
    func setDatePicker(){
        
        datePicker.datePickerMode = .date
        let toolbar: UIToolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePickerPressed))
        doneButton.tintColor = UIColor.cyaMagenta
        toolbar.setItems([doneButton], animated: false)
        dobTextField.inputAccessoryView = toolbar
        dobTextField.inputView = datePicker
    }
    
    
    func setErrorMessage(){
        
        viewContent.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 10).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -10).isActive = true
        errorLabel.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -10).isActive = true
        
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.cyaMagenta
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.sizeToFit()
        errorLabel.text = ""
        errorLabel.font = FontCya.CyaError
    }
    
    func setDoneButton(){
        
        viewContent.addSubview(doneContainer)
//        doneContainer.addSubview(skipButton)
        doneContainer.addSubview(doneButton)
        
        doneContainer.translatesAutoresizingMaskIntoConstraints = false
//        skipButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        doneContainer.topAnchor.constraint(equalTo: dobTextField.bottomAnchor, constant: 0).isActive = true
        doneContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        doneContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        doneContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
//        skipButton.layer.masksToBounds = true
//        skipButton.rightAnchor.constraint(equalTo: doneContainer.rightAnchor, constant: -30).isActive = true
//        skipButton.leftAnchor.constraint(equalTo: doneContainer.centerXAnchor, constant: 0).isActive = true
//        skipButton.centerYAnchor.constraint(equalTo: doneContainer.centerYAnchor, constant: 5).isActive = true
//        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
//        skipButton.titleLabel?.font = FontCya.CyaTextField
//        skipButton.setTitleColor(.white, for: .normal)
//        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
//        skipButton.setTitle("Skip", for: .normal)
        
        
        doneButton.centerXAnchor.constraint(equalTo: doneContainer.centerXAnchor, constant: 0).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: doneContainer.centerYAnchor, constant: 5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 130).isActive = true
        
        
        doneButton.layer.masksToBounds = true
        doneButton.titleLabel?.font = FontCya.CyaInput
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(saveGralInfo), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.layer.cornerRadius = 15
        doneButton.layer.borderColor = UIColor.lightGray.cgColor
        doneButton.layer.borderWidth = 1
        
    }
    
//    func setFooter(){
//
//        viewContent.addSubview(footerView)
//
//        footerView.translatesAutoresizingMaskIntoConstraints = false
//
//        footerView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
//        footerView.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
//        footerView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
//        footerView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
//        footerView.heightAnchor.constraint(equalToConstant: 60).isActive = true
//
//        footerView.footerLabel.textColor = UIColor.white
//        footerView.termsButton.setTitleColor(UIColor.white, for: .normal)
//        footerView.privacy.setTitleColor(UIColor.white, for: .normal)
//    }
    
    func setBottomBar(){
        
        toolBarMenu.setCurrenView(currentView: "Settings")
        toolBarMenu.setParentView(parentView: self)
        view.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true

    }
    
}

// GralInfoController


extension GralInfoController: UITextFieldDelegate,  UITextViewDelegate {
    
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
        
        if (self.activeTextField != nil){
        
        
            let editingTextFieldY: CGFloat! = self.activeTextField!.frame.origin.y
            if self.view.frame.origin.y >= 0{
                if (editingTextFieldY > keyboardY - 100) {
                    UIView.animate(withDuration: 0.25, delay: 0.0, options:
                        UIViewAnimationOptions.curveEaseIn, animations: {
                            self.view.frame = CGRect(x:0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 160)),
                                                     width: self.view.bounds.width, height: self.view.bounds.height)
                    }, completion: nil)
                }
            }
        }
        else {
            let editingTextFieldY: CGFloat! = self._activeTextView!.frame.origin.y
            if self.view.frame.origin.y >= 0{
                if (editingTextFieldY > keyboardY - 100) {
                    UIView.animate(withDuration: 0.25, delay: 0.0, options:
                        UIViewAnimationOptions.curveEaseIn, animations: {
                            self.view.frame = CGRect(x:0, y: self.view.frame.origin.y - (editingTextFieldY! - (keyboardY - 160)),
                                                     width: self.view.bounds.width, height: self.view.bounds.height)
                    }, completion: nil)
                }
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
        print(self.activeTextField)
        print("textFieldDidBeginEditing")
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.activeTextField = textField
        print(self.activeTextField)
        print("textFieldShouldBeginEditing")
        
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        self._activeTextView = textView
        aboutMeTextField.placeholder = ""
    }

    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        self._activeTextView = textView
        return true
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
//        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIViewAnimationOptions.curveEaseIn, animations: {
//            self.view.frame = CGRect(x:0, y:0, width: self.view.bounds.width, height: self.view.bounds.height)
//        }, completion: nil)

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

