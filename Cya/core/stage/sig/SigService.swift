//
//  SigService.swift
//  Cya
//
//  Created by Cristopher Torres on 22/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import SocketIO

class SigService {
    
    var socket: SocketIOClient
    var eventId: String
    
    let SIG_JOIN: String = "sig:event:join"
    let SIG_GET_VIEWERS: String = "sig:event:getViewers"
    let SIG_EVENT_READY: String = "sig:event:wait"
    let SIG_ENTER_EVENT_PAGE: String = "sig:event:in"
    let SIG_RECEIVE_VIEWERS: String = "sig:event:viewers"
    
    init(eventId: String){
        self.eventId = eventId
        let socket: Socket = Socket(socketUrlKey: "sigApiUrl")
        self.socket = socket.socket
        
        socket.socketConnect(handler: {data, ack in
            self.joinEvent()
        })
    }
    
    func joinEvent(){
        self.socket.emit(SIG_JOIN, ["eventId": eventId,])
    }
    
    func getViewers(){
        self.socket.emit(SIG_GET_VIEWERS, ["eventId": eventId])
    }
    
    func onEventStatus(handler: @escaping (Bool?, String?) -> Void){
        socket.on(SIG_EVENT_READY) {data, ack in
            handler(true, "Error")
        }
        socket.on(SIG_ENTER_EVENT_PAGE) {data, ack in
            handler(false, "Error")
        }
    }
    
    func onGetViewers(handler: @escaping ([Any]?, String?) -> Void){
        self.socket.on(SIG_RECEIVE_VIEWERS) {data, ack in
            handler(data, "Error")
        }
    }
}
