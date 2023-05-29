//
//  AudioPlayerController.swift
//  LyricFy
//
//  Created by Afonso Lucas on 29/05/23.
//

import Foundation
import AVFAudio

protocol AudioPlayerDelegate: AnyObject {
    
    func playerDidFinishPlaying()
    func playerDidUpdateTime(duration: TimeInterval, currentTime: TimeInterval)
}

class AudioPlayerController: NSObject, AVAudioPlayerDelegate {
    
    var audioDuration: TimeInterval {
        audioPlayer.duration
    }
    
    weak var delegate: AudioPlayerDelegate?
    
    private var timer: Timer?
    private var audioPlayer: AVAudioPlayer
    
    init(audioURL: URL, delegate: AudioPlayerDelegate) throws {
        try audioPlayer = AVAudioPlayer(contentsOf: audioURL)
        super.init()
        audioPlayer.delegate = self
        audioPlayer.numberOfLoops = 0
        self.delegate = delegate
    }
    
    func playAudio(completion: () -> Void) {
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        timer = Timer.scheduledTimer(timeInterval: 0.1,
                                     target: self,
                                     selector: #selector(update),
                                     userInfo: nil,
                                     repeats: true)
        completion()
    }
    
    func pauseAudio(completion: () -> Void) {
        audioPlayer.pause()
        completion()
    }
    
    func resumeAudio(completion: () -> Void) {
        audioPlayer.play()
        completion()
    }
    
    @objc
    func update() {
        delegate?.playerDidUpdateTime(duration: audioPlayer.duration,
                                      currentTime: audioPlayer.currentTime)
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        timer?.invalidate()
        timer = nil
        delegate?.playerDidFinishPlaying()
    }
}
