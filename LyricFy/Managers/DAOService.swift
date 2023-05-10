//
//  DAOService.swift
//  LyricFy
//
//  Created by Marcos Costa on 09/05/23.
//

import Foundation
import CoreData

class DAOService: ObservableObject {
    
    let manager = CoreDataManager.shared
    
    func getProjects() -> [ProjectEntity]? {
        let request: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        
        do {
            return try manager.context.fetch(request)
        } catch {
            return nil
        }
    }
    
    func addProject(project: ProjectCellModel) {
        let newProject = ProjectEntity(context: manager.context)
        newProject.id = project.id
        newProject.name = project.name
        newProject.createdAt = project.date
        
        manager.save()
    }
    
    func deleteProject(project: ProjectEntity) {
        manager.context.delete(project)
        manager.save()
    }
    
    func updateProject(project: ProjectEntity, name: String) {
        project.name = name
        manager.save()
    }
    
    func getProjectById(id: UUID) -> ProjectEntity {
        let fetched = getProjects()?.filter({ entity in
            return entity.id == id
        })
        return fetched!.first!
    }
}
