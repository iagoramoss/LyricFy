//
//  ScreenLyricsEditingViewModel.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class ScreenLyricsEditingViewModel {
    
    private var compositionPart: Part
    private var didEditLyrics: (String) -> Void
    
    var lyricsType: String {
        compositionPart.type
    }
    
    var lyricsText: String
    
    init(compositionPart: Part, didEditAction: @escaping (String) -> Void) {
        self.compositionPart = compositionPart
        self.didEditLyrics = didEditAction
        self.lyricsText = compositionPart.lyrics
    }
    
    func saveLyricsEdition() {
        didEditLyrics(lyricsText)
    }
}
