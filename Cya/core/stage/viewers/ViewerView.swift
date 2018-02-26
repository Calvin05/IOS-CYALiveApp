//
//  ViewerView.swift
//  Cya
//
//  Created by Cristopher Torres on 22/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class ViewerView: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let cellId = "cellId"
    var sigService: SigService?
    var viewerArrayStr: [String] = []
    var viewersCount: Int = 0
    var viewersArray: [User] = []
    let userService: UserService = UserService()
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setSigService(sigService: SigService){
        self.sigService = sigService
        self.loadSocketSigOn()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.register(ViewerCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewersArray.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let viewerCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ViewerCell
        if(self.viewersArray.count > indexPath.item){
            viewerCell.name.text = "\(self.viewersArray[indexPath.item].first_name!) \(self.viewersArray[indexPath.item].last_name!)"
            viewerCell.avatar.downloadedFrom(defaultImage: "profile", link: self.viewersArray[indexPath.item].avatar!)
            
        }else{
            viewerCell.name.text = ""
            viewerCell.avatarUrl = ""
        }
        return viewerCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 200, height: 50)
    }
    
    func loadSocketSigOn(){
        self.onGetViewers()
    }
    
    func reloadCollectionView(){
//        self.collectionView?.reloadData()
    }
    
    func onGetViewers(){
        sigService?.onGetViewers(handler: {data, ack in
            var dataProperties: [String: Any] = [:]
            dataProperties = data![0] as! [String: AnyObject]
            
            self.viewersCount = dataProperties["count"]! as! Int
            let viewerData = dataProperties["viewers"]! as! [String]
            
            if (self.viewerArrayStr.count == 0){
                self.viewerArrayStr = viewerData
                self.setUsers(viewerArray: self.viewerArrayStr){err in
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            }else{
                var i: Int = 0
                for viewerDataItem in viewerData {
                    var exists: Bool = false
                    
                    for viewerItem in self.viewerArrayStr{
                        if (viewerItem == viewerDataItem){
                            i = i + 1
                            exists = true
                            break
                        }
                    }
                    
                    if(!exists){
                        self.viewerArrayStr.append(viewerDataItem)
                        self.setUsers(viewerArray: [viewerDataItem]){err in
                            i = i + 1
                            if(i == viewerData.count){
                                DispatchQueue.main.async {
                                    self.collectionView?.reloadData()
                                }
                            }
                        }
                    }
                }
            }
        })
    }
    
    func setUsers(viewerArray: [String], handler: @escaping (String?) -> Void){
        var i: Int = 0
        for viewerItem in viewerArray{
            
            userService.getUserById2(userId: viewerItem){user, err in
                i = i + 1
                if(user?.user_id != nil){
                    self.viewersArray.append(user!)
                    if(i == viewerArray.count){
                        handler("")
                    }
                    
                }
            }
        }
    }
}

class ViewerCell: UICollectionViewCell{
    
    var avatar: UIImageView = UIImageView()
    var name: EdgeInsetLabel = EdgeInsetLabel()
    var avatarUrl: String = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView(){
        
        contentView.addSubview(avatar)
        contentView.addSubview(name)
        
        avatar.translatesAutoresizingMaskIntoConstraints = false
        
        avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        avatar.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        avatar.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 25
        avatar.translatesAutoresizingMaskIntoConstraints = false
        avatar.image = UIImage(named: "profile")
        
        
        name.translatesAutoresizingMaskIntoConstraints = false
        
        name.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0).isActive = true
        name.leftAnchor.constraint(equalTo: avatar.rightAnchor, constant: 10).isActive = true
        
        name.textColor = UIColor.lightGray
        name.numberOfLines = 0
        name.textAlignment = .left
        name.lineBreakMode = .byWordWrapping
        name.sizeToFit()
        name.font = FontCya.CyaTimeEvent
    }
    
}




