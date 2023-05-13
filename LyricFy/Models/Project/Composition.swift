//
//  Composition.swift
//  LyricFy
//
//  Created by Afonso Lucas on 12/05/23.
//

import Foundation

struct Composition: Identifiable {
    
    var id: UUID
    var name: String
    var createdAt: Date
    var lastAccess: Date
}
