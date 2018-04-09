//
//  EditSettingsController.swift
//  Cya
//
//  Created by Cristopher Torres on 12/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class EditSettingsController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    var viewContent: UIView = UIView()
    let viewHeader: UIView = UIView()
    let doneButton: UIButton = UIButton(type: .system) as UIButton
    var settingsLabel: EdgeInsetLabel = EdgeInsetLabel()
    let aspectRatio = AspectRatio(aspect: "HD Video")
    var profileImage: UIImageView = UIImageView()
    var addPhotoButton: UIButton = UIButton(type: .system) as UIButton
    
    var settingsTextFieldContainer: UIView = UIView()
    var settingsTextField: SettingsTextField?
    
    var backButtonView: BackButtonView?
    var footer: FooterSettingsComponent = FooterSettingsComponent()
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    var userService: UserService = UserService()
    var user: User = User()
    
    var uploadAvatar: Bool = false
    var avatarImage: UIImage?
    
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        user = userService.getUserById(userId: UserDisplayObject.userId)
        setupView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func doneAction(){
        settingsTextField?.view.endEditing(true)
        let dobTextField: String = (settingsTextField?.settingsTextFieldCellCollection[0].dobTextField.text)!
        let firstNameTextField: String = (settingsTextField?.settingsTextFieldCellCollection[0].firstNameTextField.text)!
        let lastNameTextField: String = (settingsTextField?.settingsTextFieldCellCollection[0].lastNameTextField.text)!
        let aboutMeTextField: String = (settingsTextField?.settingsTextFieldCellCollection[0].aboutMeTextField.text)!
        let userNameTextField: String = (settingsTextField?.settingsTextFieldCellCollection[0].userNameTextField.text)!
        
        let userGralInfo: User = User()
        
        userGralInfo.dob = dobTextField == "" ? nil : dobTextField
        userGralInfo.first_name = firstNameTextField == "" ? nil : firstNameTextField
        userGralInfo.last_name = lastNameTextField == "" ? nil : lastNameTextField
        userGralInfo.notes = aboutMeTextField == "" ? nil : aboutMeTextField
        userGralInfo.username = userNameTextField == "" ? nil : userNameTextField
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
        
//        let dataObject: AnyObject = userService.userUpdate(user: userGralInfo)
//        
//        if let errorResponse = dataObject as? ErrorResponseDisplayObject{
//            setErrorMessage(errorResponse: errorResponse)
//        }else{
//            let user: UserIdNumber = dataObject as! UserIdNumber
//            if(user.avatar != nil){
//                UserDisplayObject.avatar = user.avatar!
//                UserDisplayObject.username = user.username!
//            }
//            
//            backButtonView?.backAction()
//        }
    }
    
    func setErrorMessage(errorResponse: ErrorResponseDisplayObject){
        settingsTextField?.settingsTextFieldCellCollection[0].errorLabel.isHidden = false

        if (errorResponse.code != nil || errorResponse.statusCode != nil){
            settingsTextField?.settingsTextFieldCellCollection[0].errorLabel.text = errorResponse.message
        }else{
            settingsTextField?.settingsTextFieldCellCollection[0].errorLabel.text = "\(errorResponse.errors![0].errors![0].description!): \(errorResponse.errors![0].errors![0].message!)"
        }
        let indexPath = NSIndexPath(item: 0, section: 0)
        settingsTextField?.collectionView?.scrollToItem(at: indexPath as IndexPath, at: .bottom , animated: false)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let image_data = info[UIImagePickerControllerOriginalImage] as? UIImage
        
        self.profileImage.image = image_data
        self.avatarImage = image_data
        self.uploadAvatar = true
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @objc func addPhotoAction(){
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self;
        myPickerController.sourceType =  UIImagePickerControllerSourceType.photoLibrary
        self.present(myPickerController, animated: true, completion: nil)
    }

}

extension EditSettingsController{
    
