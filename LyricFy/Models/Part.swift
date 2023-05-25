//
//  Part.swift
//  LyricFy
//
//  Created by Afonso Lucas on 12/05/23.
//

import Foundation

struct Part: Identifiable {
    
    var id: UUID
    var index: Int
    var type: String
    var lyrics: String
    var audioURL: URL?
}
