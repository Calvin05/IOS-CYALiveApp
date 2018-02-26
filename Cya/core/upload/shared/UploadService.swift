//
//  UploadService.swift
//  Cya
//
//  Created by Cristopher Torres on 14/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit


class UploadService{
    
    let uploadApiUrl: String
    
    init(){
        let path:String? = Bundle.main.path(forResource: "AppConfig", ofType: "plist")!
        let appConfig = NSMutableDictionary(contentsOfFile: path!)!
        uploadApiUrl = appConfig.value(forKey: "uploadApiUrl") as! String
    }
    
    func uploadAvatar(image: UIImage) -> AnyObject{
        
        let mediaImage = Media(withImage: image, forKey: "avatar")
        
        let url = "\(uploadApiUrl)/avatar"
        var request = URLRequest(url: URL(string: url)!)
        
        request.httpMethod = "POST"
        
        let boundary = generateBoundary()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(UserDisplayObject.authorization, forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: nil, media: [mediaImage!], boundary: boundary)
        request.httpBody = dataBody
        
        var avatarUrl: String = ""
        var errorResponse: ErrorResponseDisplayObject = ErrorResponseDisplayObject()
        var resStatusCode = 200
        
        let semaphore = DispatchSemaphore(value: 0)
        
        let tarea = URLSession.shared.dataTask(with: request){ (data, res, err) in
            do{
                resStatusCode = ((res as? HTTPURLResponse)?.statusCode)!
                if(resStatusCode != 200){
                    errorResponse = try JSONDecoder().decode(ErrorResponseDisplayObject.self, from: data!)
                }else{
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                    avatarUrl = json["URL"] as! String
                }
                semaphore.signal()
            } catch let err{
                print(err)
                semaphore.signal()
            }
        }
        tarea.resume()
        
        semaphore.wait(timeout: .distantFuture)
        
        if(resStatusCode != 200){
            return errorResponse
        }else{
            return avatarUrl as AnyObject
        }
    }
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

typealias Parameters = [String: String]

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "avatar.jpg"
        
        guard let data = UIImageJPEGRepresentation(image, 0.7) else { return nil }
        self.data = data
    }
    
}


