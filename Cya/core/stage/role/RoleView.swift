//
//  RoleView.swift
//  Cya
//
//  Created by Cristopher Torres on 05/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class RoleView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var roleArray: [Role] = []
    
    var layout: UICollectionViewFlowLayout?
    
    init(collectionViewLayout layout: UICollectionViewLayout, roleArray: [Role]) {
        super.init(collectionViewLayout: layout)
        self.roleArray = roleArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = true
        self.collectionView?.isPagingEnabled = true
        
        layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        
        layout?.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.register(RoleCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        collectionView?.alwaysBounceVertical = false
        collectionView?.alwaysBounceHorizontal = true
        self.collectionView?.isPagingEnabled = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.roleArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let roleCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! RoleCell
        if(self.roleArray.count > indexPath.item){
            roleCell.name.text = "\(self.roleArray[indexPath.item].first_name!) \(self.roleArray[indexPath.item].last_name!)"
            roleCell.avatar.downloadedFrom(defaultImage: "profile", link: self.roleArray[indexPath.item].avatar!, contentMode: .scaleAspectFill)

        }else{
            roleCell.name.text = ""
        }
        return roleCell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avatarHeight = (self.view.frame.size.width / 2 * 0.75)
        let avatarWidth = (self.view.frame.size.width / 2)
        
        return CGSize.init(width: avatarWidth, height: avatarHeight)
    }
    
}

class RoleCell: UICollectionViewCell{
    
    var avatar: UIImageView = UIImageView()
    var name: EdgeInsetLabel = EdgeInsetLabel()
    var gradientLayer: CAGradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        
        contentView.addSubview(avatar)
        contentView.layer.addSublayer(gradientLayer)
        contentView.addSubview(name)
        
        print(contentView.frame.size.width)
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2).isActive = true
        avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 2).isActive = true
        avatar.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -2).isActive = true
        avatar.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2).isActive = true
        
        avatar.layer.masksToBounds = true
        avatar.image = UIImage(named: "profile")
        avatar.contentMode = .scaleAspectFill
        
        
        
        gradientLayer.frame = contentView.bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7, 1.0]
        
        
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.leftAnchor.constraint(equalTo: avatar.leftAnchor, constant: 0).isActive = true
        name.rightAnchor.constraint(equalTo: avatar.rightAnchor, constant: 0).isActive = true
        name.bottomAnchor.constraint(equalTo: avatar.bottomAnchor, constant: -10).isActive = true
        
        name.textColor = UIColor.white
        name.numberOfLines = 0
        name.textAlignment = .center
        name.lineBreakMode = .byWordWrapping
        name.sizeToFit()
        name.font = FontCya.CyaTitlesH5
    }
}
