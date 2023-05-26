//
//  SliderThumb.swift
//  LyricFy
//
//  Created by Afonso Lucas on 26/05/23.
//

import UIKit

class SliderThumb: UIView {
    
    let fillColor: UIColor
    
    init(fill: UIColor, frame: CGRect) {
        self.fillColor = fill
        super.init(frame: frame)
        self.backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else { return }

        ctx.setFillColor(UIColor.red.cgColor)
        ctx.fillEllipse(in: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
