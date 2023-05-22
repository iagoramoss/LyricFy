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
    @Published private(set) var selectedVersionName = ""
    
    private let composition: Composition
    private let service = DAOService()
    private var selectedVersionID: UUID?
    private var lastVersion = 0
    
    init(composition: Composition) {
        self.composition = composition
        self.setupComposition()
    }
    
    func setupComposition() {
        name = composition.name
        versions = getVersions()
        
        switchVersion(to: versions.count - 1)
    }
}

extension CompositionViewModel {
    
    // MARK: - Version functions
    func getVersions() -> [Version] {
        var versions = service.getCompositionVersionsByCompositionID(compositionID: composition.id)
        
        versions.sort {
            let v1 = Int($0.name.split(separator: " ").last!)!
            let v2 = Int($1.name.split(separator: " ").last!)!
            
            return v1 < v2
        }
        
        lastVersion = Int(versions.last!.name.split(separator: " ").last!)!
        
        return versions
    }
    
    private func updateVersions() {
        versions = getVersions()
    }
    
    func createVersion() {
        service.createVersionWithCompositionID(name: "Version \(lastVersion + 1)",
                                               compositionID: composition.id,
                                               parts: parts)
        
        updateVersions()
        switchVersion(to: versions.count - 1)
    }
    
    func deleteVersion() {
        service.deleteVersionByID(versionID: selectedVersionID!)
        updateVersions()
        
        switchVersion(to: max(selectedVersionIndex - 1, 0))
    }
    
    func deleteProject() {
        service.deleteCompositionByID(compositionID: composition.id)
    }
    
    func switchVersion(to version: Int) {
        selectedVersionIndex = version
        selectedVersionID = versions[version].id
        selectedVersionName = versions[version].name
        
        updateParts()
    }
    
    // MARK: - Part functions
    func getVersionParts(versionId: UUID) -> [Part] {
        var parts = service.getPartsByVersionID(versionID: selectedVersionID!)
        
        parts.sort {
            return $0.index < $1.index
        }
        
        return parts
    }
    
    private func updateParts() {
        parts = getVersionParts(versionId: selectedVersionID!)
    }
    
    func createPart(type: String) {
        service.createPartByVersionID(index: parts.count,
                                      type: type,
                                      lyric: "",
                                      audioURL: nil,
                                      versionID: selectedVersionID!)
        
        updateParts()
    }
    
    func updatePart(part: Part) {
        service.updatePartByID(partID: part.id,
                               index: part.index,
                               type: part.type,
                               lyric: part.lyrics,
                               audioURL: nil)
        
        updateParts()
    }
    
    func deletePart(index: IndexPath) {
        service.deletePartByID(partID: parts[index.row].id)
        updateParts()
    }
    
    func duplicatePart(index: IndexPath) {
        var parts = getVersionParts(versionId: selectedVersionID!)
        
        var newPart = parts[index.row]
        newPart.id = UUID()
        
        parts.insert(newPart, at: index.row + 1)
        
        for index in 0..<parts.count {
            parts[index].index = index
        }
        
        service.updateCompositionPartsByVersionID(versionID: selectedVersionID!, parts: parts)
        updateParts()
    }
    
    func dragAndDrop(from source: IndexPath, to destination: IndexPath) {
        var parts = getVersionParts(versionId: selectedVersionID!)
        
        let part = parts.remove(at: source.row)
        parts.insert(part, at: destination.row)
        
        for index in 0..<parts.count {
            parts[index].index = index
        }
        
        service.updateCompositionPartsByVersionID(versionID: selectedVersionID!, parts: parts)
        updateParts()
    }
}
