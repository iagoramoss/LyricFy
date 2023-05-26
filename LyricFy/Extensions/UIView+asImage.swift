//
//  UIView+asImage.swift
//  LyricFy
//
//  Created by Afonso Lucas on 26/05/23.
//

import UIKit

extension UIView {

    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
