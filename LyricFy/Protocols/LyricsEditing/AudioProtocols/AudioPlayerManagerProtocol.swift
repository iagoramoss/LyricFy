//
//  AudioPlayerManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 30/05/23.
//

import Foundation

protocol AudioPlayerManagerProtocol {
    
    var audioDuration: TimeInterval { get }
    
    func playAudio(completion: () -> Void)
    func pauseAudio(completion: () -> Void)
    func resumeAudio(completion: () -> Void)
}
