//
//  ScreenLyricsEditingViewModel.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class ScreenLyricsEditingViewModel {
    
    private var compositionPart: Part
    private var didEditLyrics: (Part) -> Void
    
    var lyricsType: String
    var lyricsText: String
    
    var audioManager: AudioManager
    
    init(compositionPart: Part, didEditAction: @escaping (Part) -> Void) {
        self.compositionPart = compositionPart
        self.didEditLyrics = didEditAction
        self.lyricsText = compositionPart.lyrics
        self.lyricsType = compositionPart.type
        self.audioManager = AudioManager(partID: compositionPart.id)
    }
    
    func saveLyricsEdition() {
        didEditLyrics(Part(id: compositionPart.id,
                           index: compositionPart.index,
                           type: lyricsType,
                           lyrics: lyricsText))
    }
}
