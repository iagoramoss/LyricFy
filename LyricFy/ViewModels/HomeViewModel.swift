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
        dataService.addProject(project: ProjectCellModel(name: name))
        setupViewData()
    }
    
    func updateProjectName(projectId id: UUID, newName: String) {
        let project = dataService.getProjectById(id: id)
        dataService.updateProject(project: project, name: newName)
        setupViewData()
    }
    
    func deleteProject(projectId id: UUID) {
        let project = dataService.getProjectById(id: id)
        dataService.deleteProject(project: project)
        setupViewData()
    }
}
