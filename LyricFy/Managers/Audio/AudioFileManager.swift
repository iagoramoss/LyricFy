//
//  AudioFileManager.swift
//  LyricFy
//
//  Created by Afonso Lucas on 14/05/23.
//

import Foundation

final class LocalAudioFileManager {
    
    public static var shared = LocalAudioFileManager(persistenceManager: DataAccessManager.shared)
    
    private init(persistenceManager: ReferencePersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    private let persistenceManager: ReferencePersistenceManager
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        guard let url = paths.first else {
            fatalError("Could not get path.")
        }
        
        return url
    }
}

extension LocalAudioFileManager: AudioFileManager {
    
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
        persistenceManager.saveAudioReferenceInTable(fileURL: audioURL)
    }
    
    func deleteAudioFromSystem(fileURL: URL) {
        guard fileExists(fileURL: fileURL) else {
            #if DEBUG
            print("[LocalAudioFileManager]: File doesnt exists.")
            #endif
            return
        }
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch {
            #if DEBUG
            print("[LocalAudioFileManager]: Error while deleting file: \(error)")
            #endif
        }
    }
    
    func cleanAudioFilesFromSystemAndReferenceTable() {
        // Make the check and clean audio files in foreground
        DispatchQueue.global(qos: .background).async { [weak self] in
            guard let self = self else { return }
            
            // Get audio URLS from unique reference table
            let urls = self.persistenceManager.getAudioUrlsFromReferenceTable()
            
            urls.forEach { url in
                // Get URLS count from parts table
                let currentCount = self.persistenceManager.getAudioReferenceCount(fileURL: url)
                
                if currentCount == 0 {
                    self.deleteAudioFromSystem(fileURL: url)
                    self.persistenceManager.deleteAudioReferenceFromTable(fileURL: url)
                }
            }
        }
    }
}
