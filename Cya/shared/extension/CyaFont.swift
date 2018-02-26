//
//  CyaFont.swift
//  Cya
//
//  Created by Rigo on 05/12/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import Foundation
import UIKit



struct Font {
    
    
    enum FontType {
        case installed(FontName)
        case custom(String)
        case system
        case systemBold
        case systemItatic
        case systemWeighted(weight: Double)
        case monoSpacedDigit(size: Double, weight: Double)
    }
    enum FontSize {
        case standard(StandardSize)
        case custom(Double)
        var value: Double {
            switch self {
            case .standard(let size):
                return size.rawValue
            case .custom(let customSize):
                return customSize
            }
        }
    }
    enum FontName: String {
        case MontserratBlackItalic              = "Montserrat-BlackItalic"
        case MontserratBold                     = "Montserrat-Bold"
        case MontserratBoldItalic               = "Montserrat-BoldItalic"
        case MontserratExtraBold                = "Montserrat-ExtraBold"
        case MontserratExtraBoldItalic          = "Montserrat-ExtraBoldItalic"
        case MontserratExtraLight               = "Montserrat-ExtraLight"
        case MontserratExtraLightItalic         = "Montserrat-ExtraLightItalic"
        case MontserratItalic                   = "Montserrat-Italic"
        case MontserratLight                    = "Montserrat-Light"
        case MontserratMedium                   = "Montserrat-Medium"
        case MontserratMediumItalic             = "Montserrat-MediumItalic"
        case MontserratRegular                  = "Montserrat-Regular"
        case MontserratSemiBold                 = "Montserrat-SemiBold"
        case MontserratSemiBoldItalic           = "Montserrat-SemiBoldItalic"
        case MontserratThin                     = "Montserrat-Thin"
        case MontserratThinItalic               = "Montserrat-ThinItalic"

    }
    enum StandardSize: Double {
        case XXL = 36.0
        case h1XL = 30.0
        case back = 26.0
        case h1 = 20.0
        case h2 = 18.0
        case h3 = 16.0
        case h4 = 14.0
        case h5 = 12.0
        case h6 = 10.0
        case body = 13.0
        case inputText = 17.0
        case error = 15.0
        case iconSM = 11.0
    }
    
    
    var type: FontType
    var size: FontSize
    init(_ type: FontType, size: FontSize) {
        self.type = type
        self.size = size
    }
}

extension Font {
    
    var instance: UIFont {
        
        var instanceFont: UIFont!
        switch type {
        case .custom(let fontName):
            guard let font =  UIFont(name: fontName, size: CGFloat(size.value)) else {
                fatalError("\(fontName) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .installed(let fontName):
            guard let font =  UIFont(name: fontName.rawValue, size: CGFloat(size.value)) else {
                fatalError("\(fontName.rawValue) font is not installed, make sure it added in Info.plist and logged with Utility.logAllAvailableFonts()")
            }
            instanceFont = font
        case .system:
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value))
        case .systemBold:
            instanceFont = UIFont.boldSystemFont(ofSize: CGFloat(size.value))
        case .systemItatic:
            instanceFont = UIFont.italicSystemFont(ofSize: CGFloat(size.value))
        case .systemWeighted(let weight):
            instanceFont = UIFont.systemFont(ofSize: CGFloat(size.value),
                                             weight: UIFont.Weight(rawValue: CGFloat(weight)))
        case .monoSpacedDigit(let size, let weight):
            instanceFont = UIFont.monospacedDigitSystemFont(ofSize: CGFloat(size),
                                                            weight: UIFont.Weight(rawValue: CGFloat(weight)))
        }
        return instanceFont
    }
}

class Utility {
    /// Logs all available fonts from iOS SDK and installed custom font
    class func logAllAvailableFonts() {
        for family in UIFont.familyNames {
            print("\(family)")
            for name in UIFont.fontNames(forFamilyName: family) {
                print("   \(name)")
            }
        }
    }
    
}

class FontCya  {
    
    /*
     //Ejemplo para crear nueva fuente
     let system12            = Font(.system, size: .standard(.h5)).instance
     let montserratLight20   = Font(.installed(.MontserratLight), size: .standard(.h1)).instance
     let MontserratBold14    = Font(.installed(.MontserratBold), size: .standard(.h4)).instance
     let helveticaLight13    = Font(.custom("Helvetica-Light"), size: .custom(13.0)).instance
     let CyaTitles           = Font(.installed(.MontserratRegular), size: .standard(.h1)).instance

     */
    
    static let CyaTextButtonRegXL    = Font(.installed(.MontserratRegular), size: .standard(.h1XL)).instance// 30
    static let CyaTitlesH1           = Font(.installed(.MontserratRegular), size: .standard(.h1)).instance // 20
    static let CyaTitlesH2           = Font(.installed(.MontserratRegular), size: .standard(.h2)).instance // 18
    static let CyaTitlesH3           = Font(.installed(.MontserratRegular), size: .standard(.h3)).instance // 16
    static let CyaTitlesH4           = Font(.installed(.MontserratRegular), size: .standard(.h4)).instance // 14
    static let CyaTitlesH5           = Font(.installed(.MontserratRegular), size: .standard(.h5)).instance // 12
    static let CyaTitlesH6           = Font(.installed(.MontserratRegular), size: .standard(.h6)).instance // 10
    
    static let CyaTitlesH1Light      = Font(.installed(.MontserratLight), size: .standard(.h1)).instance // 20
    static let CyaTitlesH2Light      = Font(.installed(.MontserratLight), size: .standard(.h2)).instance // 18
    static let CyaTitlesH3Light      = Font(.installed(.MontserratLight), size: .standard(.h3)).instance // 16
    static let CyaTitlesH4Light      = Font(.installed(.MontserratLight), size: .standard(.h4)).instance // 14
    static let CyaTitlesH5Light      = Font(.installed(.MontserratLight), size: .standard(.h5)).instance // 12
    static let CyaTitlesH6Light      = Font(.installed(.MontserratLight), size: .standard(.h5)).instance // 10
    
    static let CyaBody               = Font(.installed(.MontserratLight), size: .standard(.body)).instance      // 13
    static let CyaInput              = Font(.installed(.MontserratLight), size: .standard(.inputText)).instance // 17
    static let CyaTextChat           = Font(.installed(.MontserratLight), size: .standard(.body)).instance      // 13
    static let CyaTextButton         = Font(.installed(.MontserratRegular), size: .standard(.h3)).instance      // 16
    static let CyaTextNameAvatar     = Font(.installed(.MontserratRegular), size: .standard(.h6)).instance        // 10
    static let CyaTimeEvent          = Font(.installed(.MontserratLight), size: .standard(.h5)).instance        // 12
    static let CyaError              = Font(.installed(.MontserratLight), size: .standard(.error)).instance    // 15
    static let CyaTextField          = Font(.installed(.MontserratLight), size: .standard(.inputText)).instance // 17
    static let CyaIconSM             = Font(.installed(.MontserratLight), size: .standard(.iconSM)).instance    // 11
    static let CyaTextButtonXL       = Font(.installed(.MontserratLight), size: .standard(.h1XL)).instance      // 30
    static let CyaTextButtonXXL      = Font(.installed(.MontserratLight), size: .standard(.XXL)).instance       // 36
    static let CyaTextButtonSmall    = Font(.installed(.MontserratLight), size: .standard(.error)).instance     // 15
    
    static let CyaCheckout           = Font(.installed(.MontserratLight), size: .standard(.inputText)).instance // 17
    static let CyaBack               = Font(.installed(.MontserratBold), size: .standard(.back)).instance // 17
    
    
    
}



