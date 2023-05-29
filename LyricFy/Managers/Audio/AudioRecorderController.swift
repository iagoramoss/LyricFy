//
//  AudioRecorderController.swift
//  LyricFy
//
//  Created by Afonso Lucas on 29/05/23.
//

import Foundation
import AVFoundation

protocol AudioRecorderDelegate: AnyObject {
    
    func recorderDidFinishRecording()
    func recorderDidUpdateTime(currentRecordingTime: TimeInterval)
}

class AudioRecorderController: NSObject, AVAudioRecorderDelegate {
    
    weak var delegate: AudioRecorderDelegate?
    
    private var audioRecorder: AVAudioRecorder
    private var timer: Timer?
    
    init(outputURL: URL, delegate: AudioRecorderDelegate) throws {
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 2,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        audioRecorder = try AVAudioRecorder(url: outputURL, settings: settings)
        audioRecorder.isMeteringEnabled = true
        super.init()
        audioRecorder.delegate = self
    }
    
    func startRecording(completion: () -> Void) {
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(update),
                                     userInfo: nil,
                                     repeats: true)
        completion()
    }
    
    func stopRecording(completion: () -> Void) {
        audioRecorder.stop()
        timer?.invalidate()
        timer = nil
        completion()
    }
    
    @objc
    func update() {
        delegate?.recorderDidUpdateTime(currentRecordingTime: audioRecorder.currentTime)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        delegate?.recorderDidFinishRecording()
    }
}
