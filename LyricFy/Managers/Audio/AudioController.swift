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
    
    private var session = AVAudioSession.sharedInstance()
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    private var meterTimer: Timer?
    
    var delegete: AudioPermissionAlertDelegate?
    
    private override init() {
        audioControlState = .preparedToRecord
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch {
            #if DEBUG
            print("[AudioController]: Error while setting up audio session: \(error.localizedDescription)")
            #endif
        }
        
        session.requestRecordPermission({ _ in })
    }
    
    func prepareToRecord() {
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
        } catch {
            #if DEBUG
            print("[AudioController]: Error while setting up audio category: \(error.localizedDescription)")
            #endif
        }
    }
    
    private func getFormattedTimeString(_ timeInterval: TimeInterval) -> String {
        let components = Calendar.current.dateComponents([.hour, .minute, .second],
                                                         from: Date(timeIntervalSinceReferenceDate: timeInterval))
        
        let formattedString = String(format: "%02d:%02d:%02d",
                                     components.hour ?? 0,
                                     components.minute ?? 0,
                                     components.second ?? 0)
        
        return formattedString
    }
    
    @objc
    private func updateAudioMeter(timer: Timer) {
        guard audioControlState == .recording, let recorder = self.recorder else { return }
        
        let timeString = getFormattedTimeString(recorder.currentTime)
        
        recordingTimeLabel = timeString
        recorder.updateMeters()
    }
    
    // MARK: - Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        guard flag else {
            stopRecording()
            prepareToRecord()
            return
        }
        
        prepareToPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioControlState = .preparedToPlay
    }
}

// MARK: - Recording functions
extension AudioController {
    
    func startRecording(output: URL) {
        guard audioControlState == .preparedToRecord else { return }
        
        guard session.recordPermission == .granted else {
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
        } catch {
            #if DEBUG
            print("[AudioController]: Recording ERROR: \(error.localizedDescription)")
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
        } catch {
            #if DEBUG
            print("[AudioController]: Playing ERROR: \(error.localizedDescription)")
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
