//
//  ChatHelper.swift
//  Cya
//
//  Created by Cristopher Torres on 28/09/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation

class ChatHelper {
    
    func getUser(userId: String)-> User{
        let userService: UserService = UserService()
        let user: User = userService.getUserById(userId: userId)
        return user
    }
    
    func getUser2(userId: String, handler: @escaping (User?, String?) -> Void){
        let userService: UserService = UserService()
        
        userService.getUserById2(userId: userId){ data, err in
            handler(data, err)
        }
    }

    func transformDataMessage(data: [Any]) -> ChatMessageDisplayObject?{

        
        var dataProperties = data[0] as! [String: Any]
        let chatMessageDisplayObject: ChatMessageDisplayObject = ChatMessageDisplayObject()
        let profile = dataProperties["profile"] as! [String: Any]
        chatMessageDisplayObject.chat_id = dataProperties["chat_id"] as? String
        chatMessageDisplayObject.content = dataProperties["content"] as? String
        chatMessageDisplayObject.id = dataProperties["id"] as? String
        chatMessageDisplayObject.user_id = dataProperties["user_id"] as? String
        chatMessageDisplayObject.created_time = dataProperties["created_time"] as? String
        
        
        chatMessageDisplayObject.profile = ChatProfileDisplayObject()
        chatMessageDisplayObject.profile?.avatar = profile["avatar"] as? String
        chatMessageDisplayObject.profile?.username = profile["username"] as? String
        
//        if(UserDisplayObject.userId == dataProperties["user_id"] as! String){
//            chatMessageDisplayObject.avatar = UserDisplayObject.avatar
//            chatMessageDisplayObject.username = UserDisplayObject.username
//        }else {
//            let user: User = getUser(userId: dataProperties["user_id"]! as! String)
//            chatMessageDisplayObject.avatar = user.avatar
//            chatMessageDisplayObject.username = user.username
//        }
        
        return chatMessageDisplayObject
    }
    
    func transformDataMessageArray(data: [Any], handler: @escaping ([ChatMessageDisplayObject]?, String?) -> Void) {
        
        var chatMessageDisplayObjectList: [ChatMessageDisplayObject] = []
        var chatProfileDisplayObjectList: [ChatProfileDisplayObject] = []
        var dataProperties = data[0] as! [String: Any]
        
        do{
            let dataMessageJSON = try JSONSerialization.data(withJSONObject: dataProperties["messages"]!)
            chatMessageDisplayObjectList = try JSONDecoder().decode([ChatMessageDisplayObject].self, from: dataMessageJSON)
            
            let chatProfiles = dataProperties["profiles"] as! NSArray

            for chatMessageDisplayObject in chatMessageDisplayObjectList{

                for chatProfile in chatProfiles{
                    print(chatProfile)
                    let chatProfileDictionary = chatProfile as! [String: Any]
                    var user_id: String
                    
                    if let user_id_dictionary = chatProfileDictionary["user_id"] as? String{
                        user_id = chatProfileDictionary["user_id"] as! String
                    }else{
                        user_id = String(describing: chatProfileDictionary["user_id"]!)
                    }
                    
                    if(chatMessageDisplayObject.user_id == user_id){
                        chatMessageDisplayObject.profile = ChatProfileDisplayObject()
                        chatMessageDisplayObject.profile?.avatar = chatProfileDictionary["avatar"] as? String
                        chatMessageDisplayObject.profile?.username = chatProfileDictionary["username"] as? String
                        break
                    }
                }
            }
            
            handler(chatMessageDisplayObjectList, nil)
            
        } catch let err{
            chatMessageDisplayObjectList = []
            handler(chatMessageDisplayObjectList, nil)
        }
        
    }
    
    func transformDataQuestion(data: [Any]) -> QuestionDisplayObject?{
        
        var dataProperties = data[0] as! [String: String]
        let questionDisplayObject: QuestionDisplayObject = QuestionDisplayObject()
        
        // Pendiente no hay questions en IOS
//        questionDisplayObject.chat_id = dataProperties["chat_id"]
//        questionDisplayObject.content = dataProperties["content"]
//        questionDisplayObject.id = dataProperties["id"]
//        questionDisplayObject.user_id = dataProperties["user_id"]
//        questionDisplayObject.marked_time = dataProperties["marked_time"]
//
//        if(UserDisplayObject.userId == dataProperties["user_id"]){
//            questionDisplayObject.avatar = UserDisplayObject.avatar
//            questionDisplayObject.username = UserDisplayObject.username
//        }else {
//            let user: User = getUser(userId: dataProperties["user_id"]!)
//            questionDisplayObject.avatar = user.avatar
//            questionDisplayObject.username = user.username
//        }
        
        return questionDisplayObject
    }
    
    func transformDataQuestionArray(data: [Any]) -> [QuestionDisplayObject]?{
        
        var questionDisplayObjectList: [QuestionDisplayObject] = []
        //Pendiente no hay questions en IOS
//        let dataStr = data[0] as! String
//        let data = dataStr.data(using: .utf8)
//        var userIds: [String: AnyObject] = [:]
//
//        do{
//            questionDisplayObjectList = try JSONDecoder().decode([QuestionDisplayObject].self, from: data!)
//        } catch let err{
//            print(err)
//        }
//
//        for questionDisplayObject in questionDisplayObjectList {
//
//            let userId: String = questionDisplayObject.user_id!
//
//            if(userId == UserDisplayObject.userId){
//                questionDisplayObject.avatar = UserDisplayObject.avatar
//                questionDisplayObject.username = UserDisplayObject.username
//            }else{
//                if(userIds[userId] == nil){
//                    let user: User = self.getUser(userId: userId)
//                    questionDisplayObject.avatar = user.avatar
//                    questionDisplayObject.username = user.username
//                    userIds[userId] = user
//                }else{
//                    let user: User = userIds[userId] as! User
//                    questionDisplayObject.avatar = user.avatar
//                    questionDisplayObject.username = user.username
//                }
//            }
//        }
        
        return questionDisplayObjectList
    }
}
