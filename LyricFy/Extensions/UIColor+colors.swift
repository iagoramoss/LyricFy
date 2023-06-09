//
//  UIColor+colors.swift
//  LyricFy
//
//  Created by Anne Victoria Batista Auzier on 12/05/23.
//

import Foundation
import UIKit

enum Colors: String {
    case bgColor
    case buttonsColor
    case buttonsLabel
    case sectionsColor
    case placeholderColor
    case sheetComponentColor
}

extension UIColor {
    static func colors(name: Colors) -> UIColor? {
        guard let color = UIColor(named: name.rawValue) else {
            return .black
        }
        return color
    }
}
