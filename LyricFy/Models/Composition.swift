//
//  Composition.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

class Composition: Codable, Identifiable {
    
    var id = UUID()
    var name: String
    var versions: [Version]
    var lastAccess: Date = Date.now
    var createdAt: Date = Date.now
    
    init(name: String, versions: [Version]) {
        self.name = name
        self.versions = versions
    }
    
    init(name: String) {
        self.name = name
        self.versions = []
        
        versions.append(Version(versionName: "v1"))
    }
}

class Version: Codable, Identifiable {
    
    var id = UUID()
    var name: String
    var compositionParts: [Part]
    
    init(versionName: String) {
        self.name = versionName
        self.compositionParts = []
    }
}

class Part: Codable, Identifiable {
    
    var index: Int
    var type: String
    var lyrics: String
    
    init(index: Int, type: String, lyrics: String) {
        self.index = index
        self.type = type
        self.lyrics = lyrics
    }
}
