//
//  CheckoutController.swift
//  Cya
//
//  Created by Rigo on 14/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//



import UIKit
import Stripe

class CheckoutController: UIViewController , STPPaymentCardTextFieldDelegate, ToolBarMenuDelegate {
    
    var backButtonView: BackButtonView?
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    let aspectRatio = AspectRatio(aspect: "HD Video")
    
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    let viewMain: UIView = UIView()
    let barState: UIView = UIView()
    let viewContainer: UIScrollView = UIScrollView()
    let viewContent: UIView = UIView()
    var paymentTextField: STPPaymentCardTextField! = nil
    var billingAddressFields: STPBillingAddressFields! = nil
    private let btnSend = UIButton(type: .custom) as UIButton
    var submitButton = UIButton(type: .system) as UIButton
    
    
    let titleCardInfo: EdgeInsetLabel = EdgeInsetLabel()
    let titleBillingAddres: EdgeInsetLabel = EdgeInsetLabel()
    
    let fullName: UITextField = UITextField()
    
    let number: UITextField = UITextField()
    let name: UITextField = UITextField()
    let exp_month: UITextField = UITextField()
    let exp_year: UITextField = UITextField()
    let cvc: UITextField = UITextField()
    
    let addressLine1: UITextField = UITextField()
    let addressLine2: UITextField = UITextField()
    let addressCity: UITextField = UITextField()
    let addressState: UITextField = UITextField()
    let addressCountry: UITextField = UITextField()
    let addressZip: UITextField = UITextField()
    
    let titleSectionCardInfo: EdgeInsetLabel = EdgeInsetLabel()
    let titleSectionBillingAddress: EdgeInsetLabel = EdgeInsetLabel()
    
    let titleFullName: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressLine1: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressLine2: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressCity: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressState: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressCountry: EdgeInsetLabel = EdgeInsetLabel()
    let titleAddressZip: EdgeInsetLabel = EdgeInsetLabel()
    
    let errorFullName: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressLine1: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressLine2: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressCity: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressState: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressCountry: EdgeInsetLabel = EdgeInsetLabel()
    let errortitleAddressZip: EdgeInsetLabel = EdgeInsetLabel()
    
    let titleEvent: EdgeInsetLabel = EdgeInsetLabel()
    let price: EdgeInsetLabel = EdgeInsetLabel()
    
