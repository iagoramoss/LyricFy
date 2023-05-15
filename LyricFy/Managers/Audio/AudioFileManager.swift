//
//  AudioFileManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 14/05/23.
//

import Foundation

final class AudioFileManager {
    
    private init() {}
    
    static var shared = AudioFileManager()
    
    func getAudioFileUrl(filename: String) -> URL {
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    func deleteAudioFile(filename: String) {
        guard fileExists(filename: filename) else { return }
        
        do {
            try FileManager.default.removeItem(at: getAudioFileUrl(filename: filename))
        } catch let error {
            print("Error while deleting file: \(error)")
        }
    }
    
    func fileExists(filename: String) -> Bool {
        return FileManager.default.fileExists(atPath: getAudioFileUrl(filename: filename).path)
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
