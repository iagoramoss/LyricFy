//
//  Compositions.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

final class Compositions {
    
    private(set) var projects: [Composition] = []
    
    init() {
        projects.append(MockCompositionData.shared.composition)
    }
}

extension Compositions: CompositionCRUD {
    
    func createNewComposition(compositionName: String) {
        projects.append(Composition(name: compositionName))
    }
}
