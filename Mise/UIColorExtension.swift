//
//  UIColorExtension.swift
//  Mise
//
//  Created by Seongchan Kang on 16/01/2019.
//  Copyright © 2019 Seongchan Kang. All rights reserved.
//

import Foundation
import UIKit


let GROUPIDENTIFIER = "group.mise.widget"

extension UIColor {
    
    static var wellGreen:UIColor {
        return UIColor.init(red: 27/255, green: 130/255, blue: 0/255, alpha: 1)
    }
    static var normalYellow:UIColor {
        return UIColor.init(red: 215/255, green: 219/255, blue: 4/255, alpha: 1)
    }
    static var unhealthyTangerine:UIColor {
        return UIColor.init(red: 224/255, green: 146/255, blue: 44/255, alpha: 1)
    }
    static var unhealthyRed:UIColor {
        return UIColor.init(red: 145/255, green: 10/255, blue: 0/255, alpha: 1)
    }
    static var unhealthyPurple:UIColor {
        return UIColor.init(red: 59/255, green: 0/255, blue: 71/255, alpha: 1)
    }
    static var hazardPurple:UIColor {
        return UIColor.init(red: 27/255, green: 0/255, blue: 33/255, alpha: 1)
    }
}


extension String {
    
    func makeAttrString(font:UIFont, color:UIColor) -> NSMutableAttributedString {
        
        let descTitle = NSMutableAttributedString.init(string:self)
        
        descTitle.addAttributes([NSAttributedString.Key.foregroundColor:color, NSAttributedString.Key.font:font], range: NSRange.init(location: 0, length: descTitle.length))
        
        return descTitle
    }
}

enum NotoSansFontSize:String {
    
    case bold = "NotoSans-Bold"
    case regular = "NotoSans-Regular"
    case medium = "NotoSans-Medium"
    case thin = "NotoSans-Light"
    
}

extension UIFont {
    
    static func NotoSans(_ font:NotoSansFontSize, size:CGFloat) -> UIFont {
        
        
        return UIFont.init(name: font.rawValue, size: size)!
        
    }
    
}
