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
    
    let audioManager: AudioController
    let audioFileManager: AudioFileManager
    let dataManager: PartPersistenceManager
    
    init(compositionPart: Part,
         dataManager: PartPersistenceManager,
         audioManager: AudioController,
         audioFileManager: AudioFileManager
    ) {
        self.compositionPart = compositionPart
        self.audioURL = compositionPart.audioURL
        self.lyricsText = compositionPart.lyrics
        self.lyricsType = compositionPart.type
        
        self.dataManager = dataManager
        self.audioManager = audioManager
        self.audioFileManager = audioFileManager
        
        // Check if there is an audioURL and if it exists
        if let url = compositionPart.audioURL {
            if audioFileManager.fileExists(fileURL: url) {
                audioURL = url
                audioManager.prepareToPlay()
            }
        } else {
            audioManager.prepateToRecord()
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
    
    // MARK: - Record functions
    func startRecording() {
        guard audioURL == nil else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Cant override audio.")
            #endif
            return
        }
        
        let newAudioURL = audioFileManager.getAudioFileUrl(audioID: compositionPart.id)
        
        // Update reference table with new audio url
        audioFileManager.saveAudioInReferenceTable(audioURL: newAudioURL)
        audioManager.startRecording(output: newAudioURL)
        
        audioURL = newAudioURL
        
        // Update part with new audio url
        saveLyricsEdition(completion: nil)
    }
    
    func stopRecording() {
        audioManager.stopRecording()
    }
    
    // MARK: - Play functions
    func playAudio() {
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
        
        audioManager.playAudio(audioURL: url)
    }
    
    func pauseAudio() {
        audioManager.pauseAudio()
    }
    
    func resumeAudio() {
        audioManager.resumeAudio()
    }
    
    // MARK: - File functions
    func deleteAudio() {
        guard audioURL != nil else {
            #if DEBUG
            print("[ScreenLyricsEditingViewModel]: Audio doesnt exists.")
            #endif
            return
        }
        
        audioURL = nil
        
        // Save part without audio
        saveLyricsEdition {
            // Cleaning files
            self.audioFileManager.cleanAudioFilesFromSystemAndReferenceTable()
            // Reload UI to record
            self.audioManager.prepateToRecord()
        }
    }
    
    // MARK: - Utility
    func prepareToExit() {
        audioManager.prepareToPlay()
    }
}
