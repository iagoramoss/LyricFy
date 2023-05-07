//
//  UIFont+PreferredFont.swift
//  LyricFy
//
//  Created by Iago Ramos on 03/05/23.
//

import Foundation
import UIKit

extension UIFont {
    
    static func preferredFont(for style: TextStyle, weight: Weight) -> UIFont {
        let traits = UITraitCollection(preferredContentSizeCategory: .large)
        let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style, compatibleWith: traits)
        let font = UIFont.systemFont(ofSize: descriptor.pointSize, weight: weight)
        let metrics = UIFontMetrics(forTextStyle: style)
        return metrics.scaledFont(for: font)
    }
}
