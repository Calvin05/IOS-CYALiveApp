//
//  ChatController.swift
//  Cya
//
//  Created by Rigo on 18/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import Foundation

class ChatController: UIViewController,  UITableViewDelegate, UITableViewDataSource  {
    
    private var tableview: UITableView = UITableView()
    private var messageInput: UITextField = UITextField()
    private let btnSend = UIButton()
    private let contentView: UIView = UIView()
    private let headerTable: EdgeInsetLabel = EdgeInsetLabel()
    
    private let buttonClosed   = UIButton(type: UIButtonType.system)
    
    lazy var notification: UIColor = UIColor.clear
    weak var delegate: notificationMessageDelegate?
    var activeTextField: UITextField?
    var ntfc: Bool = false
    
    
    var message = ChatMessageDisplayObject()
    var chatService: ChatService?

    var notificationMessage: Int? = 0
    
    var messages : [ChatMessageDisplayObject] = []{
        didSet {
            DispatchQueue.main.async {
                self.reloadScrolTable()
            }
        }
        
    }
    
    func notificationMessages(newColor: UIColor) -> UIColor {
        let color:UIColor
    
        color = newColor
        return color
    }
    
    func setChatService(chatService: ChatService){
        self.chatService = chatService
        servicesChat()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationKeyboard()
        setupView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ChatController.dismissKeyboard))
//        view.addGestureRecognizer(tap)
    }
    
   
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        view.backgroundColor = UIColor.clear
//        view.backgroundColor = UIColor(white: 1, alpha: 0)
        view.isOpaque = false
        
        self.reloadScrolTable()

    }
    
    
    
}

// MARK: TexktField
extension ChatController: UITextFieldDelegate {
    
    func notificationKeyboard(){
        let center: NotificationCenter = NotificationCenter.default;
        
        center.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification)
    {
        let keyboardFrame: NSValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)!
        let keyboarRectangle = keyboardFrame.cgRectValue
        let keyboardHeigth = keyboarRectangle.height
        
        var boottomSafeHeigth: CGFloat = 0.0
        let toolBarrMenuHeigth: CGFloat = 50.0
        
