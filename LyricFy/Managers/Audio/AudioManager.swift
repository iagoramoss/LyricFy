//
//  AudioManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 08/05/23.
//

import Foundation
import AVFoundation

typealias AudioControl = AVAudioPlayerDelegate & AVAudioRecorderDelegate

class AudioManager: NSObject, AudioControl {
    
    @Published var audioControlState: AudioState
    @Published var recordingTimeLabel: String?
    
    private var fileManager: AudioFileManager
    
    private var session: AVAudioSession
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    private var meterTimer: Timer?
    private var audioID: UUID
    
    private var isAudioRecordingGranted: Bool {
        var granted = false
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted: granted = true
        case AVAudioSession.RecordPermission.denied: granted = false
        default: granted = false
        }
        return granted
    }
    
    var delegete: AudioPermissionAlertDelegate?
    
    var audioFilename: String {
        "\(audioID).m4a"
    }
    
    init(partID: UUID) {
        audioControlState = .preparedToRecord
        audioID = partID
        session = AVAudioSession.sharedInstance()
        fileManager = AudioFileManager.shared
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error {
            #if DEBUG
            print(error)
            #endif
        }
        session.requestRecordPermission({ print($0) })
    }
    
    func prepareViewModel() {
        if fileManager.fileExists(filename: audioFilename) {
            audioControlState = .preparedToPlay
            
            setAudioCategory(.playback)
        }
    }
    
    // MARK: - Utils
    private func setAudioCategory(_ category: AVAudioSession.Category) {
        do {
            try session.setCategory(category, mode: .default)
            try session.setActive(true)
        } catch let error {
            #if DEBUG
            print(error)
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
extension AudioManager {
    
    func startRecording() {
        guard audioControlState == .preparedToRecord else { return }
        guard isAudioRecordingGranted else {
            delegete?.presetAudioPermissionDeniedAlert()
            return
        }
        
        setAudioCategory(.playAndRecord)
        
        let output = fileManager.getAudioFileUrl(filename: audioFilename)
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
extension AudioManager {
    
    func playAudio() {
        guard audioControlState == .preparedToPlay, fileManager.fileExists(filename: audioFilename) else { return }
        
        let fileURL = fileManager.getAudioFileUrl(filename: audioFilename)
        
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
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

// MARK: - File functions
extension AudioManager {
    
    func deleteAudio() {
        guard fileManager.fileExists(filename: audioFilename) else { return }
        
        fileManager.deleteAudioFile(filename: audioFilename)
        audioControlState = .preparedToRecord
        setAudioCategory(.playAndRecord)
    }
}
