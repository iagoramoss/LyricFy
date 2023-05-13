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
    
    private let composition: Composition
    private var selectedVersionID: UUID?
    
    init(composition: Composition) {
        self.composition = composition
        self.setupComposition()
    }
    
    func setupComposition() {
        self.name = self.composition.name
        self.versions = self.getVersions()
        
        self.switchVersion(to: self.versions.count - 1)
    }
}

extension CompositionViewModel {
    
    // MARK: - Version functions
    func createVersion() {
        self.service.createVersionWithCompositionID(name: "Version \(self.versions.count + 1)",
                                                    compositionID: self.composition.id,
                                                    parts: self.parts)
        
        self.versions = self.getVersions()
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func getVersions() -> [Version] {
        
        var versions = self.service.getCompositionVersionsByCompositionID(compositionID: self.composition.id)

        versions.sort {
            let v1 = Int($0.name.split(separator: " ").last!)!
            let v2 = Int($1.name.split(separator: " ").last!)!
            
            return v1 < v2
        }
        
        return versions
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
        self.service.deleteCompositionByID(compositionID: self.composition.id)
    }
    
    func switchVersion(to version: Int) {
        self.selectedVersionID = self.versions[version].id
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
        
        self.selectedVersionIndex = self.versions.firstIndex {
            $0.id == self.selectedVersionID
        }!
    }
    
    // MARK: - Part functions
    func getVersionParts(versionId: UUID) -> [Part] {
        var parts = self.service.getPartsByVersionID(versionID: self.selectedVersionID!)
        
        parts.sort {
            return $0.index < $1.index
        }
        
        return parts
    }
    
    func savePart(part: Part) {
        let isNewPart = self.parts.filter {
            return part.id == $0.id
        }.isEmpty
        
        if isNewPart {
            self.service.createPartByVersionID(index: part.index,
                                               type: part.type,
                                               lyric: part.lyrics,
                                               versionID: self.selectedVersionID!)
        } else {
            self.service.updatePartByID(partID: part.id,
                                        index: part.index,
                                        type: part.type,
                                        lyric: part.lyrics)
        }
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func deletePart(index: IndexPath) {
        self.service.deletePartByID(partID: self.parts[index.row].id)
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func duplicatePart(index: IndexPath) {
        let part = parts[index.row]
        
        self.service.createPartByVersionID(index: self.parts.count,
                                           type: part.type,
                                           lyric: part.lyrics,
                                           versionID: self.selectedVersionID!)
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func dragAndDrop(from source: IndexPath, to destination: IndexPath) {
        var parts = self.getVersionParts(versionId: self.selectedVersionID!)
        
        let part = parts.remove(at: source.row)
        parts.insert(part, at: destination.row)
        
        for index in 0..<parts.count {
            parts[index].index = index
        }
    
        self.service.updateCompositionPartsByVersionID(versionID: self.selectedVersionID!,
                                                       parts: parts)
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
}
