//
//  AudioController.swift
//  LyricFy
//
//  Created by Afonso Lucas on 08/05/23.
//

import Foundation
import AVFoundation

class AudioController: NSObject, AVAudioPlayerDelegate, AVAudioRecorderDelegate {
    
    public static let shared = AudioController()
    
    @Published private(set) var audioControlState: AudioState
    @Published private(set) var recordingTimeLabel: String?
    
    private var session: AVAudioSession
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    private var meterTimer: Timer?
    
    private var isAudioRecordingGranted: Bool {
        var granted = false
        
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted:
            granted = true
        default:
            granted = false
        }
        return granted
    }
    
    var delegete: AudioPermissionAlertDelegate?
    
    private override init() {
        audioControlState = .preparedToRecord
        session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error {
            #if DEBUG
            print("Error while setting up audio session: \(error.localizedDescription)")
            #endif
        }
        
        session.requestRecordPermission({ _ in })
    }
    
    func prepateToRecord() {
        stopPlayingAudio()
        stopRecording()
        
        audioControlState = .preparedToRecord
        setAudioCategory(.playAndRecord)
    }
    
    func prepareToPlay() {
        stopPlayingAudio()
        stopRecording()
        
        audioControlState = .preparedToPlay
        setAudioCategory(.playback)
    }
    
    // MARK: - Utils
    private func setAudioCategory(_ category: AVAudioSession.Category) {
        do {
            try session.setCategory(category, mode: .default)
            try session.setActive(true)
        } catch let error {
            #if DEBUG
            print("Error while setting up audio category: \(error.localizedDescription)")
            #endif
        }
    }
    
    @objc
    private func updateAudioMeter(timer: Timer) {
        guard audioControlState == .recording, let recorder = self.recorder else { return }
        
        let hr = Int((recorder.currentTime / 60) / 60)
        let min = Int(recorder.currentTime / 60)
        let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
        
        recordingTimeLabel = String(format: "%02d:%02d:%02d", hr, min, sec)
        recorder.updateMeters()
    }
    
    // MARK: - Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag { stopRecording() }
        
        setAudioCategory(.playback)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioControlState = .preparedToPlay
    }
}

// MARK: - Recording functions
extension AudioController {
    
    func startRecording(output: URL) {
        guard audioControlState == .preparedToRecord else { return }
        guard isAudioRecordingGranted else {
            delegete?.presetAudioPermissionDeniedAlert()
            return
        }
        
        setAudioCategory(.playAndRecord)
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            recorder = try AVAudioRecorder(url: output, settings: settings)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
            recorder?.record()
            
            audioControlState = .recording
            meterTimer = Timer.scheduledTimer(timeInterval: 0.1,
                                              target: self,
                                              selector: #selector(updateAudioMeter(timer:)),
                                              userInfo: nil,
                                              repeats: true)
        } catch let error {
            #if DEBUG
            print("Recording ERROR: \(error.localizedDescription)")
            #endif
        }
    }
    
    func stopRecording() {
        guard audioControlState == .recording  else { return }
        recorder?.stop()
        recorder = nil
        meterTimer?.invalidate()
        meterTimer = nil
        audioControlState = .preparedToPlay
    }
}

// MARK: - Playing functions
extension AudioController {
    
    func playAudio(audioURL: URL) {
        guard audioControlState == .preparedToPlay else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: audioURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            
            audioControlState = .playing
        } catch let error {
            #if DEBUG
            print("Playing ERROR: \(error.localizedDescription)")
            #endif
        }
    }
    
    func stopPlayingAudio() {
        guard audioControlState == .playing else { return }
        
        player?.stop()
        player = nil
        audioControlState = .preparedToPlay
    }
    
    func pauseAudio() {
        guard audioControlState == .playing else { return }
        
        player?.pause()
        audioControlState = .pausedPlaying
    }
    
    func resumeAudio() {
        guard audioControlState == .pausedPlaying else { return }
        
        player?.play()
        audioControlState = .playing
    }
}
