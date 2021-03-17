//
//  Views.swift
//  Swift-SearchGitHub
//
//  Created by AndyChen on 2021/3/17.
//


import UIKit
import Foundation

func topOffset(_ mul: CGFloat) -> CGFloat {
    return Views.screenHeight * mul
}

func leftRightOffset(_ mul: CGFloat) -> CGFloat {
    return Views.screenWidth * mul
}

func sizeFrom(scale: CGFloat) -> CGFloat {
    return  Views.screenWidth * scale
}

func height(_ mul: CGFloat) -> CGFloat {
    return  Views.screenHeight * mul
}

func width(_ mul: CGFloat) -> CGFloat {
    return  Views.screenWidth * mul
}
func pHeight(_ mul: CGFloat) -> CGFloat {
    return  (Views.screenHeight * (mul / 812))
}

func pWidth(_ mul: CGFloat) -> CGFloat {
    return  (Views.screenWidth * (mul / 375))
}

func fontHeight(_ mul: CGFloat) -> CGFloat {
    return  Views.screenWidth * mul
}

class Views {
    static let screenWidth:CGFloat = UIScreen.main.bounds.size.width
    static let screenHeight:CGFloat = UIScreen.main.bounds.size.height
   
    
    static let navigationBarHeight:CGFloat = 44
    static let tabBarHeight:CGFloat = Views.isIPhoneWithNotch() ? 83 :49
    static let statusBarHeight:CGFloat = Views.isIPhoneWithNotch() ? 44 :20
    static let topOffset:CGFloat = Views.navigationBarHeight + Views.statusBarHeight
    static let bottomOffset:CGFloat = Views.isIPhoneWithNotch() ? 34 :0
    static let bottomOffsetWithTabbar:CGFloat = Views.isIPad() ? 83 : Views.isIPhoneWithNotch() ? 83 :49
    static let screenRect = CGRect(x:0, y:0, width:Views.screenWidth, height:Views.screenHeight)
    
    
    static func isIPhoneSE() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:320, height:568)
    }
    
    static func isIPhone8() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:375, height:667)
    }
    
    static func isIPhone8Plus() -> Bool {
        return UIScreen.main.bounds.size == CGSize(width:414, height:736)
    }
    
    static func isIPad() -> Bool {
        return UIScreen.main.bounds.size.width >= 768
    }
    
    static func isIPhoneWithNotch() -> Bool {
        return (UIScreen.main.bounds.size.height >= 812 ) && !Views.isIPad()
    }
    static func isIPhoneXR() -> Bool {
        return UIScreen.main.bounds.size.height >= 896
    }
    
    static func isIPhoneX() -> Bool {
        return UIScreen.main.bounds.size.height == 812
    }
    
    enum Scale:CGFloat {
        case iphoneXR = 896
        case iphoneX = 812
        case iphone8P = 8736
        case iphone8 = 667
        case iphoneSE = 568
        
    }
    
   static func getScaleByHeight(scale : Scale) -> CGFloat {
        return Views.screenHeight/scale.rawValue
    }
    
    static let screenCGRect = CGRect(x:0, y:0, width:Views.screenWidth, height:Views.screenHeight)
}
