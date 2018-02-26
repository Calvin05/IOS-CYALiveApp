//
//  CastService.swift
//  Cya
//
//  Created by Cristopher Torres on 17/10/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import SocketIO

class CastService {
    
    var socket: SocketIOClient
    
    let sid: String
    let webToken: String
    
    let AUTHENTICATE: String = "authenticate"
    let CAST_REQUEST: String = "sc:stage:request"
    let CAST_DECLINE: String = "sc:stage:decline"
    let CAST_PUBLISH: String = "sc:stage:publish"
    let CAST_LEAVE: String = "sc:stage:leave"
    let INTERVIEW_ANSWER: String = "sc:interview:answer"
    let INTERVIEW_DECLINE: String = "sc:interview:decline"
    let CAST_MOD_LIST: String = "sc:stage:list"
    let CAST_MOD_APPROVE: String = "sc:stage:approve"
    let CAST_MOD_PUSH: String = "sc:stage:push"
    let CAST_MOD_KICK: String = "sc:stage:kick"
    let INTERVIEW_CALL: String = "sc:interview:call"
    let INTERVIEW_TIMEOUT: String = "sc:interview:timeout"
    let CAST_SESSION_JOIN: String = "sc:session:join"
    
    let CAST_ERROR: String = "error"
    let CAST_AUTHENTICATED: String = "authenticated"
    let CAST_SESSION_JOINED: String = "sc:session:joined"
    let CAST_MOD_LISTED: String = "sc:stage:listed"
    let CAST_REQUESTED: String = "sc:stage:requested"
    let CAST_APPROVED: String = "sc:stage:approved"
    let CAST_PUSHED: String = "sc:stage:pushed"
    let CAST_PUBLISHED: String = "sc:stage:published"
    let CAST_SUBSCRIBED: String = "sc:stage:subscribed"
    let CAST_LEFT: String = "sc:stage:left"
    let CAST_DECLINED: String = "sc:stage:declined"
    let CAST_KICKED: String = "sc:stage:kicked"
    let INTERVIEW_CALLED: String = "sc:interview:called"
    let INTERVIEW_DECLINED: String = "sc:interview:declined"
    let INTERVIEW_HANGUP: String = "sc:interview:hungup"
    let INTERVIEW_ANSWERED: String = "sc:interview:answered"
    
    var interviewId: String?
    
    
    init(sid: String, eventId: String, webToken: String){
        self.sid = sid
        self.webToken = webToken
        let socket: Socket = Socket(socketUrlKey: "castUrl")
        self.socket = socket.socket
        socket.socketConnect(handler: {data, ack in
            self.authenticate()
            self.onAuth(handler: { (data, error) in
                print("cast-auth")
            })
            self.onError(handler: { (data, error) in
                print("cast-error")
            })
        })
    }
    
    
    // emit methods
    func authenticate(){
        self.socket.emit(AUTHENTICATE, ["token": webToken])
    }
    
    func disconnect(){
        socket.disconnect()
    }
    
    func stageRequest() {
        self.socket.emit(CAST_REQUEST, ["sid": sid])
    }
    
    func declineStage() {
        self.socket.emit(CAST_DECLINE, ["sid": sid])
    }
    
    func acceptStage() {
        self.socket.emit(CAST_PUBLISH, ["sid": sid])
    }
    
    func leaveStage() {
        self.socket.emit(CAST_LEAVE, ["sid": sid])
    }
    
    func answerInterview() {
        self.socket.emit(INTERVIEW_ANSWER, ["sid": sid, "nid": self.interviewId])
    }
    
    func declineInterview() {
        self.socket.emit(INTERVIEW_DECLINE, ["sid": sid, "nid": self.interviewId])
    }
    
    func getList(params: [Any]) {
        self.socket.emit(CAST_MOD_LIST, params)
    }
    
    func approveUser(userId: String) {
        self.socket.emit(CAST_MOD_APPROVE, ["sid": sid, "uid": userId])
    }
    
