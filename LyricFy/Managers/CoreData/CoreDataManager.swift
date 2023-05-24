//
//  CoreDataManager.swift
//  LyricFy
//
//  Created by Marcos Costa on 09/05/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "LyricFy")
        container.loadPersistentStores { _, error in
            if let error = error {
                #if DEBUG
                    print("[CoreDataManager]: Error loading Core Data: \(error.localizedDescription)")
                #endif
            }
        }
        context = container.viewContext
    }
    
    func save () {
        do {
            try context.save()
            #if DEBUG
                print("[CoreDataManager]: Saved successfuly.")
            #endif
        } catch let error {
            #if DEBUG
                print("[CoreDataManager]: Error saving Core Data: \(error)")
            #endif
        }
    }
}
