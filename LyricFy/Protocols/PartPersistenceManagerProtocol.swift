//
//  PartPersistenceManagerProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 22/05/23.
//

import Foundation

protocol PartPersistenceManager {
    
    func updatePartByID(partID: UUID,
                        index: Int,
                        type: String,
                        lyric: String,
                        audioURL: URL?)
}
