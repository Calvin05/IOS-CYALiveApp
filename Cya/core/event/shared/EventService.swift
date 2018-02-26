//
//  EventService.swift
//  Cya
//
//  Created by Cristopher Torres on 9/27/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class EventService{
    
    let appConfig: NSMutableDictionary
    let eventApiUrl: String
    let purchaseUrl: String
    
    init(){
        
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        appConfig = NSMutableDictionary(contentsOfFile: path!)!
        eventApiUrl = appConfig.value(forKey: "eventApiUrl") as! String
        purchaseUrl = appConfig.value(forKey: "purchaseUrl") as! String
        
        
    }
    
    func getEventContents(eventId: String) -> EventContentDisplayObject{
        
        let url = "\(eventApiUrl)/\(eventId)/play"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var eventContentDisplayObject: EventContentDisplayObject = EventContentDisplayObject()

        let semaphore = DispatchSemaphore(value: 0)

        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                eventContentDisplayObject = try JSONDecoder().decode(EventContentDisplayObject.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()

        semaphore.wait(timeout: .distantFuture)
        
        return eventContentDisplayObject
    }
    
    func getEvent(eventId: String) -> Event{
        
        let url = "\(eventApiUrl)/\(eventId)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var event: Event = Event()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                event = try JSONDecoder().decode(Event.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return event
    }
    
    func getEventContents2(eventId: String, handler: @escaping (EventContentDisplayObject?, NSError?) -> Void){
        
        let url = "\(eventApiUrl)/\(eventId)/play"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var eventContentDisplayObject: EventContentDisplayObject = EventContentDisplayObject()
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                try ErrorHelper.validateRequestError(data: data!, res: res!)
                eventContentDisplayObject = try JSONDecoder().decode(EventContentDisplayObject.self, from: data!)
                handler(eventContentDisplayObject, nil)
            } catch let err{
                handler(nil, err as NSError)
            }
        }
        tarea.resume()
    }
    
    func getEvent2(eventId: String, handler: @escaping (Event?, NSError?) -> Void){
        
        let url = "\(eventApiUrl)/\(eventId)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var event: Event = Event()
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                try ErrorHelper.validateRequestError(data: data!, res: res!)
                event = try JSONDecoder().decode(Event.self, from: data!)
                handler(event, nil)
            } catch let err{
                handler(nil, err as NSError)
            }
        }
        tarea.resume()
    }
    
    
    
    func getEventList(offset: Int, limit: Int, state: Int) -> EventListDisplayObject{
        
        let url = "\(eventApiUrl)?offset=\(offset)&limit=\(limit)&state=\(state)"
        var request = URLRequest(url: URL(string: url)!)
        request.httpMethod = "GET"
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        var eventListDisplayObject: EventListDisplayObject = EventListDisplayObject()
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                eventListDisplayObject = try JSONDecoder().decode(EventListDisplayObject.self, from: data!)
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        return eventListDisplayObject
    }
    
    
}

