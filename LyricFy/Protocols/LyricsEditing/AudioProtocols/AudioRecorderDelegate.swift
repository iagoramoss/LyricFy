//
//  AudioRecorderDelegate.swift
//  LyricFy
//
//  Created by Afonso Lucas on 30/05/23.
//

import Foundation

protocol AudioRecorderDelegate: AnyObject {
    
    func recorderDidFinishRecording()
    func recorderDidUpdateTime(currentRecordingTime: TimeInterval)
}
