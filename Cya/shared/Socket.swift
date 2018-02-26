//
//  Socket.swift
//  Cya
//
//  Created by Cristopher Torres on 06/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import SocketIO

class Socket {
    
    var socket: SocketIOClient
    var socketName: String
    
    init(socketUrlKey: String){
        self.socketName = socketUrlKey
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        let appConfig: NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        let socketURL: String = appConfig.value(forKey: socketUrlKey) as! String
        
        self.socket = SocketIOClient(socketURL: URL(string: socketURL)!, config: [.log(false), .forceWebsockets(true), .connectParams(["query" : "token=\(UserDisplayObject.token)", "upgrade": "false"]), .extraHeaders(["Authorization" : UserDisplayObject.authorization])])
        
    }
    
    func socketConnect(handler: @escaping (SocketIOClient?, String?) -> Void){
        
        socket.on(clientEvent: .connect) {data, ack in
            print("Socket connected \(self.socketName)")
            handler(self.socket, "Error")
        }
        
        socket.on(clientEvent: .disconnect) {data, ack in
            print("Socket disconnected \(self.socketName)")
        }
        
        socket.on("currentAmount") {data, ack in
            if let cur = data[0] as? Double {
                self.socket.emitWithAck("canUpdate", cur).timingOut(after: 0) {data in
                    self.socket.emit("update", ["amount": cur + 2.50])
                }
                
                ack.with("Got your currentAmount", "dude")
            }
        }
        
        socket.connect()
    }
    
    func socketDisconnect(){
        socket.disconnect()
        print("Socket disconnected")
    }

}
