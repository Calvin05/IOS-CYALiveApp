//
//  EventHelper.swift
//  Cya
//
//  Created by Cristopher Torres on 03/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class EventHelper {
    
    let webRtcUrl: String
    var eventService: EventService?
    
    init(){
        
        let appConfig: NSMutableDictionary
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        webRtcUrl = appConfig.value(forKey: "webRtcUrl") as! String
        
    }
    
    func getUrlMainStage(eventId: String, userId: String, handler: @escaping (URL?, NSError?) -> Void){
        
        eventService = EventService()
        
        self.eventService?.getEventContents2(eventId: eventId){data, err in

            if(err != nil){
                handler(nil, err)
            }else{
                let eventContentDisplayObject: EventContentDisplayObject
                eventContentDisplayObject = data!
                
                let url: URL
                
                var sessionId: String = ""
                for eventServiceDisplayObjectItem in eventContentDisplayObject.services! {
                    if eventServiceDisplayObjectItem.name == "cast"{
                        sessionId = eventServiceDisplayObjectItem.session_id!
                    }
                }
                
                let urlStr: String = "\(self.webRtcUrl)/mobile/stage/?eid=\(eventId)&token=\(eventContentDisplayObject.token!)&uid=\(userId)&sid=\(sessionId)"
                url = URL(string: urlStr)!
                
                handler(url, nil)
            }
            
        }
    }

}
