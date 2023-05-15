//
//  Fonts.swift
//  LyricFy
//
//  Created by Marcos Costa on 12/05/23.
//

import Foundation
import UIKit

enum FontName {
    case ralewayBold
    case ralewayMedium
    case ralewaySemibold
}

extension UIFont {
    static func fontCustom(fontName: FontName, size: CGFloat) -> UIFont? {
        let fontNameString: String = {
            
            switch fontName {
            case .ralewayBold: return "Raleway-Bold"
            case .ralewayMedium: return "Raleway-Medium"
            case .ralewaySemibold: return "Raleway-SemiBold"
            }
        }()
        
        return UIFont(name: fontNameString, size: size)
    }
}