    func setupView(){
        
        view.backgroundColor = UIColor.white
        
        setViewContent()
        setHeader()
        setBackButton()
        setDoneButton()
        setSettingsLabel()
        setLayoutBottomBar()
        setProfileImage()
        setTextFieldContainer()
        setFooter()
        setAddPhotoButton()
        
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor, constant: 0).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.white
    }
    
    func setHeader(){
        viewContent.addSubview(viewHeader)
        
        viewHeader.translatesAutoresizingMaskIntoConstraints = false
        
        viewHeader.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        viewHeader.heightAnchor.constraint(equalToConstant: 20).isActive = true
        viewHeader.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        viewHeader.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        viewHeader.backgroundColor = UIColor.white
    }
    
    func setSettingsLabel(){
        viewContent.addSubview(settingsLabel)
        
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        settingsLabel.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 50).isActive = true
        settingsLabel.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 20).isActive = true
        settingsLabel.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        settingsLabel.textColor = UIColor.black
        settingsLabel.numberOfLines = 0
        settingsLabel.textAlignment = .left
        settingsLabel.lineBreakMode = .byWordWrapping
        settingsLabel.sizeToFit()
        settingsLabel.text = "Settings"
        settingsLabel.font = FontCya.CyaTextButtonRegXL
    }
    
    func setDoneButton(){

        viewContent.addSubview(doneButton)

        doneButton.translatesAutoresizingMaskIntoConstraints = false

        doneButton.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 30).isActive = true
        doneButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -15).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        doneButton.widthAnchor.constraint(equalToConstant: 60).isActive = true

        doneButton.titleLabel?.font = FontCya.CyaTitlesH2
        doneButton.setTitleColor(.cyaMagenta, for: .normal)
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.contentHorizontalAlignment = .right
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
    
    func setProfileImage(){
        
        let height16_9 = aspectRatio.getHeightFromWidth(elementWidth: Float(self.view.frame.size.width))
        
        viewContent.addSubview(profileImage)
        
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        
        profileImage.topAnchor.constraint(equalTo: settingsLabel.bottomAnchor, constant: 10).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: CGFloat(height16_9)).isActive = true
        profileImage.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        profileImage.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        profileImage.layer.masksToBounds = true
        profileImage.downloadedFrom(defaultImage: "profile", link: user.avatar!, contentMode: .scaleAspectFill)
    }
    
    func setAddPhotoButton(){
        viewContent.addSubview(addPhotoButton)
        
        addPhotoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addPhotoButton.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 10).isActive = true
//        addPhotoButton.leftAnchor.constraint(equalTo: nameLabel.rightAnchor, constant: 0).isActive = true
        addPhotoButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -5).isActive = true
        
        addPhotoButton.titleLabel?.font = FontCya.CyaTitlesH4Light
        addPhotoButton.setTitleColor(.cyaMagenta, for: .normal)
        addPhotoButton.addTarget(self, action: #selector(addPhotoAction), for: .touchUpInside)
        addPhotoButton.setTitle("Add a Photo", for: .normal)
        addPhotoButton.contentHorizontalAlignment = .left
//        addPhotoButton.backgroundColor = UIColor.blue
    }
    
    func setTextFieldContainer(){
        
        let layout = UICollectionViewFlowLayout()
        self.settingsTextField = SettingsTextField(collectionViewLayout: layout, user: user)
        addChildViewController(settingsTextField!)
        
        viewContent.addSubview(settingsTextFieldContainer)
        settingsTextFieldContainer.addSubview(settingsTextField!.view)
        
        settingsTextFieldContainer.translatesAutoresizingMaskIntoConstraints = false
        settingsTextField!.view.translatesAutoresizingMaskIntoConstraints = false
        
        
        settingsTextFieldContainer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: 0).isActive = true
        settingsTextFieldContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        settingsTextFieldContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        settingsTextFieldContainer.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 0).isActive = true
        
        settingsTextFieldContainer.backgroundColor = UIColor.white
        
        
        settingsTextField!.view.bottomAnchor.constraint(equalTo: settingsTextFieldContainer.bottomAnchor, constant: -25).isActive = true
        settingsTextField!.view.leftAnchor.constraint(equalTo: settingsTextFieldContainer.leftAnchor, constant: 0).isActive = true
        settingsTextField!.view.rightAnchor.constraint(equalTo: settingsTextFieldContainer.rightAnchor, constant: 0).isActive = true
        settingsTextField!.view.topAnchor.constraint(equalTo: settingsTextFieldContainer.topAnchor, constant: 0).isActive = true
        
        settingsTextField!.view.backgroundColor = UIColor.white
        
        settingsTextField!.didMove(toParentViewController: self)

        
    }
    
    func setLayoutBottomBar(){
        toolBarMenu.setCurrenView(currentView: "Settings")
        toolBarMenu.setParentView(parentView: self)
        viewContent.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: viewContent.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(toolBarMenuBackground)
        
        toolBarMenuBackground.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarMenuBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolBarMenuBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        toolBarMenuBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        toolBarMenuBackground.topAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: 0).isActive = true
        
        toolBarMenuBackground.backgroundColor = UIColor.darkGray
    }
    
    func setFooter(){
        
        viewContent.addSubview(footer)
        
        footer.translatesAutoresizingMaskIntoConstraints = false
        
        footer.bottomAnchor.constraint(equalTo: toolBarMenu.topAnchor, constant: -8).isActive = true
        footer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        footer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        footer.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
}

extension EditSettingsController: UITextFieldDelegate {
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

