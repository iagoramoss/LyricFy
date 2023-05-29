//
//  UIFont+CustomFont.swift
//  LyricFy
//
//  Created by Iago Ramos on 03/05/23.
//

import Foundation
import UIKit

extension UIFont {
    enum FontName: String {
        case ralewayBold = "Raleway-Bold"
        case ralewayMedium = "Raleway-Medium"
        case ralewaySemibold = "Raleway-SemiBold"
    }
    
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
    
    static func customFont(fontName: FontName, style: TextStyle, size: CGFloat = 41) -> UIFont {
        let font = UIFont(name: fontName.rawValue, size: size)!
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
