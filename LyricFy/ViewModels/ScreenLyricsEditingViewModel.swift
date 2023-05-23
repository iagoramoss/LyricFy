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
        self.lyricsText = compositionPart.lyrics
        self.lyricsType = compositionPart.type
        
        self.dataManager = dataManager
        self.audioManager = audioManager
        self.audioFileManager = audioFileManager
        
        // Check if there is an audioURL and if it exists
        if let url = compositionPart.audioURL, audioFileManager.fileExists(fileURL: url) {
            audioURL = url
            audioManager.prepareToPlay()
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
        guard audioURL == nil else { return print("Cant override audio.") }
        
        let newAudioURL = audioFileManager.getAudioFileUrl(audioID: compositionPart.id)
        
        audioManager.startRecording(output: newAudioURL)
        audioURL = newAudioURL
        
        // Update part with new audio url
        saveLyricsEdition {
            // Update reference table with new audio url
            self.audioFileManager.saveAudioInReferenceTable(audioURL: newAudioURL)
        }
    }
    
    func stopRecording() {
        audioManager.stopRecording()
    }
    
    // MARK: - Play functions
    func playAudio() {
        guard let url = audioURL else { return print("URL for audio not provided.") }
        guard audioFileManager.fileExists(fileURL: url) else { return print("Audio doesnt exist.") }
        
        audioManager.playAudio(audioURL: url)
    }
    
    func pauseAudio() {
        audioManager.pauseAudio()
    }
    
    func resumeAudio() {
        audioManager.resumeAudio()
    }
    
    func stopPlaying() {
        audioManager.stopPlayingAudio()
    }
    
    // MARK: - File functions
    func deleteAudio() {
        guard audioURL != nil else { return print("Audio doesnt exists.") }
        
        audioURL = nil
        
        // Save part without audio
        saveLyricsEdition {
            // Cleaning files
            self.audioFileManager.cleanAudioFilesFromSystemAndReferenceTable()
        }
    }
    
    // MARK: - Utility
    func prepareToExit() {
        audioManager.prepareToPlay()
    }
}
