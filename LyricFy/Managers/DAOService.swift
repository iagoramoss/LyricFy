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
    
    func addProject(name: String) {
        let newProject = ProjectEntity(context: manager.context)
        newProject.id = UUID()
        newProject.name = name
        newProject.createdAt = Date.now
        
        addVersion(version: "Version 1", project: newProject, parts: [])
        newProject.versions = NSSet(array: getVersions()!)
        
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
    
    func getVersions() -> [VersionEntity]? {
        let request: NSFetchRequest<VersionEntity> = VersionEntity.fetchRequest()

        do {
            return try manager.context.fetch(request)
        } catch {
            return nil
        }
    }

    func addVersion(version: String, project: ProjectEntity, parts: [PartEntity]) {
        let newVersion = VersionEntity(context: manager.context)
        newVersion.id = UUID()
        newVersion.version = version
        
        newVersion.project = project
        newVersion.parts = NSSet(array: parts)

        manager.save()
    }

    func deleteVersion(version: VersionEntity) {
        manager.context.delete(version)
        manager.save()
    }
    
    func updatePartsArray(version: VersionEntity, parts: [PartEntity]) {
        version.parts = NSSet(array: parts)
        manager.save()
    }

    func getVersionById(id: UUID) -> VersionEntity {
        let fetched = getVersions()?.filter({ entity in
            return entity.id == id
        })
        return fetched!.first!
    }
    
    func getVersionsOfProjectById(projectId: UUID) -> [VersionEntity]? {
        let fetched = getProjects()?.filter({ entity in
            return entity.id == projectId
        })
        guard let fetch = fetched!.first!.versions!.allObjects as? [VersionEntity] else { return nil }

        return fetch
    }
    
    func getParts() -> [PartEntity]? {
        let request: NSFetchRequest<PartEntity> = PartEntity.fetchRequest()
        
        do {
            return try manager.context.fetch(request)
        } catch {
            return nil
        }
    }
    
    func addPart(type: String, lyric: String, version: VersionEntity) {
        let newPart = PartEntity(context: manager.context)
        newPart.id = UUID()
        newPart.type = type
        newPart.lyric = lyric
        
        newPart.version = version
        
        manager.save()
    }
    
    func deletePart(part: PartEntity) {
        manager.context.delete(part)
        manager.save()
    }

    func updatePart(part: PartEntity, type: String, lyric: String) {
        part.type = type
        part.lyric = lyric
        manager.save()
    }
    
    func getPartById(id: UUID) -> PartEntity {
        let fetched = getParts()?.filter({ entity in
            return entity.id == id
        })
        return fetched!.first!
    }
    
    func getPartsOfVersionById(versionId: UUID) -> [PartEntity]? {
        let fetched = getVersions()?.filter({ entity in
            return entity.id == versionId
        })
        guard let fetch = fetched!.first!.parts!.allObjects as? [PartEntity] else { return nil }

        return fetch
    }
}
