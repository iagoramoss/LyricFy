//
//  CompositionsCrudProtocol.swift
//  LyricFy
//
//  Created by Afonso Lucas on 03/05/23.
//

import Foundation

protocol CompositionCRUD {
    
    func createNewComposition(compositionName: String)
    func getCompositions() -> [Composition]
    func updateComposition(compositionID: UUID)
    func deleteComposition(compositionID: UUID)
}
