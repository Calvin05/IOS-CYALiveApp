//
//  BackButton.swift
//  Cya
//
//  Created by Cristopher Torres on 29/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//
//@objc protocol BackButtonViewDelegate: class {
//    @objc func backButtonAction()
//}

import UIKit

class BackButtonView: UIView {
    
    var parent: UIViewController?
    
    var backView: UIView = UIView()
    var backButton: UIButton = UIButton(type: .system) as UIButton
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setParent(parent: UIViewController){
        self.parent = parent
    }
    
    
}

extension BackButtonView{
    
    @objc func backAction(){
        
        self.parent?.dismiss(animated: true, completion: nil)
    }

    
    func setupView(){
        
        self.addSubview(backView)
        backView.addSubview(backButton)
        
        backView.translatesAutoresizingMaskIntoConstraints = false
        backButton.translatesAutoresizingMaskIntoConstraints = false
        
        backView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        backView.heightAnchor.constraint(equalToConstant: CGFloat(30.0)).isActive = true
        backView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
        backView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
        
        backView.backgroundColor = UIColor.cyaBarNavigationBg
        
        
        backButton.topAnchor.constraint(equalTo: backView.topAnchor).isActive = true
        backButton.bottomAnchor.constraint(equalTo: backView.bottomAnchor).isActive = true

        backButton.widthAnchor.constraint(equalToConstant: CGFloat(40.0)).isActive = true

        backButton.centerYAnchor.constraint(equalTo: backView.centerYAnchor, constant: 0).isActive = true

        
        backButton.tintColor = UIColor.magenta
        backButton.titleLabel!.font = FontCya.CyaBack //UIFont(name: "AlNile" , size: 28)
        backButton.setTitleColor(.cyaMagenta, for: .normal)
        backButton.setTitle("  <  ", for: .normal)
        
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
    }
        
}
