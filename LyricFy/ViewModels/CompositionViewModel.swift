//
//  CompositionViewModel.swift
//  LyricFy
//
//  Created by Iago Ramos on 10/05/23.
//

import Foundation

class CompositionViewModel: ObservableObject {
    
    @Published private(set) var name: String = ""
    @Published private(set) var versions: [Version] = []
    @Published private(set) var parts: [Part] = []
    @Published private(set) var selectedVersionIndex = 0
    
    private let composition: Composition
    private let service = DAOService()
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
    func getVersions() -> [Version] {
        
        var versions = self.service.getCompositionVersionsByCompositionID(compositionID: self.composition.id)

        versions.sort {
            let v1 = Int($0.name.split(separator: " ").last!)!
            let v2 = Int($1.name.split(separator: " ").last!)!
            
            return v1 < v2
        }
        
        return versions
    }
    
    private func updateVersions() {
        
        self.versions = self.getVersions()
    }
    
    func createVersion() {
        
        self.service.createVersionWithCompositionID(name: "Version \(self.versions.count + 1)",
                                                    compositionID: self.composition.id,
                                                    parts: self.parts)
        
        self.updateVersions()
        self.switchVersion(to: self.versions.count - 1)
    }
    
    func deleteVersion() {
        
        let index = self.versions.firstIndex {
            $0.id == self.selectedVersionID!
        }!
        
        self.service.deleteVersionByID(versionID: self.selectedVersionID!)
        self.updateVersions()
        
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
    
    private func updateParts() {
        
        self.parts = self.getVersionParts(versionId: self.selectedVersionID!)
    }
    
    func createPart(type: String) {
        
        self.service.createPartByVersionID(index: self.parts.count,
                                           type: type,
                                           lyric: "",
                                           versionID: self.selectedVersionID!)
        
        self.updateParts()
    }
    
    func updatePart(part: Part) {
        self.service.updatePartByID(partID: part.id,
                                    index: part.index,
                                    type: part.type,
                                    lyric: part.lyrics)
        
        self.updateParts()
    }
    
    func deletePart(index: IndexPath) {
        
        self.service.deletePartByID(partID: self.parts[index.row].id)
        self.updateParts()
    }
    
    func duplicatePart(index: IndexPath) {
        
        var parts = self.getVersionParts(versionId: self.selectedVersionID!)
        parts.insert(parts[index.row], at: index.row + 1)
        
        for index in 0..<parts.count {
            parts[index].index = index
        }
        
        self.service.updateCompositionPartsByVersionID(versionID: self.selectedVersionID!, parts: parts)
        self.updateParts()
    }
    
    func dragAndDrop(from source: IndexPath, to destination: IndexPath) {
        
        var parts = self.getVersionParts(versionId: self.selectedVersionID!)
        
        let part = parts.remove(at: source.row)
        parts.insert(part, at: destination.row)
        
        for index in 0..<parts.count {
            parts[index].index = index
        }
    
        self.service.updateCompositionPartsByVersionID(versionID: self.selectedVersionID!, parts: parts)
        self.updateParts()
    }
}