        if #available(iOS 11.0, *) {
            boottomSafeHeigth = (self.parent?.view.safeAreaInsets.bottom)!
        }
        
        if self.view.frame.origin.y >= 0{
                UIView.animate(withDuration: 0.25, delay: 0.0, options:
                    UIViewAnimationOptions.curveEaseIn, animations: {
                        self.view.frame = CGRect(x:0, y: boottomSafeHeigth + toolBarrMenuHeigth - keyboardHeigth, width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
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
    
    
    override func viewWillDisappear(_ animated: Bool) {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        self.view.endEditing(true)
    }
    
    
    
    
}

// MARK: - Services
extension ChatController {
    func onNewMessage(){
        chatService?.onNewMessage(handler: {data, ack in
            self.messages.append(data!)
            self.reloadScrolTable()
            self.delegate?.notificationMessages(newColor: UIColor.white)
            
        })
    }
    
    
    func onChatHistory(){
        self.chatService?.onChatHistory(){ data, err in
                self.messages = data!
        }

    }
    
    
    func onDeleteMesssage(){
        self.chatService?.onDeleteMesssage(handler: { data, ack in
            
            self.reloadScrolTable()
        })
    }
    
    func onUserBlocked(){
        self.chatService?.onUserBlocked(handler: { data, ack in
            if UserDisplayObject.userId == data {
                self.localUserBlocked()
            }
        })
    }
    
    func onUserUnblocked(){
        self.chatService?.onUserUnblocked(handler: {data, ack in
            self.localUserUnBlocke()
        })
    }
    
    
    func servicesChat(){
        
        onNewMessage()
        onChatHistory()
        onDeleteMesssage()
        onUserBlocked()
        
    }
    
    func deleteMessage(msg: String){
        // implement delete message
        // self.chatService.deleteMessage(msgId: msg)
        print("deleteMessagee :\(msg)")
    }
    
    func markAsQuestion(msg: String){
        
        //self.markAsQuestion(msg: msg)
        
        print("markAsQuestion :\(msg)")
    }
    
    func blockUser(msg: String){
        //self.blockUser(msg: msg)
        print("blockUser :\(msg)")
    }
    
    func unblockUser(msg: String) {}
    
}


    // MARK: - SetupView

extension ChatController {
    
    func setupView(){
        configTabel()
        loadInputButton()
    }
    
    func configTabel(){
        
        view.backgroundColor = UIColor.Cya_Facebook_Blue_Pressed.withAlphaComponent(0.6)
        
        headerTable.text="Chat Room"
        headerTable.font = UIFont(name: "Avenir-Book", size: 16)
        headerTable.topTextInset = 10
        headerTable.leftTextInset = 30
        headerTable.bottomTextInset = 10
        headerTable.rightTextInset = 10
        headerTable.backgroundColor = .black
        headerTable.alpha = 0.5
        
        buttonClosed.setTitle("Close", for: .normal)
        buttonClosed.setTitleColor(.darkGray, for: .normal)
        buttonClosed.addTarget(self, action: #selector(closeChat), for: .touchUpInside)
        
        
        tableview.register(MessageChatCell.self, forCellReuseIdentifier: "MessageChatCell")
        tableview.register(MessageChatCellUser.self, forCellReuseIdentifier: "MessageChatCellUser")
        tableview.dataSource = self
        tableview.delegate = self
        
        tableview.estimatedRowHeight = 74
        tableview.rowHeight = UITableViewAutomaticDimension
        tableview.separatorStyle = UITableViewCellSeparatorStyle.none

//        tableview.alpha = 0.5
//        tableview.layer.masksToBounds = true
//
//        tableview.layer.borderColor = UIColor.darkGray.cgColor
        tableview.backgroundColor = UIColor.clear
//
//        tableview.layer.cornerRadius = 15
//        tableview.layer.borderWidth = 1
        
//        self.view.addSubview(headerTable)
//        self.view.addSubview(buttonClosed)
        
        self.view.addSubview(tableview)
        
//        headerTable.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
//        headerTable.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
//        headerTable.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
//        headerTable.heightAnchor.constraint(equalToConstant: 90)
//        headerTable.translatesAutoresizingMaskIntoConstraints = false
        
//        buttonClosed.rightAnchor.constraint(equalTo: headerTable.rightAnchor, constant: -20).isActive = true
//        buttonClosed.topAnchor.constraint(equalTo: headerTable.topAnchor, constant: 5).isActive = true
//        buttonClosed.translatesAutoresizingMaskIntoConstraints = false
        
        tableview.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableview.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        tableview.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        tableview.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -55).isActive = true
        tableview.translatesAutoresizingMaskIntoConstraints = false
    }
}

extension ChatController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // alertChat(idSender: messages[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
//        if messages[indexPath.row].user_id == UserDisplayObject.userId {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChatCellUser") as! MessageChatCellUser
//            cell.avatar.downloadedFrom(defaultImage: "profile", link: (messages[indexPath.row].profile?.avatar!)!)
//        //cell.avatar.downloadedFrom(defaultImage: "profile", link: self.viewersArray[indexPath.item].avatar!)
//            let msnFull = " \((messages[indexPath.row].profile?.username!)!): \(messages[indexPath.row].content!)  "
//            let strMessage = attributedText(str1: msnFull, str2: (messages[indexPath.row].profile?.username!)!)
//            cell.messageLabel.attributedText = strMessage
//
//
//            return cell
//        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageChatCell") as! MessageChatCell
            
            cell.backgroundColor = UIColor.clear
            
//            let msnFull = "\((messages[indexPath.row].profile?.username!)!)\n\(messages[indexPath.row].content!)  "
//            let strMessage = attributedText(str1: msnFull, str2: (messages[indexPath.row].profile?.username!)!)
//            cell.messageLabel.attributedText = strMessage
        
            cell.messageLabel.text = messages[indexPath.row].content!
            cell.userNameLabel.text = (messages[indexPath.row].profile?.username!)!
            cell.avatar.downloadedFrom(defaultImage: "profile", link: (messages[indexPath.row].profile?.avatar!)!)
            return cell
//        }
    }
    

    
    func scrollTable(animatedScroll: Bool){
        if(self.messages.count > 0){
            let lastIndexPath = IndexPath.init(row: self.messages.count-1, section: 0)
            tableview.scrollToRow(at: lastIndexPath, at: .bottom, animated: animatedScroll)
        }
        
    }
    
    func reloadScrolTable(){
        self.tableview.reloadData()
        self.scrollTable(animatedScroll: false)
    }
    
    

    
    func attributedText(str1: String, str2: String)-> NSAttributedString
    {
        let string = str1 as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 15.0)])
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 15.0)]
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: str2))
        return attributedString
    }
}



// MARK: - Input & Button Chat
extension ChatController {

