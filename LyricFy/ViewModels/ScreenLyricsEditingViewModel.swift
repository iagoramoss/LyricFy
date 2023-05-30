//
//  ScreenLyricsEditingViewModel.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class ScreenLyricsEditingViewModel {
    
    private var compositionPart: Part
    
    var lyricsType: String
    var lyricsText: String
    var audioURL: URL?
    
    private var getDynamicUrl: URL {
        audioFileManager.getAudioFileUrl(audioID: compositionPart.id)
    }
    
    @Published private(set) var audioState: AudioState
    
    @Published private(set) var recordingTimeLabel: String?
    @Published private(set) var pastPlayingTimeLabel: String?
    @Published private(set) var missingPlayingTimeLabel: String?
    
    let audioSessionManager: AudioSessionManager
    let audioFileManager: AudioFileManager
    let dataManager: PartPersistenceManager
    
    private var audioPlayerController: AudioPlayerController?
    private var audioRecorderController: AudioRecorderController?
    
    weak var delegete: AudioPermissionAlertDelegate?
    
    init(compositionPart: Part,
         dataManager: PartPersistenceManager,
         audioSessionManager: AudioSessionManager,
         audioFileManager: AudioFileManager
    ) {
        self.compositionPart = compositionPart
        self.audioURL = compositionPart.audioURL
        self.lyricsText = compositionPart.lyrics
        self.lyricsType = compositionPart.type
        
        self.dataManager = dataManager
        self.audioSessionManager = audioSessionManager
        self.audioFileManager = audioFileManager
        
        self.audioSessionManager.requestRecordPermission()
        
        // Check if there is an audioURL and if its file exists
        if let url = compositionPart.audioURL, audioFileManager.fileExists(fileURL: url) {
            self.audioURL = url
            self.audioSessionManager.prepareToPlay()
            self.audioState = .preparedToPlay
            self.setupAudioPlayerController(audioURL: url)
            self.missingPlayingTimeLabel = audioPlayerController?.audioDuration.formattedTimeString
            self.pastPlayingTimeLabel = "00:00"
        } else {
            self.audioSessionManager.prepareToRecord()
            self.audioState = .preparedToRecord
            self.setupAudioRecorderController(audioURL: getDynamicUrl)
        }
    }
    
    func saveLyricsEdition(completion: (() -> Void)?) {
        dataManager.updatePartByID(partID: compositionPart.id,
                                   index: compositionPart.index,
                                   type: lyricsType,
                                   lyric: lyricsText,
                                   audioURL: audioURL)
        
        if completion != nil {
            completion!()
        }
    }
}

// MARK: - Record functions
extension ScreenLyricsEditingViewModel: AudioRecorderDelegate {
    
    func startRecording() {
        guard audioSessionManager.isRecordPermissionGranted else {
            delegete?.presetAudioPermissionDeniedAlert()
            return
        }
        
        guard audioURL == nil else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Cant override audio.")
            #endif
            return
        }
        
        guard audioState == .preparedToRecord else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: No prepared to record.")
            #endif
            return
        }
        
        let newAudioURL = audioFileManager.getAudioFileUrl(audioID: compositionPart.id)
        
        // Update reference table with new audio url
        audioFileManager.saveAudioInReferenceTable(audioURL: newAudioURL)
        
        guard let recorder = audioRecorderController else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Recorder does not exist.")
            #endif
            return
        }
        
        recorder.startRecording { [weak self] in
            // Update part with new audio url
            self?.audioState = .recording
            self?.audioURL = newAudioURL
            self?.saveLyricsEdition(completion: nil)
        }
    }
    
    func stopRecording() {
        guard audioState == .recording else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Not recording.")
            #endif
            return
        }
        
        guard let recorder = audioRecorderController else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Recorder does not exist.")
            #endif
            return
        }
        
        recorder.stopRecording { [weak self] in
            self?.audioState = .preparedToPlay
        }
    }
    
    // MARK: - Record Delegate
    func recorderDidFinishRecording() {
        audioState = .preparedToPlay
        recordingTimeLabel = nil
        audioRecorderController = nil
        setupAudioPlayerController(audioURL: audioURL!)
        audioSessionManager.prepareToPlay()
        
        missingPlayingTimeLabel = audioPlayerController?.audioDuration.formattedTimeString
        pastPlayingTimeLabel = "00:00"
    }
    
    func recorderDidUpdateTime(currentRecordingTime: TimeInterval) {
        recordingTimeLabel = currentRecordingTime.formattedTimeString
    }
}

// MARK: - Play functions
extension ScreenLyricsEditingViewModel: AudioPlayerDelegate {
    
    func playAudio() {
        guard audioState == .preparedToPlay else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Not prepared to play.")
            #endif
            return
        }
        
        guard let url = audioURL else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: URL for audio not provided.")
            #endif
            return
        }
        
        guard audioFileManager.fileExists(fileURL: url) else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Audio doesnt exist.")
            #endif
            return
        }
        
        guard let player = audioPlayerController else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Player does not exist.")
            #endif
            return
        }
        
        player.playAudio { [weak self] in
            self?.audioState = .playing
        }
    }
    
    func pauseAudio() {
        guard audioState == .playing else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Not prepared to pause.")
            #endif
            return
        }
        
        guard let player = audioPlayerController else { return }
        
        player.pauseAudio { [weak self] in
            self?.audioState = .pausedPlaying
        }
    }
    
    func resumeAudio() {
        guard audioState == .pausedPlaying else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Not prepared to resume.")
            #endif
            return
        }
        
        guard let player = audioPlayerController else { return }
        
        player.resumeAudio { [weak self] in
            self?.audioState = .playing
        }
    }
    
    // MARK: - Player Delegate
    func playerDidFinishPlaying() {
        audioState = .preparedToPlay
        
        missingPlayingTimeLabel = audioPlayerController?.audioDuration.formattedTimeString
        pastPlayingTimeLabel = "00:00"
    }
    
    func playerDidUpdateTime(duration: TimeInterval, currentTime: TimeInterval) {
        pastPlayingTimeLabel = currentTime.formattedTimeString
        missingPlayingTimeLabel = (duration - currentTime).formattedTimeString
    }
}

// MARK: - Utility functions
extension ScreenLyricsEditingViewModel {
    
    func setupAudioPlayerController(audioURL: URL) {
        do {
            audioPlayerController = try AudioPlayerController(audioURL: audioURL,
                                                              delegate: self)
        } catch {
            fatalError("[ScreenLyricsEditingViewModel] Error Player: \(error)")
        }
    }
    
    func setupAudioRecorderController(audioURL: URL) {
        do {
            audioRecorderController = try AudioRecorderController(outputURL: audioURL,
                                                                  delegate: self)
        } catch {
            fatalError("[ScreenLyricsEditingViewModel] Error Recorder: \(error)")
        }
    }
    
    func deleteAudio() {
        defer {
            self.audioFileManager.cleanAudioFilesFromSystemAndReferenceTable()
        }
        
        guard audioURL != nil else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Audio doesnt exists.")
            #endif
            return
        }
        
        audioURL = nil
        audioPlayerController = nil
        pastPlayingTimeLabel = nil
        missingPlayingTimeLabel = nil
        
        setupAudioRecorderController(audioURL: getDynamicUrl)
        audioState = .preparedToRecord
        audioSessionManager.prepareToRecord()
        
        // Save part without audio
        saveLyricsEdition(completion: nil)
    }
    
    func stopTasks() {
        // Stop recornding or playing and reset its state
        stopRecording()
        pauseAudio()
    }
}
