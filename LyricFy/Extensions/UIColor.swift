//
//  UIColor.swift
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
    case orangeLabel
    case sheetColor
}

extension UIColor {
    static func colors(name: Colors) -> UIColor? {
        return UIColor(named: name.rawValue)
    }
}
