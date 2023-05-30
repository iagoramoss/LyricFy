//
//  AudioPlayerDelegate.swift
//  LyricFy
//
//  Created by Afonso Lucas on 30/05/23.
//

import Foundation

protocol AudioPlayerDelegate: AnyObject {
    
    func playerDidFinishPlaying()
    func playerDidUpdateTime(duration: TimeInterval, currentTime: TimeInterval)
}
