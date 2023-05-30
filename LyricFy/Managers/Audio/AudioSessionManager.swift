//
//  AudioSessionManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 29/05/23.
//

import Foundation
import AVFoundation

final class LocalAudioSessionManager {
    
    private init() {}
    
    public static let shared: AudioSessionManagerProtocol = LocalAudioSessionManager()
    
    private var session = AVAudioSession.sharedInstance()
    
    private func setAudioCategory(_ category: AVAudioSession.Category) {
        do {
            try session.setCategory(category, mode: .default)
            try session.setActive(true)
        } catch {
            #if DEBUG
            print("[LocalAudioSessionManager]: Error while setting up audio category: \(error.localizedDescription)")
            #endif
        }
    }
}

extension LocalAudioSessionManager: AudioSessionManagerProtocol {
    
    var isRecordPermissionGranted: Bool {
        return session.recordPermission == .granted
    }
    
    func requestRecordPermission() {
        session.requestRecordPermission({ _ in })
    }
    
    func prepareToRecord() {
        setAudioCategory(.playAndRecord)
    }
    
    func prepareToPlay() {
        setAudioCategory(.playback)
    }
}
