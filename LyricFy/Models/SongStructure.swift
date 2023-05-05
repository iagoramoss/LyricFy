//
//  SongStructure.swift
//  LyricFy
//
//  Created by Iago Ramos on 05/05/23.
//

import Foundation

class SongStructure {
    static let reuseIdentifier = "SongStructure"
    
    let type: StructureType
    let lyric: String
    
    static let mock: [SongStructure] = [
        .init(type: .intro,
              lyric: "This one is for my one and only true love\nPrincess Peach"),
        .init(type: .verse, lyric: "Peach, you're so cool\nAnd with my star, we're gonna rule\nPeach, understand\nI'm gonna love you 'til the very end"),
        .init(type: .chorus, lyric: """
                Peaches, Peaches, Peaches, Peaches, Peaches
                Peaches, Peaches, Peaches, Peaches, Peaches
                I love you, oh
                Peaches, Peaches, Peaches, Peaches, Peaches
                Peaches, Peaches, Peaches, Peaches, Peaches
                I love you, oh
        """),
        .init(type: .verse, lyric: """
                Mario, Luigi, and a Donkey Kong, too
                A thousand troops of Koopas couldn't keep me from you
                Princess Peach, at the end of the line
                I'll make you mine, oh
        """),
        .init(type: .chorus, lyric: "Peaches, Peaches, Peaches, Peaches, Peaches\nPeaches, Peaches, Peaches, Peaches, Peaches\nI love you, oh"),
        .init(type: .outro, lyric: "Peaches, Peaches\nPeach, Peach")
    ]
    
    init(type: StructureType, lyric: String) {
        self.type = type
        self.lyric = lyric
    }
    
    enum StructureType: String {
        case intro
        case verse
        case chorus
        case outro
    }
}
