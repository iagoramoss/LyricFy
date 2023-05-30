//
//  AudioRecorderManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 30/05/23.
//

import Foundation

protocol AudioRecorderManagerProtocol {
    
    func startRecording(completion: () -> Void)
    func stopRecording(completion: () -> Void)
}