    func loadInputButton(){
        
        
        contentView.layer.backgroundColor = UIColor.clear.cgColor

        
        messageInput.font = UIFont(name: "Avenir-Book", size: 15)
        messageInput.layer.borderColor = UIColor.lightGray.cgColor
        messageInput.backgroundColor = UIColor.white
//        messageInput.placeholder = "   New Message"
        messageInput.layer.masksToBounds = true
        messageInput.textColor = UIColor.black
        messageInput.layer.cornerRadius = 16
        messageInput.layer.borderWidth = 1
        messageInput.delegate = self
        
        messageInput.addTarget(self, action: #selector(messageInputDidChange), for: .editingChanged)

        
        btnSend.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        btnSend.titleLabel!.font =  UIFont(name: "Avenir-Book" , size: 16)
        btnSend.titleLabel!.font = .boldSystemFont(ofSize: 16)
        btnSend.setTitleColor(.black, for: .normal)
        btnSend.setTitle(">", for: .normal)
        btnSend.backgroundColor = UIColor.white
        btnSend.layer.cornerRadius = 16
//        btnSend.setImage(UIImage(named: "cya_send"), for: .normal)
        btnSend.imageView?.contentMode = .scaleAspectFit
        btnSend.isEnabled = false
       
        
        self.view.addSubview(contentView)
        contentView.addSubview(messageInput)
        contentView.addSubview(btnSend)

        constraintInputButton()
    }
    
    func constraintInputButton(){
        
        
        contentView.topAnchor.constraint(equalTo: tableview.bottomAnchor, constant: 0).isActive = true
        contentView.leftAnchor.constraint(equalTo: tableview.leftAnchor, constant: 0).isActive = true
        contentView.rightAnchor.constraint(equalTo: tableview.rightAnchor, constant: 0).isActive = true
        contentView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        contentView.translatesAutoresizingMaskIntoConstraints = false

        messageInput.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        messageInput.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 15).isActive = true
        messageInput.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -50).isActive = true
        messageInput.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        messageInput.translatesAutoresizingMaskIntoConstraints = false
        
        messageInput.leftView = PaddingUITextField.getPadding(x: 0, y: 0, width: 15, height: Int(self.messageInput.frame.height))
        messageInput.leftViewMode = UITextFieldViewMode.always
        
        messageInput.rightView = PaddingUITextField.getPadding(x: 0, y: 0, width: 15, height: Int(self.messageInput.frame.height))
        messageInput.rightViewMode = UITextFieldViewMode.always
        
        
        
        btnSend.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        btnSend.leftAnchor.constraint(equalTo: messageInput.rightAnchor, constant: 8).isActive = true
        
        btnSend.heightAnchor.constraint(equalToConstant: 32).isActive = true
        btnSend.widthAnchor.constraint(equalToConstant: 32).isActive = true
        
        
        btnSend.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @objc func messageInputDidChange(messageInput: UITextField){
        
        if (messageInput.text != nil && messageInput.text != "" && messageInput.text?.trimmingCharacters(in: .whitespaces) != ""){

            self.btnSend.isEnabled = true
        }else{
            self.btnSend.isEnabled = false
        }
    }
    
    @objc func sendMessage(sender:UIButton!) {
        
//        self.message.profile?.avatar = messageInput.text
        self.message.profile?.avatar = UserDisplayObject.avatar
        self.message.chat_id = "94008a45-63aa-4fd1-a1eb-920682af0576"
        self.message.created_time = "12pm"
        self.message.id = "1231"
        self.message.user_id = UserDisplayObject.userId
        self.message.profile?.username = UserDisplayObject.username
        
        
        
        if (messageInput.text != nil && messageInput.text != "" && messageInput.text?.trimmingCharacters(in: .whitespaces) != ""){
            
            chatService?.sendMessage(msg: messageInput.text!)
            messageInput.text = ""
            
            self.btnSend.isEnabled = false
            
//            self.messageInput.resignFirstResponder()
        }
    }
    
    @objc func closeChat(sender:UIButton!) {

        delegate?.notificationMessages(newColor: UIColor.clear)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}


// MARK: - Alerts
extension ChatController {
    
    func alertChat(idSender: ChatMessageDisplayObject){
        
        let alertController = UIAlertController(title: "\(idSender.profile?.username!):", message: "\(idSender.content!)", preferredStyle: .actionSheet)
        let markAsQuestion =  UIAlertAction(title: "Mark as Question", style: .default, handler:  {(action: UIAlertAction) in self.markAsQuestion(msg:"\(idSender.created_time!)") })
        let deleteMessage = UIAlertAction(title: "Delete Comment", style: .default, handler: {(action: UIAlertAction) in self.deleteMessage(msg:"\(idSender.created_time!)") })
        let blockUser = UIAlertAction(title: "Block user", style: .default, handler:  {(action: UIAlertAction) in self.blockUser(msg:"\(idSender.user_id!)") })
        
        alertController.addAction(markAsQuestion)
        alertController.addAction(deleteMessage)
        alertController.addAction(blockUser)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
}

// MARK: - User Block
extension ChatController {
    
    func localUserBlocked(){
        self.messageInput.isUserInteractionEnabled = false
        self.messageInput.placeholder = "User is blocked"
    }
    
    func localUserUnBlocke(){
        self.messageInput.isUserInteractionEnabled = true
        self.messageInput.placeholder = "New Message"
    }
}

protocol notificationMessageDelegate: class {
    func notificationMessages(newColor: UIColor)

}