    var _purchaseService: PurchaseService   = PurchaseService()
    var _event:Event?
    var dataPayByStripe : PayByStripeDisplayObject?
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
        
       
        notificationKeyboard()
//        notificationKeyboard()
        // Do any additional setup after loading the view.
    }
    
   
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    init(event: Event) {
        super.init(nibName: nil, bundle: nil)
        self._event = event
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

extension CheckoutController: UITextFieldDelegate {
    
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

extension CheckoutController {
    
    func configView(){
        
        view.backgroundColor = UIColor.cyaDarkBg
        
        setGradientLayer()
        setBarState()
        
//        setViewContainer()
        setBackButton()
        setTitleSectionCardInfo()
        setFullName()
        setPaymentText()

        setTitleSectionBilling()

        setBillingAddressFields()
        
        setLayoutBottomBar()
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
        view.addSubview(backButtonView!)
        
        backButtonView?.translatesAutoresizingMaskIntoConstraints = false
        
        backButtonView?.topAnchor.constraint(equalTo: view.topAnchor,constant: 5).isActive = true
        backButtonView?.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        backButtonView?.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        backButtonView?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        backButtonView?.backView.backgroundColor = UIColor.clear
        
    }
    
    func setBarState(){
        self.view.addSubview(barState)
        
        barState.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        barState.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        barState.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 0).isActive = true
        barState.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        barState.translatesAutoresizingMaskIntoConstraints = false
        barState.backgroundColor = UIColor.white
        
    }
    
    func setViewContainer(){

        self.view.addSubview(viewContainer)
        viewContainer.leftAnchor.constraint(equalTo: self.barState.leftAnchor, constant: 0).isActive = true
        viewContainer.rightAnchor.constraint(equalTo: self.barState.rightAnchor, constant: 0).isActive = true
        viewContainer.topAnchor.constraint(equalTo: self.barState.bottomAnchor, constant: 0).isActive = true
        viewContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
        viewContainer.translatesAutoresizingMaskIntoConstraints = false
//        viewContainer.backgroundColor = UIColor.clear
        
        
    }

    
    func setLayoutBottomBar(){
        toolBarMenu.toolBarMenuDelegate = self
        toolBarMenu.setCurrenView(currentView: "Event")
        toolBarMenu.setParentView(parentView: self)
        self.view.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        
    }
    
     func setTitleSectionCardInfo(){
        view.addSubview(titleSectionCardInfo)
        setTitles(title: "Card Info", TextFieldC: titleSectionCardInfo, TextFieldC2: nil, TextFieldC2View: self.view, TextFieldC2STPPaymentCardText: nil, isFirstElemen: true, top: 30, left: 20, right: -20, height: 30)
    }
    
    func setTitleSectionBilling(){
        view.addSubview(titleSectionBillingAddress)
        setTitles(title: "Billing Addres", TextFieldC: titleSectionBillingAddress, TextFieldC2: nil, TextFieldC2View: nil, TextFieldC2STPPaymentCardText: paymentTextField, isFirstElemen: false, top: 10, left: 0, right: 0, height: 30)
    }
    
    func setFullName(){
        fullName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(fullName)

        fullName.leftAnchor.constraint(equalTo: self.titleSectionCardInfo.leftAnchor, constant: 0).isActive = true
        fullName.rightAnchor.constraint(equalTo: self.titleSectionCardInfo.rightAnchor, constant: 0).isActive = true
        fullName.topAnchor.constraint(equalTo: self.titleSectionCardInfo.bottomAnchor, constant: 10).isActive = true
        fullName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        fullName.delegate = self
        configTextField(placeholder: "Full Name on Card", TextFieldC: fullName)
    }
    
    
    func setPaymentText(){
        paymentTextField = STPPaymentCardTextField()
        paymentTextField.delegate = self
        
        
        view.addSubview(paymentTextField)
        
        paymentTextField.translatesAutoresizingMaskIntoConstraints = false
        
        paymentTextField.leftAnchor.constraint(equalTo: fullName.leftAnchor, constant: 0).isActive = true
        paymentTextField.rightAnchor.constraint(equalTo: fullName.rightAnchor, constant: 0).isActive = true
        paymentTextField.topAnchor.constraint(equalTo: fullName.bottomAnchor, constant: 10).isActive = true
        
        paymentTextField.tintColor = UIColor.cyaMagenta
        paymentTextField.font =  FontCya.CyaCheckout
        paymentTextField.layer.borderColor = UIColor.cyaLightGrayBg.cgColor
        paymentTextField.layer.masksToBounds = true
        paymentTextField.textColor = UIColor.cyaLightGrayBg
        paymentTextField.layer.borderWidth = 1
        paymentTextField.alpha = 0.9

    }
    
    func setBillingAddressFields() {
        setAddressLine1()
        setAddressLine2()
        setAddressCity()
        setAddressState()
        setAddressCountry()
        setAddressZip()
        
        setPriceTitle()
        setTitleEvent()
        
        setSubmitButton()
        
    }

     func setAddressLine1(){
        addressLine1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addressLine1)
        
        addressLine1.leftAnchor.constraint(equalTo: titleSectionBillingAddress.leftAnchor, constant: 0).isActive = true
        addressLine1.rightAnchor.constraint(equalTo: titleSectionBillingAddress.rightAnchor, constant: 0).isActive = true
        addressLine1.topAnchor.constraint(equalTo: titleSectionBillingAddress.bottomAnchor, constant: 10).isActive = true
        addressLine1.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        configTextField(placeholder: "Street", TextFieldC: addressLine1)
        addressLine1.delegate = self

    }
    
     func setAddressLine2(){
        view.addSubview(addressLine2)
        
        configConstraintTextField(TextFieldC1: addressLine2, TextFieldC2: addressLine1, top: 10, left: 0, right: 0, height: 30)
        configTextField(placeholder: "Apt(opt)", TextFieldC: addressLine2)
        addressLine2.delegate = self
    }
    
     func setAddressCity(){

        view.addSubview(addressCity)
        
        configConstraintTextField(TextFieldC1: addressCity, TextFieldC2: addressLine2, top: 10, left: 0, right: 0, height: 30)
        configTextField(placeholder: "City", TextFieldC: addressCity)
        addressCity.delegate = self
    }
    
     func setAddressState(){
        view.addSubview(addressState)
        
        configConstraintTextField(TextFieldC1: addressState, TextFieldC2: addressCity, top: 10, left: 0, right: 0, height: 30)
        configTextField(placeholder: "State", TextFieldC: addressState)
        addressState.delegate = self
    }
     func setAddressCountry(){
        view.addSubview(addressCountry)
        
        configConstraintTextField(TextFieldC1: addressCountry, TextFieldC2: addressState, top: 10, left: 0, right: 0, height: 30)
        configTextField(placeholder: "Country", TextFieldC: addressCountry)
        addressCountry.delegate = self
        
    }
     func setAddressZip(){
        
        view.addSubview(addressZip)
        configConstraintTextField(TextFieldC1: addressZip, TextFieldC2: addressCountry, top: 10, left: 0, right: 0, height: 30)
        configTextField(placeholder: "ZIP", TextFieldC: addressZip)
        addressZip.keyboardType = UIKeyboardType.numberPad
        addressZip.delegate = self
        
    }
    
    
    func setTitles(title:String, TextFieldC:EdgeInsetLabel, TextFieldC2:EdgeInsetLabel?,TextFieldC2View: UIView?, TextFieldC2STPPaymentCardText:STPPaymentCardTextField?, isFirstElemen: Bool, top: Int, left: Int, right: Int, height: Int){
        
        let isFirst: Bool = isFirstElemen
        
        if(TextFieldC2 != nil){
            TextFieldC.leftAnchor.constraint(equalTo: (TextFieldC2!.leftAnchor), constant: CGFloat(left)).isActive = true
            TextFieldC.rightAnchor.constraint(equalTo: (TextFieldC2!.rightAnchor), constant: CGFloat(right)).isActive = true
            TextFieldC.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            
            if (isFirst == true) {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2!.topAnchor), constant: CGFloat(top)).isActive = true
            } else {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2!.bottomAnchor), constant: CGFloat(top)).isActive = true
            }
        }
        
        if(TextFieldC2View != nil){
            TextFieldC.leftAnchor.constraint(equalTo: (TextFieldC2View!.leftAnchor), constant: CGFloat(left)).isActive = true
            TextFieldC.rightAnchor.constraint(equalTo: (TextFieldC2View!.rightAnchor), constant: CGFloat(right)).isActive = true
            TextFieldC.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            if (isFirst == true) {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2View!.topAnchor), constant: CGFloat(top)).isActive = true
            } else {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2View!.bottomAnchor), constant: CGFloat(top)).isActive = true
            }
            
        }
        
        if(TextFieldC2STPPaymentCardText != nil){
            TextFieldC.leftAnchor.constraint(equalTo: (TextFieldC2STPPaymentCardText!.leftAnchor), constant: CGFloat(left)).isActive = true
            TextFieldC.rightAnchor.constraint(equalTo: (TextFieldC2STPPaymentCardText!.rightAnchor), constant: CGFloat(right)).isActive = true
            TextFieldC.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
            if (isFirst == true) {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2STPPaymentCardText!.topAnchor), constant: CGFloat(top)).isActive = true
            } else {
                TextFieldC.topAnchor.constraint(equalTo: (TextFieldC2STPPaymentCardText!.bottomAnchor), constant: CGFloat(top)).isActive = true
            }
            
        }
        
        
        TextFieldC.translatesAutoresizingMaskIntoConstraints = false
        TextFieldC.textColor = UIColor.Cya_Title_Text_Color
        TextFieldC.lineBreakMode = .byWordWrapping
        TextFieldC.font = FontCya.CyaTitlesH1
        TextFieldC.textAlignment = .center
        TextFieldC.numberOfLines = 0
        TextFieldC.sizeToFit()
        
        TextFieldC.text = title
        TextFieldC.bottomTextInset = 5
        TextFieldC.rightTextInset = 0
        TextFieldC.leftTextInset = 0
        TextFieldC.topTextInset = 5
        
        
    }
    
    
    func configConstraintTextField(TextFieldC1:UITextField, TextFieldC2:UITextField, top: Int, left: Int, right: Int, height: Int){
        TextFieldC1.translatesAutoresizingMaskIntoConstraints = false
        TextFieldC1.leftAnchor.constraint(equalTo: TextFieldC2.leftAnchor, constant: CGFloat(left)).isActive = true
        TextFieldC1.rightAnchor.constraint(equalTo: TextFieldC2.rightAnchor, constant: CGFloat(right)).isActive = true
        TextFieldC1.topAnchor.constraint(equalTo: TextFieldC2.bottomAnchor, constant: CGFloat(top)).isActive = true
        TextFieldC1.heightAnchor.constraint(equalToConstant: CGFloat(height)).isActive = true
        
        
    }
    
    func configTextField(placeholder: String, TextFieldC:UITextField){
        
        TextFieldC.tintColor = UIColor.cyaMagenta
        TextFieldC.backgroundColor = UIColor.clear
        TextFieldC.layer.borderColor = UIColor.cyaLightGrayBg.cgColor
        TextFieldC.textColor = UIColor.cyaLightGrayBg
        
//        TextFieldC.placeholder = placeholder
        TextFieldC.font = FontCya.CyaCheckout
        
        TextFieldC.borderStyle = .roundedRect
        TextFieldC.layer.masksToBounds = true
        TextFieldC.layer.cornerRadius = 5
        TextFieldC.layer.borderWidth = 1
        TextFieldC.alpha = 0.9
        
        TextFieldC.attributedPlaceholder = NSAttributedString(string:placeholder, attributes: [NSAttributedStringKey.foregroundColor: UIColor.cyaLightGrayBg])
    }
    
    func setTitleEvent(){
        //titleEvent
        view.addSubview(price)
        
        price.leftAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        price.heightAnchor.constraint(equalToConstant: 50).isActive = true
        price.rightAnchor.constraint(equalTo: addressZip.rightAnchor, constant: 0).isActive = true
        price.topAnchor.constraint(equalTo: addressZip.bottomAnchor, constant: 10).isActive = true
        price.translatesAutoresizingMaskIntoConstraints = false
        
        price.text = "$\(_event!.tiers![0].price!) (USD)"
        price.backgroundColor = .lightGray
        price.leftTextInset = 10.0
        price.rightTextInset = 10.0
        
        price.lineBreakMode = .byWordWrapping
        price.font = FontCya.CyaTextField
        price.textAlignment = .center
        price.numberOfLines = 0
        price.sizeToFit()
        price.textAlignment = .right
        
        
    }
    func setPriceTitle(){

        view.addSubview(titleEvent)
        
        titleEvent.rightAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        titleEvent.heightAnchor.constraint(equalToConstant: 50).isActive = true
        titleEvent.leftAnchor.constraint(equalTo: addressZip.leftAnchor, constant: 0).isActive = true
        titleEvent.topAnchor.constraint(equalTo: addressZip.bottomAnchor, constant: 10).isActive = true
        titleEvent.translatesAutoresizingMaskIntoConstraints = false
        
        titleEvent.backgroundColor =  UIColor.lightGray
        titleEvent.text = "Charge:"
        
        titleEvent.leftTextInset = 10.0
        titleEvent.rightTextInset = 10.0
        
        titleEvent.lineBreakMode = .byWordWrapping
        titleEvent.font = FontCya.CyaTextField
        titleEvent.textAlignment = .center
        titleEvent.numberOfLines = 0
        titleEvent.sizeToFit()
        titleEvent.textAlignment = .left
    }
    
    func setSubmitButton(){
        view.addSubview(submitButton)

        submitButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        submitButton.rightAnchor.constraint(equalTo: addressZip.rightAnchor, constant: 20).isActive = true
        submitButton.leftAnchor.constraint(equalTo: addressZip.leftAnchor, constant: -20).isActive = true
        submitButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        submitButton.translatesAutoresizingMaskIntoConstraints = false
  
        submitButton.isEnabled = false
        submitButton.setTitle("Purchase", for: [])
        submitButton.backgroundColor = UIColor.cyaMagenta
        submitButton.setTitleColor(.lightGray, for: .normal)
        submitButton.titleLabel!.font =  UIFont(name: "Avenir-Book" , size: 16)
        submitButton.addTarget(self, action: #selector(self.submitCard(_:)), for: .touchUpInside)
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    func paymentCardTextFieldDidChange(_ textField: STPPaymentCardTextField) {
        
        submitButton.isEnabled = textField.isValid
        
    }

    func cardParam(){
        
        
    }
    

    
    
    @objc func submitCard(_ sender: AnyObject?) {
        // If you have your own form for getting credit card information, you can construct
        // your own STPCardParams from number, month, year, and CVV.
//        let cardParams = paymentTextField.cardParams
        let cardParams = STPCardParams()
        
        cardParams.number   = paymentTextField.cardNumber
        cardParams.expYear  = paymentTextField.expirationYear
        cardParams.expMonth = paymentTextField.expirationMonth
        cardParams.cvc      =   paymentTextField.cvc
        
        cardParams.name                 = fullName.text
        cardParams.address.line1        = addressLine1.text
        cardParams.address.line2        = addressLine2.text
        cardParams.address.city         = addressCity.text
        cardParams.address.state        = addressState.text
        cardParams.address.country      = addressCountry.text
        

        STPAPIClient.shared().createToken(withCard: cardParams) { token, error in
            guard let stripeToken = token else {
                NSLog("Error creating token: %@", error!.localizedDescription);
                return
            }
            
            
            let orderForm : OrderFormDisplayObject = OrderFormDisplayObject()
            self.dataPayByStripe = PayByStripeDisplayObject()
            
            self.dataPayByStripe?.stripeToken    = "\(stripeToken)"
            self.dataPayByStripe?.rawPrice       = self._event?.tiers![0].price
            self.dataPayByStripe?.quantity       = 1
            self.dataPayByStripe?.finalPrice     = self._event?.tiers![0].price
            self.dataPayByStripe?.currency       = "usd"
            self.dataPayByStripe?.userId    = UserDisplayObject.userId
            self.dataPayByStripe?.eventId        = self._event?.id
            orderForm.orderForm = self.dataPayByStripe
             self._purchaseService.payByStripe(payByStripeData: orderForm)
            
            // TODO: send the token to your server so it can create a charge
            let alert = UIAlertController(title: "Si se valido y creo ", message: "Token created: \(self.dataPayByStripe!)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            
           
            
        }
        
        
        
    }

    
    

}






