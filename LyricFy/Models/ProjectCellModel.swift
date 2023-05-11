//
//  ProjectCellModel.swift
//  LyricFy
//
//  Created by Afonso Lucas on 10/05/23.
//

import Foundation

struct ProjectCellModel: Identifiable {
    
    var id: UUID = UUID()
    var name: String
    var date: Date = Date.now
}
