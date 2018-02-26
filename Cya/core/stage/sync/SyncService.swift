//
//  SyncService.swift
//  Cya
//
//  Created by Cristopher Torres on 04/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import SocketIO

class SyncService {
    
    var socket: SocketIOClient
    
    let SYNC_JOIN: String = "sn:room:join"
    let SYNC_ON_SYNC: String = "sn:room:sync"
    let ON_STATE_UPDATE: String = "sn:state:update"
    let SYNC_ON_JOIN: String = "sn:room:join"
    let sessionId: String

    init(sessionId: String){
        self.sessionId = sessionId
        let socket: Socket = Socket(socketUrlKey: "syncApiUrl")
        self.socket = socket.socket
        socket.socketConnect(handler: {data, ack in
            self.joinRoom()
        })
        
    }
    
    //emit methods
    func joinRoom() {
        self.socket.emit(self.SYNC_JOIN, ["roomId": sessionId])
    }
    
    func onSync(handler: @escaping ([Any]?, String?) -> Void){
        self.socket.on(SYNC_ON_SYNC) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onStateUpdate(handler: @escaping ([Any]?, String?) -> Void){
        self.socket.on(ON_STATE_UPDATE) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onJoinRoom(handler: @escaping ([Any]?, String?) -> Void){
        self.socket.on(SYNC_ON_JOIN) {data, ack in
            handler(data, "Error")
        }
    }
}
