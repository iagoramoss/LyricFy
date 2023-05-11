//
//  ScreenLyricsEditingViewModel.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class ScreenLyricsEditingViewModel {
    
    private var compositionPart: CompositionPart
    private var didEditLyrics: (CompositionPart) -> Void
    
    var lyricsType: String
    var lyricsText: String
    
    var audioManager: AudioManager
    
    var buttonTapCount: Int = 0
    var buttonPlayCount: Int = 0
    
    init(compositionPart: CompositionPart, didEditAction: @escaping (CompositionPart) -> Void) {
        self.compositionPart = compositionPart
        self.didEditLyrics = didEditAction
        self.lyricsText = compositionPart.lyrics
        self.lyricsType = compositionPart.type
        self.audioManager = AudioManager(partID: compositionPart.id)
    }
    
    func saveLyricsEdition() {
        didEditLyrics(CompositionPart(id: compositionPart.id,
                                      type: lyricsType,
                                      lyrics: lyricsText))
    }
}
