//
//  Composition.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class Composition: Codable, Identifiable {
    
    var id: UUID
    var name: String
    var versions: [Version]
    
    init(id: UUID, name: String = "Song", versions: [Version] = []) {
        self.id = id
        self.name = name
        self.versions = versions
    }
}

class Version1: Codable, Identifiable {
    
    var id = UUID()
    var name: String
    var compositionParts: [Part]
    
    init(versionName: String) {
        self.name = versionName
        self.compositionParts = []
    }
}

struct Version: Codable, Identifiable {
    var id: UUID
    var name: String
    var compositionParts: [Part]
}

class Part: Codable, Identifiable {
    
    var id: UUID
    var type: String
    var lyrics: String
    
    init(id: UUID, type: String, lyrics: String) {
        self.id = id
        self.type = type
        self.lyrics = lyrics
    }
}
