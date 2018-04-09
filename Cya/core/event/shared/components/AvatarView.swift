//
//  ViewAvatarCollection.swift
//  Cya
//
//  Created by Rigo on 05/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class AvatarView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellAvatar = "cellAvatar"
    var avatarArray: [Role] = []
    var leftInset: CGFloat = 0.0
    var rightInset: CGFloat = 0.0
    var count = 3
    var layout: UICollectionViewFlowLayout?
    
    init(collectionViewLayout layout: UICollectionViewLayout, avatarArray: [Role]) {
        super.init(collectionViewLayout: layout)
        self.avatarArray = avatarArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settingCollectionView()
    }
    
}

extension AvatarView {
    
    func settingCollectionView(){
        layout = self.collectionView?.collectionViewLayout as! UICollectionViewFlowLayout
        layout?.scrollDirection = UICollectionViewScrollDirection.horizontal
        
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceVertical = false
        collectionView?.register(AvatarCell.self, forCellWithReuseIdentifier: self.cellAvatar)
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.avatarArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let avatarCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellAvatar, for: indexPath) as! AvatarCell
        
        if(self.avatarArray.count > indexPath.item){
            
            if let avatar = self.avatarArray[indexPath.item].avatar {
                avatarCell.avatar.downloadedFrom(defaultImage: "profile", link: avatar, contentMode: .scaleAspectFill)
            }else{
                avatarCell.avatar.downloadedFrom(defaultImage: "profile", link: "", contentMode: .scaleAspectFill)
            }
            
            if let firstName = self.avatarArray[indexPath.item].first_name {
                avatarCell.firstName.text = firstName
            }
            
            if let lastName = self.avatarArray[indexPath.item].last_name {
                avatarCell.lastName.text = lastName
            }
            
        }
        return avatarCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let avatarHeight = CGFloat(160)
        let avatarWidth = (self.view.frame.size.width / 4)
        
        return CGSize.init(width: avatarWidth, height: avatarHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


