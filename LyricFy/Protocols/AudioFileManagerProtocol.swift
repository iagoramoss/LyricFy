//
//  AudioFileManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 23/05/23.
//

import Foundation

protocol AudioFileManager {
    
    func fileExists(fileURL: URL) -> Bool
    func getAudioFileUrl(audioID: UUID) -> URL
    
    func saveAudioInReferenceTable(audioURL: URL)
    func deleteAudioFromSystem(fileURL: URL)
    
    func cleanAudioFilesFromSystemAndReferenceTable()
}