    func pushToStage(userId: String) {
        self.socket.emit(CAST_MOD_PUSH, ["sid": sid, "uid": userId])
    }
    
    func kickFromStage(userId: String, list: String) {
        self.socket.emit(CAST_MOD_KICK, ["sid": sid, "uid": userId, "list": list])
    }
    
    func passInterviewee(userId: String, interviewId: Any) {
        self.approveUser(userId: userId)
        self.socket.emit(INTERVIEW_DECLINE, ["sid": sid, "nid": interviewId])
    }
    
    func failInterviewee(userId: String, interviewId: Any) {
        self.socket.emit(INTERVIEW_DECLINE, ["sid": sid, "nid": interviewId])
        self.kickFromStage(userId: userId, list: "requested");
        self.kickFromStage(userId: userId, list: "pushed");
        self.kickFromStage(userId: userId, list: "approved");
    }
    
    func callForInterview(userId: String) {
        self.socket.emit(INTERVIEW_CALL, ["sid": sid, "uid": userId])
    }
    
    func hangupInterview(interviewId: Any) {
        self.socket.emit(INTERVIEW_DECLINE, ["sid": sid, "nid": interviewId])
    }
    
    func timeoutInterview() {
        self.socket.emit(INTERVIEW_TIMEOUT, ["sid": sid, "nid": self.interviewId])
    }
    
    
    
    
    //receive methods
    func onError(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_ERROR) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onAuth(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_AUTHENTICATED) {data, ack in
            self.socket.emit(self.CAST_SESSION_JOIN, ["sid": self.sid])
            handler(data, "Error")
        }
    }
    
    func onSessionJoin(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_SESSION_JOINED) {data, ack in
            //valida si es moderador quiza no va esto aqui
            handler(data, "Error")
        }
    }
    
    func onModList(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_MOD_LISTED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onRequested(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_REQUESTED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onApproved(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_APPROVED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onPushed(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_PUSHED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onPublished(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_PUBLISHED) {data, ack in
            
            //            if (data.room) {
            //                const opts = {
            //                    iceServersiceServers: ICE_SERVERS,
            //                    m: isStar ? 'h' : 'l',
            //                    elementId: 'stream-test',
            //                    shareScreen,
            //                    minVideoBitrate: 65536,
            //                    maxVideoBitrate: 524288,
            //                };
            //
            //                const pub = new SynapCastPub(data.sid, data.uid, {
            //                    host: data.room.host,
            //                    room: data.room.id,
            //                    pin: data.room.pin,
            //                }, opts);
            //                handler(pub);
            //            }
            //
            //            if (data.stream) {
            //                this.socket.emit(CAST_SUBSCRIBE, {
            //                    sid: this.castId,
            //                    stream: data.stream,
            //                });
            //            }
            
            handler(data[0], "Error")
        }
    }
    
    func onSubscribed(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_SUBSCRIBED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onLeft(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_LEFT) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onDeclined(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_DECLINED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onKicked(handler: @escaping (Any?, String?) -> Void){
        socket.on(CAST_KICKED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onInterviewCalled(handler: @escaping (Any?, String?) -> Void){
        socket.on(INTERVIEW_CALLED) {data, ack in
            var dataProperties = data[0] as! [String: String]
            self.interviewId = dataProperties["nid"]
            handler(data, "Error")
        }
    }
    
    func onInterviewDeclined(handler: @escaping (Any?, String?) -> Void){
        socket.on(INTERVIEW_DECLINED) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onInterviewHangup(handler: @escaping (Any?, String?) -> Void){
        socket.on(INTERVIEW_HANGUP) {data, ack in
            handler(data, "Error")
        }
    }
    
    func onInterviewAnswered(handler: @escaping (Any?, String?) -> Void){
        socket.on(INTERVIEW_ANSWERED) {data, ack in
            var dataProperties = data[0] as! [String: Any]
            var room = dataProperties["room"] as! [String: Any]
            
            dataProperties["room"] = room
            handler(dataProperties, "Error")
        }
    }
    
    
    
    
    
    
}
