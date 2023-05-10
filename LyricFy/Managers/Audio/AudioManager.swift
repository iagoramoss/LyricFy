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
    
    private var session: AVAudioSession
    private var player: AVAudioPlayer?
    private var recorder: AVAudioRecorder?
    
    private var meterTimer: Timer?
    private var audioID: UUID
    
    private var audioExists: Bool {
        FileManager.default.fileExists(atPath: getFileUrl().path)
    }
    
    private var isAudioRecordingGranted: Bool {
        var granted = false
        switch AVAudioSession.sharedInstance().recordPermission {
        case AVAudioSession.RecordPermission.granted: granted = true
        case AVAudioSession.RecordPermission.denied: granted = false
        default: granted = false
        }
        return granted
    }
    
    init(partID: UUID) {
        audioControlState = .preparedToRecord
        audioID = partID
        session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
            
            // Caso a sessão não esteja habilitada pedir autorização
            session.requestRecordPermission({ print($0) })
        } catch {}
    }
    
    func prepareViewModel() {
        if audioExists {
            audioControlState = .preparedToPlay
        }
    }
    
    // MARK: - Utils
    @objc
    private func updateAudioMeter(timer: Timer) {
        guard audioControlState == .recording, let recorder = self.recorder else { return }
        
        let hr = Int((recorder.currentTime / 60) / 60)
        let min = Int(recorder.currentTime / 60)
        let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
        
        recordingTimeLabel = String(format: "%02d:%02d:%02d", hr, min, sec)
        recorder.updateMeters()
    }
    
    private func getFileUrl() -> URL {
        let filename = "\(audioID).mp3"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    // MARK: - Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag { stopRecording() }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        audioControlState = .preparedToPlay
    }
}

// MARK: - Recording functions
extension AudioManager {
    
    func startRecording() {
        guard audioControlState == .preparedToRecord, isAudioRecordingGranted else { return }
        
        let output = getFileUrl()
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEGLayer3),
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
            print("Recording ERROR: \(error.localizedDescription)")
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
        guard audioControlState == .preparedToPlay, audioExists else { return }
        
        let fileURL = getFileUrl()
        
        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.delegate = self
            player?.prepareToPlay()
            player?.play()
            
            audioControlState = .playing
        } catch let error {
            print("Playing ERROR: \(error.localizedDescription)")
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
