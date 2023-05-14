//
//  HomeViewModel.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import Foundation

class HomeViewModel {
    
    private var dataService: DAOService
    
    var projects: [Composition]

    init(dataService: DAOService) {
        self.dataService = dataService
        self.projects = dataService.getCompositions()
    }
    
    func updateProjects() {
        projects = dataService.getCompositions()
    }
    
    func createProject(name: String) {
        dataService.createComposition(name: name)
        updateProjects()
    }
    
    func updateProjectName(projectId id: UUID, newName: String) {
        dataService.updateCompositionName(compositionID: id, newName: newName)
        updateProjects()
    }
    
    func deleteProject(projectId id: UUID) {
        dataService.deleteCompositionByID(compositionID: id)
        updateProjects()
    }
}
