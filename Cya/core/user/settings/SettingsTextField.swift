//
//  SettingsTextField.swift
//  Cya
//
//  Created by Cristopher Torres on 13/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class SettingsTextField: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var settingsTextFieldCellCollection: [SettingsTextFieldCell] = []
    var user: User = User()
    
    init(collectionViewLayout layout: UICollectionViewLayout, user: User) {
        super.init(collectionViewLayout: layout)
        self.user = user
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(SettingsTextFieldCell.self, forCellWithReuseIdentifier: cellId)

    }

    // MARK: UICollectionViewDataSource


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SettingsTextFieldCell
        
        cell.dobTextField.text = user.dob
        cell.firstNameTextField.text = user.first_name
        cell.lastNameTextField.text = user.last_name
        cell.aboutMeTextField.text = user.notes
        cell.userNameTextField.text = user.username
        
        
        settingsTextFieldCellCollection.append(cell)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avatarHeight = (CGFloat(450))
        let avatarWidth = (self.view.frame.size.width)
        
        return CGSize.init(width: avatarWidth, height: avatarHeight)
    }

}

class SettingsTextFieldCell: UICollectionViewCell{
    
    
    var firstNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var firstNameTextField: UITextField = UITextField()
    
    var lastNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var lastNameTextField: UITextField = UITextField()
    
    var userNameLabel: EdgeInsetLabel = EdgeInsetLabel()
    var userNameTextField: UITextField = UITextField()
    
    var dobLabel: EdgeInsetLabel = EdgeInsetLabel()
    var dobTextField: UITextField = UITextField()
    var datePicker: UIDatePicker = UIDatePicker()
    
    var aboutMeLabel: EdgeInsetLabel = EdgeInsetLabel()
    var aboutMeTextField: UITextView = UITextView()
    
