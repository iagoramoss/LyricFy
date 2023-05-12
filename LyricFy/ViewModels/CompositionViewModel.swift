//
//  CompositionViewModel.swift
//  LyricFy
//
//  Created by Iago Ramos on 10/05/23.
//

import Foundation

class CompositionViewModel: ObservableObject {
    
    private let service = DAOService()
    
    @Published private(set) var name: String = ""
    @Published private(set) var versions: [Version] = []
    @Published private(set) var parts: [Part] = []
    @Published private(set) var selectedVersionIndex = 0
    
    private let projectID: UUID
    private var selectedVersionID: UUID?
    
    init(projectID: UUID) {
        self.projectID = projectID
        self.setupProject()
    }
}

// MARK: Conversão das entidades do Projeto, Versão e Parte do CoreData para seus models
extension CompositionViewModel {
    func setupProject() {
        self.name = self.service.getProjectById(id: self.projectID).name ?? "Song"
        self.versions = self.getVersions()
        
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func getVersions() -> [Version] {
        let versionsEntity = self.service.getVersionsOfProjectById(projectId: self.projectID)
        
        guard let versionsEntity = versionsEntity else {
            return []
        }
        
        var versions = versionsEntity.map { version in
            // TODO: Mudar o ID e version para não-optional
            return Version(id: version.id ?? UUID(), name: version.version ?? "version", compositionParts: self.getVersionParts(versionId: version.id ?? UUID()))
        }
        
        versions.sort {
            let v1 = Int($0.name.split(separator: " ").last!)!
            let v2 = Int($1.name.split(separator: " ").last!)!
            
            return v1 < v2
        }
        
        return versions
    }
    
    func getVersionParts(versionId: UUID) -> [Part] {
        let partsEntity = self.service.getPartsOfVersionById(versionId: versionId)
        
        guard let partsEntity = partsEntity else {
            return []
        }
        
        return partsEntity.map { part in
            // TODO: Mudar ID, type e lyric para não-optional
            return Part(id: part.id ?? UUID(), type: part.type ?? "Verse", lyrics: part.lyric ?? "")
        }
    }
}

// MARK: Version functions
extension CompositionViewModel {
    func createVersion() {
        self.service.addVersion(version: "Version \(self.versions.count + 1)",
                                project: self.service.getProjectById(id: self.projectID),
                                parts: self.service.getPartsOfVersionById(versionId: self.selectedVersionID!) ?? [])
        
        self.versions = self.getVersions()
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func deleteVersion() {
        let index = self.versions.firstIndex {
            $0.id == self.selectedVersionID!
        }!
        
        self.service.deleteVersion(version: self.service.getVersionById(id: self.selectedVersionID!))
        self.versions = self.getVersions()
        
        self.switchVersion(to: index - 1)
    }
    
    func deleteProject() {
        self.service.deleteProject(project: self.service.getProjectById(id: self.projectID))
    }
    
    func switchVersion(to version: Int) {
        self.selectedVersionID = self.versions[version].id
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
        
        self.selectedVersionIndex = self.versions.firstIndex {
            $0.id == self.selectedVersionID
        }!
    }
}

// MARK: Part functions
extension CompositionViewModel {
    func dragAndDrop(from source: IndexPath, to destination: IndexPath) {
        var parts = self.service.getPartsOfVersionById(versionId: self.selectedVersionID!)
        
        guard parts != nil else {
            return
        }
        
        let part = parts!.remove(at: source.row)
        parts!.insert(part, at: destination.row)
    
        self.service.updatePartsArray(version: self.service.getVersionById(id: self.selectedVersionID!),
                                      parts: parts!)
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func duplicatePart(index: IndexPath) {
        let part = parts[index.row]
        
        self.service.addPart(type: part.type, lyric: part.lyrics,
                             version: self.service.getVersionById(id: self.selectedVersionID!))
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func deletePart(index: IndexPath) {
        self.service.deletePart(part: self.service.getPartById(id: self.parts[index.row].id))
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
}
