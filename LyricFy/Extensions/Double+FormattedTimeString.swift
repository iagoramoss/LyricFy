//
//  Double+FormattedTimeString.swift
//  LyricFy
//
//  Created by Afonso Lucas on 29/05/23.
//

import Foundation

extension Double {
    
    var formattedTimeString: String {
        let timeInSeconds = Int(self)
        let seconds = Int(timeInSeconds % 60)
        let minutes = Int((timeInSeconds / 60) % 60)
        let hours = Int(timeInSeconds / 3600)
        
        return String(format: "%02i:%02i", (hours * 60) + minutes, seconds)
    }
}
