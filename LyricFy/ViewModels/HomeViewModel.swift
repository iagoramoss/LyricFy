//
//  HomeViewModel.swift
//  LyricFy
//
//  Created by Marcos Costa on 28/04/23.
//

import Foundation

class HomeViewModel {
    
    private var dataService: DAOService
    
    var projects: [ProjectCellModel] = []

    init(dataService: DAOService) {
        self.dataService = dataService
    }
    
    func setupViewData() {
        guard let fetched = dataService.getProjects() else { return }
        self.projects.removeAll()
        for currentProject in fetched {
            projects.append(ProjectCellModel(id: currentProject.id!,
                                             name: currentProject.name!,
                                             date: currentProject.createdAt!))
        }
    }
    
    func createProject(name: String) {
        dataService.addProject(id: UUID(), name: name)
        updateProjectsArray()
    }
    
    func updateProjectName(projectId id: UUID, newName: String) {
        let project = dataService.getProjectById(id: id)
        dataService.updateProject(project: project, name: newName)
        updateProjectsArray()
    }
    
    func deleteProject(projectId id: UUID) {
        let project = dataService.getProjectById(id: id)
        dataService.deleteProject(project: project)
        updateProjectsArray()
    }
    
    func updateProjectsArray() {
        self.projects.removeAll()
        guard let fetched = dataService.getProjects() else { return }
        
        for currentProject in fetched {
            projects.append(ProjectCellModel(id: currentProject.id!,
                                             name: currentProject.name!,
                                             date: currentProject.createdAt!))
        }
    }
}
