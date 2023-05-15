//
//  DAOService.swift
//  LyricFy
//
//  Created by Marcos Costa on 09/05/23.
//

import Foundation
import CoreData

class DAOService {
    
    private let manager = CoreDataManager.shared
    
    // MARK: - Composition utility functions
    private func getProjectEntities() -> [ProjectEntity]? {
        let request: NSFetchRequest<ProjectEntity> = ProjectEntity.fetchRequest()
        
        do {
            return try manager.context.fetch(request)
        } catch {
            #if DEBUG
            print("Error while retrieving projects: \(error.localizedDescription)")
            #endif
            return nil
        }
    }
    
    private func getProjectById(id: UUID) -> ProjectEntity? {
        guard let projects = getProjectEntities() else { return nil }
        return projects.first(where: { $0.id == id })
    }
    
    func getCompositions() -> [Composition] {
        guard let entities = getProjectEntities() else { return [] }
        
        return entities.map { entity in
            Composition(id: entity.id!,
                        name: entity.name!,
                        createdAt: entity.createdAt!,
                        lastAccess: entity.lastAccess!)
        }
    }
    
    func createComposition(name: String) {
        let project = ProjectEntity(context: manager.context)
        project.id = UUID()
        project.name = name
        project.createdAt = Date.now
        project.lastAccess = Date.now
        
        // Creating First Version
        let version = VersionEntity(context: manager.context)
        version.id = UUID()
        version.version = "Version 1"
        version.project = project
        version.parts = NSSet(array: [])
        
        // Setting Up First Version
        project.versions = NSSet(array: [version])
        
        manager.save()
    }
    
    func deleteCompositionByID(compositionID id: UUID) {
        guard let project = getProjectById(id: id) else { return }
        
        manager.context.delete(project)
        manager.save()
    }
    
    func updateCompositionName(compositionID id: UUID, newName: String) {
        guard let project = getProjectById(id: id) else { return }
        
        project.name = newName
        manager.save()
    }
    
    // MARK: - Version utility functions
    private func getVersionEntities() -> [VersionEntity]? {
        let request: NSFetchRequest<VersionEntity> = VersionEntity.fetchRequest()

        do {
            return try manager.context.fetch(request)
        } catch {
            #if DEBUG
            print("Error while retrieving versions: \(error.localizedDescription)")
            #endif
            return nil
        }
    }
    
    private func getVersionEntityByID(id: UUID) -> VersionEntity? {
        guard let versions = getVersionEntities() else { return nil }
        return versions.first(where: { $0.id == id })
    }

    func getCompositionVersionsByCompositionID(compositionID: UUID) -> [Version] {
        guard let versions = getVersionEntities() else { return [] }
        
        let compositionVersions = versions.filter { version in
            return version.project?.id == compositionID
        }

        return compositionVersions.map { version in
            Version(id: version.id!,
                    name: version.version!)
        }
    }
    
    func createVersionWithCompositionID(name: String, compositionID: UUID, parts: [Part]) {
        guard let project = getProjectById(id: compositionID) else { return }
        
        // Setting up Version
        let version = VersionEntity(context: manager.context)
        version.id = UUID()
        version.version = name
        version.project = project
        
        // Creating Composition Parts
        let compositionParts: [PartEntity] = parts.map { part in
            let currentPart = PartEntity(context: manager.context)
            currentPart.id = UUID()
            currentPart.index = Int32(part.index)
            currentPart.version = version
            currentPart.type = part.type
            currentPart.lyric = part.lyrics
            
            return currentPart
        }

        version.parts = NSSet(array: compositionParts)
        
        manager.save()
    }

    func deleteVersionByID(versionID: UUID) {
        guard let version = getVersionEntityByID(id: versionID) else { return }
        
        manager.context.delete(version)
        manager.save()
    }
    
    // MARK: - Parts utility functions
    private func getPartEntities() -> [PartEntity]? {
        let request: NSFetchRequest<PartEntity> = PartEntity.fetchRequest()
        
        do {
            return try manager.context.fetch(request)
        } catch {
            #if DEBUG
            print("Error while retrieving parts: \(error.localizedDescription)")
            #endif
            return nil
        }
    }
    
    private func getPartByID(id: UUID) -> PartEntity? {
        guard let parts = getPartEntities() else { return nil }
        return parts.first(where: { $0.id == id })
    }
    
    func getPartsByVersionID(versionID: UUID) -> [Part] {
        guard let parts = getPartEntities() else { return [] }
        
        let versionParts = parts.filter { part in
            return part.version?.id == versionID
        }

        return versionParts.map { part in
            Part(id: part.id!,
                 index: Int(part.index),
                 type: part.type ?? "",
                 lyrics: part.lyric ?? "")
        }
    }
    
    func updateCompositionPartsByVersionID(versionID: UUID, parts: [Part]) {
        guard let version = getVersionEntityByID(id: versionID) else { return }
        
        let versionEntityParts: [PartEntity] = parts.map { part in
            let entityPart = PartEntity(context: manager.context)
            entityPart.id = part.id
            entityPart.index = Int32(part.index)
            entityPart.type = part.type
            entityPart.lyric = part.lyrics
            entityPart.version = version
            
            return entityPart
        }
        
        version.parts = NSSet(array: versionEntityParts)
        
        manager.save()
    }
    
    func updatePartByID(partID: UUID, index: Int, type: String, lyric: String) {
        guard let part = getPartByID(id: partID) else { return }

        part.index = Int32(index)
        part.type = type
        part.lyric = lyric
        
        manager.save()
    }

    func createPartByVersionID(index: Int, type: String, lyric: String, versionID: UUID) {
        guard let version = getVersionEntityByID(id: versionID) else { return }
        
        let part = PartEntity(context: manager.context)
        part.id = UUID()
        part.index = Int32(index)
        part.type = type
        part.lyric = lyric
        part.version = version
        
        manager.save()
    }
    
    func deletePartByID(partID: UUID) {
        guard let part = getPartByID(id: partID) else { return }
        
        manager.context.delete(part)
        manager.save()
    }
}
