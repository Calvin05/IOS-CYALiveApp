//
//  StageService.swift
//  Cya
//
//  Created by Cristopher Torres on 9/27/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class StageService {
    
    let appConfig: NSMutableDictionary
    let eventApiUrl: String
    
    init(){
        
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        eventApiUrl = appConfig.value(forKey: "eventApiUrl") as! String
        
        
        
    }
    
    func createStagePage(){
        
    }
}
