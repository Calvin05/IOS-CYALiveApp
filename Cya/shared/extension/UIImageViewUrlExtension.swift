//
//  UIImageViewUrlExtension.swift
//  Cya
//
//  Created by josvan salvarado on 10/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
    
    func downloadedFrom(defaultImage: String, url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            let httpURLResponse = response as? HTTPURLResponse
            let mimeType = response?.mimeType
            var image: UIImage?
            if(httpURLResponse?.statusCode == 200 && error == nil && (mimeType?.hasPrefix("image"))!){
                image = UIImage(data: data!)
            }else{
                image = UIImage(named: defaultImage)
            }
            
            DispatchQueue.main.async() {
                self.image = image!
            }
        }.resume()
    }
    func downloadedFrom(defaultImage: String, link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(defaultImage: defaultImage, url: url, contentMode: mode)
    }
}
