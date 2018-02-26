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
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    var cyaImage: UIImageView = UIImageView()
    
    var avatarContainer: UIView = UIView()
    var avatarButton: UIButton = UIButton()
    var avatarImage: UIImage?
    
    var firstNameTextField: UITextField = UITextField()
    var lastNameTextField: UITextField = UITextField()
    var dobTextField: UITextField = UITextField()
    var datePicker: UIDatePicker = UIDatePicker()
    var aboutMeTextField: UITextView = UITextView()
    
    var genderContainer: UIView = UIView()
    var femaleButton: UIButton = UIButton()
    var maleButton: UIButton = UIButton()
    
    var errorLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    var gender: String = "F"
    
    var skipContainer: UIView = UIView()
    var skipButton: UIButton = UIButton(type: .system) as UIButton
    var doneButton: UIButton = UIButton(type: .system) as UIButton
    
    var activeTextField: UITextField!
    var _activeTextView: UITextView!
    
    var uploadAvatar: Bool = false
    
    var footerView: FooterViewComponent = FooterViewComponent()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupView()
        notificationKeyboard()
    }
    
    @objc func setFemaleValue(){
        gender = "F"
        maleButton.setTitleColor(.cyaMagenta, for: .normal)
        maleButton.backgroundColor = UIColor.clear
        
        femaleButton.setTitleColor(.white, for: .normal)
        femaleButton.backgroundColor = UIColor.cyaMagenta
    }
    
    @objc func setMaleValue(){
        gender = "M"
        maleButton.setTitleColor(.white, for: .normal)
        maleButton.backgroundColor = UIColor.cyaMagenta
        
        femaleButton.setTitleColor(.cyaMagenta, for: .normal)
        femaleButton.backgroundColor = UIColor.clear
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
        
        self.avatarButton.setImage(image_data, for: .normal)
        self.avatarImage = image_data
        self.uploadAvatar = true
        
        self.dismiss(animated: true, completion: nil)
        
        
    }
    
    @objc func saveGralInfo(){
        
        let userGralInfo: User = User()

        userGralInfo.dob = dobTextField.text == "" ? nil : dobTextField.text
        userGralInfo.first_name = firstNameTextField.text == "" ? nil : firstNameTextField.text
        userGralInfo.gender = gender
        userGralInfo.last_name = lastNameTextField.text == "" ? nil : lastNameTextField.text
        userGralInfo.notes = aboutMeTextField.text == "" ? nil : aboutMeTextField.text
        userGralInfo.user_id = UserDisplayObject.userId
        
        if(uploadAvatar){
            let uploadService: UploadService = UploadService()
            let avatarData: AnyObject = uploadService.uploadAvatar(image: self.avatarImage!)
            
            if let errorResponse = avatarData as? ErrorResponseDisplayObject{
            }else{
                userGralInfo.avatar = avatarData as! String
            }
        }

        let userService: UserService = UserService()

        let dataObject: AnyObject = userService.userUpdate(user: userGralInfo)

        if let errorResponse = dataObject as? ErrorResponseDisplayObject{
            setErrorMessage(errorResponse: errorResponse)
        }else{
            let user: UserIdNumber = dataObject as! UserIdNumber

            UserDisplayObject.avatar = user.avatar!
            UserDisplayObject.username = user.username!

            var mainView: UIStoryboard!
            mainView = UIStoryboard(name: "EventList", bundle: nil)
            let viewcontroller : UIViewController = mainView.instantiateViewController(withIdentifier: "EventList") as UIViewController
            self.show(viewcontroller, sender: nil)
        }
        
    }
    
    func setErrorMessage(errorResponse: ErrorResponseDisplayObject){
        print(errorResponse)
        errorLabel.isHidden = false

        if (errorResponse.code != nil || errorResponse.statusCode != nil){
            errorLabel.text = errorResponse.message
        }else{
            errorLabel.text = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
        }

    }
    
    @objc func donePickerPressed(){
        
        let calendar: Calendar = Calendar.current
        let year = calendar.component(.year, from: datePicker.date)
        let month = calendar.component(.month, from: datePicker.date)
        let day = calendar.component(.day, from: datePicker.date)
        
        let monthStr = String(format: "%02d", month)
        let dayStr = String(format: "%02d", day)
        dobTextField.text = "\(year)-\(monthStr)-\(dayStr)"
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
        
        view.backgroundColor = UIColor.gray
        
        setGradientLayer()
        setViewContent()
        setCyaImage()
        setTextField()
        setDatePicker()
        setAvatar()
        setGender()
        setErrorMessage()
        setFooter()
        setSkipButton()
        
       
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
    
    func setCyaImage(){
        viewContent.addSubview(cyaImage)
        
        cyaImage.translatesAutoresizingMaskIntoConstraints = false
        
        cyaImage.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        cyaImage.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 30).isActive = true
        cyaImage.heightAnchor.constraint(equalToConstant: 45).isActive = true
        cyaImage.widthAnchor.constraint(equalToConstant: 65).isActive = true
        
        cyaImage.image = UIImage(named: "cya_icon")
        cyaImage.contentMode = .scaleAspectFit
    }
    
    func setAvatar(){
        
        viewContent.addSubview(avatarContainer)
        avatarContainer.addSubview(avatarButton)
        
        avatarButton.translatesAutoresizingMaskIntoConstraints = false
        avatarContainer.translatesAutoresizingMaskIntoConstraints = false
        
        avatarContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        avatarContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        avatarContainer.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        avatarContainer.bottomAnchor.constraint(equalTo: firstNameTextField.topAnchor, constant: 0).isActive = true
        
        avatarButton.centerXAnchor.constraint(equalTo: avatarContainer.centerXAnchor, constant: 0).isActive = true
        avatarButton.centerYAnchor.constraint(equalTo: avatarContainer.centerYAnchor, constant: 20).isActive = true
        avatarButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        avatarButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        avatarButton.layer.cornerRadius = 50
        avatarButton.setImage(UIImage(named: "profile"), for: .normal)
        avatarButton.layer.masksToBounds = true
        avatarButton.imageView?.contentMode = .scaleAspectFit
        avatarButton.addTarget(self, action: #selector(avatarButtonAction), for: .touchUpInside)
    }
    
    func setTextField(){
        
        viewContent.addSubview(dobTextField)
        viewContent.addSubview(lastNameTextField)
        viewContent.addSubview(firstNameTextField)
        viewContent.addSubview(aboutMeTextField)
        
        dobTextField.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextField.translatesAutoresizingMaskIntoConstraints = false
        
        
        dobTextField.centerYAnchor.constraint(equalTo: viewContent.centerYAnchor, constant: -10).isActive = true
        dobTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        dobTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        dobTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dobTextField.font = FontCya.CyaTextField
        dobTextField.backgroundColor = UIColor.white
        dobTextField.placeholder = "   Date of Birth"
        dobTextField.layer.masksToBounds = true
        dobTextField.textColor = UIColor.gray
        dobTextField.layer.cornerRadius = 12
        
        
        lastNameTextField.bottomAnchor.constraint(equalTo: dobTextField.topAnchor, constant: -20).isActive = true
        lastNameTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        lastNameTextField.font = FontCya.CyaTextField
        lastNameTextField.backgroundColor = UIColor.white
        lastNameTextField.placeholder = "   Last Name"
        lastNameTextField.layer.masksToBounds = true
        lastNameTextField.textColor = UIColor.gray
        lastNameTextField.layer.cornerRadius = 12
        lastNameTextField.delegate = self
        
        firstNameTextField.bottomAnchor.constraint(equalTo: lastNameTextField.topAnchor, constant: -20).isActive = true
        firstNameTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        firstNameTextField.font = FontCya.CyaTextField
        firstNameTextField.backgroundColor = UIColor.white
        firstNameTextField.placeholder = "   First Name"
        firstNameTextField.layer.masksToBounds = true
        firstNameTextField.textColor = UIColor.gray
        firstNameTextField.layer.cornerRadius = 12
        firstNameTextField.delegate = self
        
        
        aboutMeTextField.topAnchor.constraint(equalTo: dobTextField.bottomAnchor, constant: 20).isActive = true
        aboutMeTextField.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        aboutMeTextField.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        aboutMeTextField.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        aboutMeTextField.font = FontCya.CyaTextField
        aboutMeTextField.backgroundColor = UIColor.white

        aboutMeTextField.placeholder = "About me"
        aboutMeTextField.layer.masksToBounds = true
        aboutMeTextField.textColor = UIColor.gray
        aboutMeTextField.layer.cornerRadius = 12
        aboutMeTextField.delegate = self
        
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
    
    func setGender(){
        
        viewContent.addSubview(genderContainer)
        genderContainer.addSubview(femaleButton)
        genderContainer.addSubview(maleButton)
        
        genderContainer.translatesAutoresizingMaskIntoConstraints = false
        femaleButton.translatesAutoresizingMaskIntoConstraints = false
        maleButton.translatesAutoresizingMaskIntoConstraints = false
        
        genderContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        genderContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        genderContainer.heightAnchor.constraint(equalToConstant: 40).isActive = true
        genderContainer.topAnchor.constraint(equalTo: aboutMeTextField.bottomAnchor, constant: 20).isActive = true
        
        femaleButton.leftAnchor.constraint(equalTo: genderContainer.leftAnchor, constant: 4).isActive = true
        femaleButton.rightAnchor.constraint(equalTo: genderContainer.centerXAnchor, constant: 0).isActive = true
        femaleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        femaleButton.topAnchor.constraint(equalTo: genderContainer.topAnchor, constant: 0).isActive = true
        
        femaleButton.setTitle("Female", for: .normal)
        femaleButton.setTitleColor(.white, for: .normal)
        femaleButton.titleLabel?.font = FontCya.CyaTitlesH4
        femaleButton.layer.borderColor = UIColor.cyaMagenta.cgColor
        femaleButton.layer.cornerRadius = 4
        femaleButton.layer.borderWidth = 2
        femaleButton.backgroundColor = UIColor.cyaMagenta
        femaleButton.addTarget(self, action: #selector(setFemaleValue), for: .touchUpInside)
        
        
        maleButton.leftAnchor.constraint(equalTo: genderContainer.centerXAnchor, constant: -4).isActive = true
        maleButton.rightAnchor.constraint(equalTo: genderContainer.rightAnchor, constant: 0).isActive = true
        maleButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        maleButton.topAnchor.constraint(equalTo: genderContainer.topAnchor, constant: 0).isActive = true
        
        maleButton.setTitle("Male", for: .normal)
        maleButton.setTitleColor(.cyaMagenta, for: .normal)
        maleButton.titleLabel?.font = FontCya.CyaTitlesH4
        maleButton.layer.borderColor = UIColor.cyaMagenta.cgColor
        maleButton.layer.cornerRadius = 4
        maleButton.layer.borderWidth = 2
        maleButton.backgroundColor = UIColor.clear
        maleButton.addTarget(self, action: #selector(setMaleValue), for: .touchUpInside)
    }
    
    func setErrorMessage(){
        
        viewContent.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 10).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -10).isActive = true
        errorLabel.topAnchor.constraint(equalTo: maleButton.bottomAnchor, constant: 5).isActive = true
        
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.cyaMagenta
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.sizeToFit()
        errorLabel.text = ""
        errorLabel.font = FontCya.CyaError
    }
    
    func setSkipButton(){
        
        viewContent.addSubview(skipContainer)
        skipContainer.addSubview(skipButton)
        skipContainer.addSubview(doneButton)
        
        skipContainer.translatesAutoresizingMaskIntoConstraints = false
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        
        skipContainer.topAnchor.constraint(equalTo: genderContainer.bottomAnchor, constant: 0).isActive = true
        skipContainer.bottomAnchor.constraint(equalTo: footerView.topAnchor, constant: 0).isActive = true
        skipContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 30).isActive = true
        skipContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -30).isActive = true
        
        skipButton.layer.masksToBounds = true
        skipButton.rightAnchor.constraint(equalTo: skipContainer.rightAnchor, constant: -30).isActive = true
        skipButton.leftAnchor.constraint(equalTo: skipContainer.centerXAnchor, constant: 0).isActive = true
        skipButton.centerYAnchor.constraint(equalTo: skipContainer.centerYAnchor, constant: 5).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        skipButton.titleLabel?.font = FontCya.CyaTextField
        skipButton.setTitleColor(.white, for: .normal)
        skipButton.addTarget(self, action: #selector(skipAction), for: .touchUpInside)
        skipButton.setTitle("Skip", for: .normal)
        
        doneButton.layer.masksToBounds = true
        doneButton.rightAnchor.constraint(equalTo: skipContainer.centerXAnchor, constant: 0).isActive = true
        doneButton.leftAnchor.constraint(equalTo: skipContainer.leftAnchor, constant: 30).isActive = true
        doneButton.centerYAnchor.constraint(equalTo: skipContainer.centerYAnchor, constant: 5).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        doneButton.titleLabel?.font = FontCya.CyaTextField
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.addTarget(self, action: #selector(saveGralInfo), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
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

