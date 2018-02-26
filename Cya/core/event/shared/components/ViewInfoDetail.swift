//
//  ViewInfoDetail.swift
//  Cya
//
//  Created by Rigo on 16/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class ViewInfoDetail: UIView {
    
    var _wContent: Float!
    private var _description: EdgeInsetLabel = EdgeInsetLabel()
    private var viewInfoEvent: UIView = UIView()
    private var viewInfoEvent1: UIView = UIView()
    private var viewInfoEvent2: UIView = UIView()
    
    
    private var _time: EdgeInsetLabel = EdgeInsetLabel()
    private var _StarTime: EdgeInsetLabel = EdgeInsetLabel()
    private var _Rating: EdgeInsetLabel = EdgeInsetLabel()
    private var _Type: EdgeInsetLabel = EdgeInsetLabel()
    private var _Price: EdgeInsetLabel = EdgeInsetLabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ViewInfoDetail {

    func setupView(){
        self.translatesAutoresizingMaskIntoConstraints = false
        setDescription()
        setViewInfoEvent()
        setViewInfoEvent1()
        setViewInfoEvent2()
        
        
        setTime()
        setStarTime()
        setRating()
        //Type()
        setPrice()
    }
    
    
    func setDescription(){
        self.addSubview(_description)
        
        _description.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        _description.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        _description.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        _description.translatesAutoresizingMaskIntoConstraints = false
        
        _description.font = FontCya.CyaBody
        //        _description.font = UIFont(name: "Montserrat-Light", size: 14)
        _description.textColor = .darkGray
        _description.numberOfLines = 5
        _description.lineBreakMode = .byWordWrapping
        _description.sizeToFit()
        _description.textAlignment = .justified
        _description.leftTextInset = 8
        _description.rightTextInset = 8
    }
    func setViewInfoEvent(){
        self.addSubview(viewInfoEvent)
        
        viewInfoEvent.topAnchor.constraint(equalTo: _description.bottomAnchor, constant: 5).isActive = true
        viewInfoEvent.leftAnchor.constraint(equalTo: _description.leftAnchor, constant: 0).isActive = true
        viewInfoEvent.rightAnchor.constraint(equalTo: _description.rightAnchor, constant: 0).isActive = true
        
        viewInfoEvent.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        viewInfoEvent.widthAnchor.constraint(equalTo: _description.widthAnchor, constant: 0).isActive = true
        
        viewInfoEvent.translatesAutoresizingMaskIntoConstraints = false
        
    }
    func setViewInfoEvent1(){
        viewInfoEvent.addSubview(viewInfoEvent1)
        
        viewInfoEvent1.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        viewInfoEvent1.leftAnchor.constraint(equalTo: viewInfoEvent.leftAnchor, constant: 5).isActive = true
        viewInfoEvent1.topAnchor.constraint(equalTo: viewInfoEvent.topAnchor, constant: 0).isActive = true
        viewInfoEvent1.bottomAnchor.constraint(equalTo: viewInfoEvent.bottomAnchor, constant: 0).isActive = true
        viewInfoEvent1.rightAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        viewInfoEvent1.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    func setViewInfoEvent2(){
        viewInfoEvent.addSubview(viewInfoEvent2)
        
        viewInfoEvent2.heightAnchor.constraint(equalToConstant: 85.0).isActive = true
        viewInfoEvent2.topAnchor.constraint(equalTo: viewInfoEvent.topAnchor, constant: 0).isActive = true
        viewInfoEvent2.bottomAnchor.constraint(equalTo: viewInfoEvent.bottomAnchor, constant: 0).isActive = true
        viewInfoEvent2.rightAnchor.constraint(equalTo: viewInfoEvent.rightAnchor, constant: -5).isActive = true
        viewInfoEvent2.leftAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        viewInfoEvent2.translatesAutoresizingMaskIntoConstraints = false
    }
    
    
    func setTime(){
        viewInfoEvent1.addSubview(_time)
        
        _time.topAnchor.constraint(equalTo: viewInfoEvent1.topAnchor, constant: 2).isActive = true
        _time.leftAnchor.constraint(equalTo: viewInfoEvent1.leftAnchor, constant: 0).isActive = true
        _time.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        _time.translatesAutoresizingMaskIntoConstraints = false
        
        _time.font = FontCya.CyaBody
        _time.textColor = .darkGray
        _time.numberOfLines = 1
        _time.lineBreakMode = .byWordWrapping
        _time.sizeToFit()
        _time.leftTextInset = 5
        _time.rightTextInset = 5
        
    }
    func setStarTime(){
        viewInfoEvent1.addSubview(_StarTime)
        
        _StarTime.topAnchor.constraint(equalTo: _time.bottomAnchor, constant: 3).isActive = true
        _StarTime.leftAnchor.constraint(equalTo: _time.leftAnchor, constant: 0).isActive = true
        _StarTime.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        _StarTime.translatesAutoresizingMaskIntoConstraints = false
        
        _StarTime.text = ""
        _StarTime.font = FontCya.CyaBody
        _StarTime.textColor = .darkGray
        _StarTime.numberOfLines = 1
        _StarTime.lineBreakMode = .byWordWrapping
        _StarTime.sizeToFit()
        
        _StarTime.leftTextInset = 5
        _StarTime.rightTextInset = 5
        
    }
    func setRating(){
        viewInfoEvent2.addSubview(_Rating)
        
        _Rating.topAnchor.constraint(equalTo: viewInfoEvent2.topAnchor, constant: 2).isActive = true
        _Rating.heightAnchor.constraint(equalToConstant: 20.0).isActive = true
        _Rating.leftAnchor.constraint(equalTo: viewInfoEvent2.leftAnchor, constant: 0).isActive = true
        _Rating.translatesAutoresizingMaskIntoConstraints = false
        
        _Rating.text = ""
        _Rating.font = FontCya.CyaBody
        _Rating.textColor = .darkGray
        _Rating.numberOfLines = 1
        _Rating.lineBreakMode = .byWordWrapping
        _Rating.sizeToFit()
        _Rating.leftTextInset = 0
        _Rating.rightTextInset = 5
    }
    
    func setType(){
        viewInfoEvent2.addSubview(_Type)
        
        _Type.topAnchor.constraint(equalTo: _Rating.bottomAnchor, constant: 3).isActive = true
        _Type.leftAnchor.constraint(equalTo: viewInfoEvent2.leftAnchor, constant: 0).isActive = true
        _Type.translatesAutoresizingMaskIntoConstraints = false
        
        _Type.text = "_Type"
        _Type.font = UIFont(name: "Avenir", size: 14)
        _Type.textColor = .darkGray
        _Type.numberOfLines = 1
        _Type.lineBreakMode = .byWordWrapping
        _Type.sizeToFit()
        _Type.leftTextInset = 0
        _Type.rightTextInset = 5
        
    }
    func setPrice(){
        viewInfoEvent2.addSubview(_Price)
        
        _Price.topAnchor.constraint(equalTo: _Rating.bottomAnchor, constant: 3).isActive = true
        _Price.topAnchor.constraint(equalTo: _Rating.bottomAnchor, constant: 3).isActive = true
        _Price.leftAnchor.constraint(equalTo: viewInfoEvent2.leftAnchor, constant: 0).isActive = true
        _Price.translatesAutoresizingMaskIntoConstraints = false
        
        _Price.text = ""
        _Price.font = FontCya.CyaBody
        _Price.textColor = .darkGray
        _Price.numberOfLines = 1
        _Price.lineBreakMode = .byWordWrapping
        _Price.sizeToFit()
        _Price.leftTextInset = 0
        _Price.rightTextInset = 5
    }
     

    
    func attributedText(str1: String, str2: String)-> NSAttributedString
    {
        let string = str1 as NSString
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13.0)])
        let boldFontAttribute = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 13.0)]
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: str2))
        return attributedString
    }
    
    func setCurrenView(data: Event){
        if data.description != nil && data.description != "" {
            _description.attributedText = data.description!.convertHtml()
            _description.font = FontCya.CyaBody
            _description.textColor = .darkGray
        } else {
            let stringInput = "There is no description"
            _description.text = stringInput
        }
        
        
        if data.start_at != nil && data.start_at != "" {
            let timeHrs = NSString.convertFormatOfDate(date: data.start_at!, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "dd MMMM ,yyyy")
            let strText = attributedText(str1: "Date: \(timeHrs!)", str2: "Date")
            _time.attributedText = strText
            
            
            let Hrs = NSString.convertFormatOfDate(date: data.start_at!, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "h:mm a")
            let HrsValue = attributedText(str1: "Star Time: \(Hrs!)", str2: "Star Time")
            _StarTime.attributedText = HrsValue
            
            
        } else {
            let timeHrs = ""
            let strText = attributedText(str1: "Date: \(timeHrs)", str2: "Date")
            _time.attributedText = strText
            
            let Hrs = ""
            let HrsValue = attributedText(str1: "Star Time: \(Hrs)", str2: "Star Time")
            _StarTime.attributedText = HrsValue
        }
        
        
        //        if data.typeMode != nil && data.typeMode != "" {
        //            let text = attributedText(str1: "Type: \(data.typeMode!)", str2: "Type")
        //            _Type.attributedText = text
        //        } else {
        //            let text = attributedText(str1: "Type:", str2: "Type")
        //            _Type.attributedText = text
        //        }
        
        let price: String
        
        if (data.tiers!.count > 0) {
            price = data.tiers![0].price!
        } else{
            price = "$0.00"
        }
        
        let textPrice = attributedText(str1: "Price: $\(price)", str2: "Price")
        _Price.attributedText = textPrice
        
        let textRating = attributedText(str1: "Rating: General Audience", str2: "Rating")
        _Rating.attributedText = textRating
        
        
        
    }

    
}
