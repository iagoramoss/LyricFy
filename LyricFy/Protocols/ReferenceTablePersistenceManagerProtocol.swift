//
//  ReferenceTablePersistenceManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 23/05/23.
//

import Foundation

protocol ReferencePersistenceManager {
    
    func getAudioUrlsFromReferenceTable() -> [URL]
    func getAudioReferenceCount(fileURL url: URL) -> Int?
    func audioReferenceExistsInTable(fileURL url: URL) -> Bool?
    
    func saveAudioReferenceInTable(fileURL url: URL)
    func deleteAudioReferenceFromTable(fileURL url: URL)
}
