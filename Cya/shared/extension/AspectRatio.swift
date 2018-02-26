//
//  AspectRatio.swift
//  CyaMainStage
//
//  Created by josvan salvarado on 10/2/17.
//  Copyright © 2017 wtf. All rights reserved.
//

import Foundation

class AspectRatio {
    var aspectRatio:String
    var ratioHeight:Float
    var ratioWidth:Float
    
    init(aspect:String){
        aspectRatio = aspect
        switch aspect {
        case "HD Video":
            ratioHeight = 9
            ratioWidth = 16
        case "Standar Monitor":
            ratioHeight = 3
            ratioWidth = 4
        case "Classic Film":
            ratioHeight = 2
            ratioWidth = 3
        default:
            // HD video
            ratioHeight = 9
            ratioWidth = 16
        }
    }
    
    func getHeightFromWidth(elementWidth:Float) -> Float {
        return elementWidth * ratioHeight / ratioWidth
    }
    
    func getWidthFromHeight(elementHeight: Float) -> Float{
        return elementHeight * ratioWidth / ratioHeight
    }
}