    var errorLabel: EdgeInsetLabel = EdgeInsetLabel()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        setFirstName()
        setLastName()
        setUserName()
        setDOB()
        setAboutMe()
        setErrorMessage()
        setDatePicker()
    }
    
    func setFirstName(){
        
        let line: UIView = UIView()
        
        contentView.addSubview(firstNameLabel)
        contentView.addSubview(firstNameTextField)
        contentView.addSubview(line)
        
        firstNameLabel.translatesAutoresizingMaskIntoConstraints = false
        firstNameTextField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        
        firstNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        firstNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
        
        firstNameLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        firstNameLabel.numberOfLines = 0
        firstNameLabel.textAlignment = .left
        firstNameLabel.lineBreakMode = .byWordWrapping
        firstNameLabel.sizeToFit()
        firstNameLabel.text = "Name"
        firstNameLabel.font = FontCya.CyaTitlesH3
        
        
        firstNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        firstNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        firstNameTextField.topAnchor.constraint(equalTo: firstNameLabel.bottomAnchor, constant: 7).isActive = true
        firstNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        firstNameTextField.font = FontCya.CyaInput
        firstNameTextField.backgroundColor = UIColor.white
        firstNameTextField.textColor = UIColor.cyaMagenta
        
        line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = UIColor.Cya_Placeholder_Background_Color
    }
    
    func setLastName(){
        
        let line: UIView = UIView()
        
        contentView.addSubview(lastNameLabel)
        contentView.addSubview(lastNameTextField)
        contentView.addSubview(line)
        
        lastNameLabel.translatesAutoresizingMaskIntoConstraints = false
        lastNameTextField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        
        lastNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        lastNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameTextField.bottomAnchor, constant: 15).isActive = true
        
        lastNameLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        lastNameLabel.numberOfLines = 0
        lastNameLabel.textAlignment = .left
        lastNameLabel.lineBreakMode = .byWordWrapping
        lastNameLabel.sizeToFit()
        lastNameLabel.text = "Last Name"
        lastNameLabel.font = FontCya.CyaTitlesH3
        
        
        lastNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        lastNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        lastNameTextField.topAnchor.constraint(equalTo: lastNameLabel.bottomAnchor, constant: 7).isActive = true
        lastNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        lastNameTextField.font = FontCya.CyaInput
        lastNameTextField.backgroundColor = UIColor.white
        lastNameTextField.textColor = UIColor.cyaMagenta
        
        line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = UIColor.Cya_Placeholder_Background_Color
    }
    
    func setUserName(){
        
        let line: UIView = UIView()
        
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userNameTextField)
        contentView.addSubview(line)
        
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        
        userNameLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        userNameLabel.topAnchor.constraint(equalTo: lastNameTextField.bottomAnchor, constant: 15).isActive = true
        
        userNameLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        userNameLabel.numberOfLines = 0
        userNameLabel.textAlignment = .left
        userNameLabel.lineBreakMode = .byWordWrapping
        userNameLabel.sizeToFit()
        userNameLabel.text = "Username"
        userNameLabel.font = FontCya.CyaTitlesH3
        
        
        userNameTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        userNameTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        userNameTextField.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 7).isActive = true
        userNameTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        userNameTextField.font = FontCya.CyaInput
        userNameTextField.backgroundColor = UIColor.white
        userNameTextField.textColor = UIColor.cyaMagenta
        
        line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = UIColor.Cya_Placeholder_Background_Color
    }
    
    func setDOB(){
        
        let line: UIView = UIView()
        
        contentView.addSubview(dobLabel)
        contentView.addSubview(dobTextField)
        contentView.addSubview(line)
        
        dobLabel.translatesAutoresizingMaskIntoConstraints = false
        dobTextField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        
        dobLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        dobLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        dobLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 15).isActive = true
        
        dobLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        dobLabel.numberOfLines = 0
        dobLabel.textAlignment = .left
        dobLabel.lineBreakMode = .byWordWrapping
        dobLabel.sizeToFit()
        dobLabel.text = "Date of Birth"
        dobLabel.font = FontCya.CyaTitlesH3
        
        
        dobTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        dobTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        dobTextField.topAnchor.constraint(equalTo: dobLabel.bottomAnchor, constant: 7).isActive = true
        dobTextField.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        dobTextField.font = FontCya.CyaInput
        dobTextField.backgroundColor = UIColor.white
        dobTextField.textColor = UIColor.cyaMagenta
        
        line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: dobTextField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = UIColor.Cya_Placeholder_Background_Color
    }
    
    func setAboutMe(){
        
        let line: UIView = UIView()
        
        contentView.addSubview(aboutMeLabel)
        contentView.addSubview(aboutMeTextField)
        contentView.addSubview(line)
        
        aboutMeLabel.translatesAutoresizingMaskIntoConstraints = false
        aboutMeTextField.translatesAutoresizingMaskIntoConstraints = false
        line.translatesAutoresizingMaskIntoConstraints = false
        
        
        aboutMeLabel.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        aboutMeLabel.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        aboutMeLabel.topAnchor.constraint(equalTo: dobTextField.bottomAnchor, constant: 15).isActive = true
        aboutMeLabel.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        
        aboutMeLabel.textColor = UIColor.Cya_Event_List_Live_Text_Shadow_Color
        aboutMeLabel.numberOfLines = 0
        aboutMeLabel.textAlignment = .left
        aboutMeLabel.lineBreakMode = .byWordWrapping
        aboutMeLabel.sizeToFit()
        aboutMeLabel.text = "About"
        aboutMeLabel.font = FontCya.CyaTitlesH3
        
        
        aboutMeTextField.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        aboutMeTextField.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -20).isActive = true
        aboutMeTextField.topAnchor.constraint(equalTo: aboutMeLabel.bottomAnchor, constant: 7).isActive = true
        aboutMeTextField.heightAnchor.constraint(equalToConstant: 250).isActive = true
        aboutMeTextField.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0).isActive = true
        
        aboutMeTextField.font = FontCya.CyaInput
        aboutMeTextField.backgroundColor = UIColor.white
        aboutMeTextField.textColor = UIColor.cyaMagenta
        aboutMeTextField.textAlignment = .justified
        
        line.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        line.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: 0).isActive = true
        line.topAnchor.constraint(equalTo: aboutMeTextField.bottomAnchor, constant: 2).isActive = true
        line.heightAnchor.constraint(equalToConstant: 1).isActive = true
        line.backgroundColor = UIColor.Cya_Placeholder_Background_Color
    }
    
    func setErrorMessage(){
        
        contentView.addSubview(errorLabel)
        
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorLabel.leftAnchor.constraint(equalTo: aboutMeTextField.leftAnchor, constant: 10).isActive = true
        errorLabel.rightAnchor.constraint(equalTo: aboutMeTextField.rightAnchor, constant: -10).isActive = true
        errorLabel.topAnchor.constraint(equalTo: aboutMeTextField.bottomAnchor, constant: 15).isActive = true
        
        errorLabel.isHidden = true
        errorLabel.textColor = UIColor.cyaMagenta
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.lineBreakMode = .byWordWrapping
        errorLabel.sizeToFit()
        errorLabel.text = ""
        errorLabel.font = FontCya.CyaError
    }
    
    @objc func donePickerPressed(){
        
        let calendar: Calendar = Calendar.current
        let year = calendar.component(.year, from: datePicker.date)
        let month = calendar.component(.month, from: datePicker.date)
        let day = calendar.component(.day, from: datePicker.date)
        
        let monthStr = String(format: "%02d", month)
        let dayStr = String(format: "%02d", day)
        dobTextField.text = "\(year)-\(monthStr)-\(dayStr)"
        contentView.endEditing(true)
    }
    
    func setDatePicker(){
        
        datePicker.datePickerMode = .date
        
        let doneButton: UIButton = UIButton(type: .system) as UIButton
        doneButton.titleLabel?.font = FontCya.CyaTitlesH2
        doneButton.setTitleColor(.cyaMagenta, for: .normal)
        doneButton.addTarget(self, action: #selector(donePickerPressed), for: .touchUpInside)
        doneButton.setTitle("Done", for: .normal)
        doneButton.frame.size.height = 45
        doneButton.frame.size.width = 100
        doneButton.contentHorizontalAlignment = .center
        doneButton.contentVerticalAlignment = .center
        
        let buttonContainer = UIView()
        buttonContainer.frame.size.height = 45
        buttonContainer.frame.size.width = contentView.frame.size.width
        buttonContainer.backgroundColor = UIColor.Cya_Placeholder_Background_Color
        
        buttonContainer.addSubview(doneButton)
        
        dobTextField.inputAccessoryView = buttonContainer
        dobTextField.inputView = datePicker
    }
    
}
