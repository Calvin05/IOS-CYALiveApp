//
//  ExtensionConvertHtml.swift
//  Cya
//
//  Created by Rigo on 04/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit

extension String{
    
    func attributedText(text: String, color: UIColor, ofSize: Int, nameFont: String) -> NSAttributedString{

        let string = text  as NSString
        var result = NSMutableAttributedString(string: string as String)
        result = NSMutableAttributedString(string: string as String, attributes: [NSAttributedStringKey.font:UIFont(name: nameFont, size: CGFloat(Float(ofSize)))!])
        result.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range:string.range(of: text))
        
        return NSAttributedString(attributedString: result)
        
        
    }
    
    func convertHtml() -> NSAttributedString{
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do{
                return  try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
        }catch{
            return NSAttributedString()
        }
    }
}
