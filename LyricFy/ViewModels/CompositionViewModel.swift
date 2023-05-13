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
    
    private var composition: Composition?
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
        self.composition = self.service.getCompositionByID(id: self.projectID)
        
        self.name = self.composition!.name
        self.versions = self.getVersions()
        
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func getVersions() -> [Version] {
        
        var versions = self.service.getCompositionVersionsByCompositionID(compositionID: self.projectID)

        versions.sort {
            let v1 = Int($0.name.split(separator: " ").last!)!
            let v2 = Int($1.name.split(separator: " ").last!)!
            
            return v1 < v2
        }
        
        return versions
    }
    
    func getVersionParts(versionId: UUID) -> [Part] {
        // TODO: adicionar o index no Core Data e fazer o sort
        return self.service.getPartsByVersionID(versionID: self.selectedVersionID!)
    }
}

// MARK: Version functions
extension CompositionViewModel {
    func createVersion() {
        self.service.createVersionWithCompositionID(name: "Version \(self.versions.count + 1)",
                                                    compositionID: self.projectID,
                                                    parts: self.parts)
        
        self.versions = self.getVersions()
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func deleteVersion() {
        let index = self.versions.firstIndex {
            $0.id == self.selectedVersionID!
        }!
        
        self.service.deleteVersionByID(versionID: self.selectedVersionID!)
        self.versions = self.getVersions()
        
        self.switchVersion(to: index - 1)
    }
    
    func deleteProject() {
        self.service.deleteCompositionByID(compositionID: self.projectID)
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
        var parts = self.service.getPartsByVersionID(versionID: self.selectedVersionID!)
        
        let part = parts.remove(at: source.row)
        parts.insert(part, at: destination.row)
    
        self.service.updateCompositionPartsByVersionID(versionID: self.selectedVersionID!,
                                                       parts: parts)
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func savePart(part: Part) {
        let isNewPart = self.parts.filter {
            return part.id == $0.id
        }.isEmpty
        
        if isNewPart {
            self.service.createPartByVersionID(type: part.type,
                                               lyric: part.lyrics,
                                               versionID: self.selectedVersionID!)
        } else {
            self.service.updatePartByID(partID: part.id,
                                        type: part.type,
                                        lyric: part.lyrics)
        }
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func duplicatePart(index: IndexPath) {
        let part = parts[index.row]
        
        self.service.createPartByVersionID(type: part.type,
                                           lyric: part.lyrics,
                                           versionID: self.selectedVersionID!)
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func deletePart(index: IndexPath) {
        self.service.deletePartByID(partID: self.parts[index.row].id)
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
}
