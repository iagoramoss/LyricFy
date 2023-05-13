//
//  File.swift
//  LyricFy
//
//  Created by Afonso Lucas on 01/05/23.
//

import UIKit

extension NSAttributedString {

    static var defaultParagraphAttributes: [NSAttributedString.Key: Any] {
        let font = UIFont.systemFont(ofSize: 17, weight: .regular)
        let paragraphStyle = NSMutableParagraphStyle()
        let kern = 0.37

        paragraphStyle.lineHeightMultiple = 1.08
        paragraphStyle.lineBreakMode = .byWordWrapping

        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .paragraphStyle: paragraphStyle,
            .kern: kern
        ]

        return attributes
    }
}
