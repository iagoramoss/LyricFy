//
//  AudioFileManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 14/05/23.
//

import Foundation

final class LocalAudioFileManager: AudioFileManager {
    
    public static var shared = LocalAudioFileManager(persistenceManager: DataAccessManager.shared)
    
    private init(persistenceManager: ReferencePersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    private let persistenceManager: ReferencePersistenceManager
    
    // MARK: - Utility
    func fileExists(fileURL: URL) -> Bool {
        return FileManager.default.fileExists(atPath: fileURL.path)
    }
    
    func getAudioFileUrl(audioID: UUID) -> URL {
        let filename = "\(audioID.uuidString).m4a"
        let filePath = getDocumentsDirectory().appendingPathComponent(filename)
        return filePath
    }
    
    // MARK: - Actions
    func saveAudioInReferenceTable(audioURL: URL) {
        guard persistenceManager.audioReferenceExistsInTable(fileURL: audioURL) == false
        else { return print("Reference already exits.") }
        
        persistenceManager.saveAudioReferenceInTable(fileURL: audioURL)
    }
    
    func deleteAudioFromSystem(fileURL: URL) {
        guard fileExists(fileURL: fileURL) else { return print("File doesnt exist.") }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            #if DEBUG
            print("Error while deleting file: \(error)")
            #endif
        }
    }
    
    func cleanAudioFilesFromSystemAndReferenceTable() {
        // Make the check and clean audio files in foreground
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let urls = self?.persistenceManager.getAudioUrlsFromReferenceTable() else {
                return print("Couldnt get reference table")
            }
            
            for url in urls {
                let currentCount = self?.persistenceManager.getAudioReferenceCount(fileURL: url)
                
                if currentCount == 0 {
                    self?.deleteAudioFromSystem(fileURL: url)
                    self?.persistenceManager.deleteAudioReferenceFromTable(fileURL: url)
                }
            }
        }
    }
}

extension LocalAudioFileManager {
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
