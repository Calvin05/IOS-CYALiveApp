//
//  ChatService.swift
//  Cya
//
//  Created by Cristopher Torres on 27/09/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import SocketIO

class ChatService{
    
    var socket: SocketIOClient
    
    // emit messages
    let JOIN_EVENT: String = "ch:room:join"
    let LEAVE_EVENT: String = "leave_event"
    let FETCH_HISTORY: String = "ch:room:historyBefore"
    let SEND_MESSAGE: String = "ch:msg:send"
    let DELETE_MESSAGE: String = "ch:msg:delete"
    let MARK_QUESTION: String = "ch:msg:markQuestion"
    let REMOVE_QUESTION: String = "ch:msg:revokeQuestion"
    let UNBLOCK_USER: String = "ch:user:unblock"
    let BLOCK_USER: String = "ch:user:block"
    // receive messages
    let NEW_MESSAGE:String = "ch:msg:newMsg"
    let BLOCK_LIST: String = "ch:user:blockedList"
    let CHAT_HISTORY: String = "ch:msg:chatHistory"
    let MESSAGE_DELETED: String = "ch:msg:deleted"
    let QUESTION_HISTORY: String = "ch:msg:questionHistory"
    let NEW_QUESTION_MARKED: String = "ch:msg:questionMarked"
    let NEW_QUESTION: String = "ch:msg:newQuestion"
    let QUESTION_REMOVED: String = "ch:msg:questionRevoked"
    let USER_BLOCKED: String = "ch:user:blocked"
    let USER_UNBLOCKED: String = "ch:user:unblocked"
    
    let chatHelper: ChatHelper = ChatHelper()
    var chatId: String = ""
    
    init(sessionId: String){
        self.chatId = sessionId
        let socket: Socket = Socket(socketUrlKey: "chatUrl")
        self.socket = socket.socket
        socket.socketConnect(handler: {data, ack in
            self.joinEvent()
        })
        
    }
    
    //emit methods
    func joinEvent() {
        socket.emit(JOIN_EVENT, ["limit": 50, "chatId": chatId])
    }
    
//    func leaveEvent(){
//        socket.emit(LEAVE_EVENT, ["limit": 50, "chatId": chatId])
//    }
    
    func fetchHistory(msgId: String) {
        socket.emit(FETCH_HISTORY, ["chatId": chatId, "limit": 50, "msgId": msgId])
    }
    
    func sendMessage(msg: String) {
        socket.emit(SEND_MESSAGE, ["chatId": chatId, "limit": 50, "msg": msg, "profile": ["avatar": UserDisplayObject.avatar, "first_name": UserDisplayObject.first_name, "last_name": UserDisplayObject.last_name, "user_id": UserDisplayObject.userId, "username": UserDisplayObject.username]])
    }
    
    func sendQuestion(msg: String) {
        socket.emit(SEND_MESSAGE, ["chatId": chatId, "limit": 50, "msg": "q:\(msg)"])
    }
    
    func deleteMessage(msgId: String) {
        socket.emit(DELETE_MESSAGE, ["chatId": chatId, "limit": 50, "msgId": msgId])
    }
    
    func markAsQuestion(msgId: String) {
        socket.emit(MARK_QUESTION, ["chatId": chatId, "limit": 50, "msgId": msgId])
    }
    
//    func removeQuestion(msgId: String) {
//        socket.emit(REMOVE_QUESTION, ["chatId": chatId, "limit": 50, "msgId": msgId])
//    }
    
    func blockUser(userId: String) {
        socket.emit(BLOCK_USER, ["chatId": chatId, "limit": 50, "blockUserId": userId])
    }
    
    func unblockUser(userId: String) {
        socket.emit(UNBLOCK_USER, ["chatId": chatId, "limit": 50, "blockUserId": userId])
    }
    
    
    
    //receive methods
    func onNewMessage(handler: @escaping (ChatMessageDisplayObject?, String?) -> Void){
        socket.on(NEW_MESSAGE) {data, ack in
            let data: ChatMessageDisplayObject = self.chatHelper.transformDataMessage(data: data)!
            handler(data, "Error")
        }
    }
    
    //probar
    func onBlockList(handler: @escaping (Any?, String?) -> Void){
        socket.on(BLOCK_LIST) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onChatHistory(handler: @escaping ([ChatMessageDisplayObject]?, String?) -> Void){
        socket.on(CHAT_HISTORY) {data, ack in
            
            self.chatHelper.transformDataMessageArray(data: data){dataTransform, err in
                handler(dataTransform as! [ChatMessageDisplayObject], "Error")
            }
        }
    }
    
    func onDeleteMesssage(handler: @escaping (String?, String?) -> Void){
        socket.on(MESSAGE_DELETED) {data, ack in
            handler(data[0] as? String, "Error")
        }
    }
    
    func onQuestionHistory(handler: @escaping ([QuestionDisplayObject]?, String?) -> Void){
        socket.on(QUESTION_HISTORY) {data, ack in
            let data: [QuestionDisplayObject] = self.chatHelper.transformDataQuestionArray(data: data)!
            handler(data, "Error")
        }
    }
    
    // ver donde se ejecuta
    func onNewMarkedQuestion(handler: @escaping (Any?, String?) -> Void){
        socket.on(NEW_QUESTION_MARKED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onNewQuestion(handler: @escaping (QuestionDisplayObject?, String?) -> Void){
        socket.on(NEW_QUESTION) {data, ack in
            let data: QuestionDisplayObject = self.chatHelper.transformDataQuestion(data: data)!
            handler(data, "Error")
        }
    }
    
    func onDeleteQuestion(handler: @escaping (Any?, String?) -> Void){
        socket.on(QUESTION_REMOVED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onUserBlocked(handler: @escaping (String?, String?) -> Void){
        socket.on(USER_BLOCKED) {data, ack in
            handler(data[0] as? String, "Error")
        }
    }
    
    func onUserUnblocked(handler: @escaping (Any?, String?) -> Void){
        socket.on(USER_UNBLOCKED) {data, ack in
            handler(data, "Error")
        }
    }
    
}
