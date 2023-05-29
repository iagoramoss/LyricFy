//
//  AudioSessionManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 29/05/23.
//

import Foundation
import AVFoundation

protocol AudioSessionManager {
    
    var isRecordPermissionGranted: Bool { get }
    
    func requestRecordPermission()
    func prepareToRecord()
    func prepareToPlay()
}

final class LocalAudioSessionManager: AudioSessionManager {
    
    private init() {}
    
    public static let shared: AudioSessionManager = LocalAudioSessionManager()
    
    private var session = AVAudioSession.sharedInstance()
    
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
    
    // MARK: - Utility
    private func setAudioCategory(_ category: AVAudioSession.Category) {
        do {
            try session.setCategory(category, mode: .default)
            try session.setActive(true)
        } catch {
            #if DEBUG
            print("[AudioController]: Error while setting up audio category: \(error.localizedDescription)")
            #endif
        }
    }
}
