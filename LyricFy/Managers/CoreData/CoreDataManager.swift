//
//  CoreDataManager.swift
//  LyricFy
//
//  Created by Marcos Costa on 09/05/23.
//

import Foundation
import CoreData

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    let context: NSManagedObjectContext
    
    private init() {
        container = NSPersistentContainer(name: "LyricFy")
        container.loadPersistentStores { _, error in
            guard error == nil else {
                fatalError("Error while loading persistent store.")
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
        } catch {
            #if DEBUG
                print("[CoreDataManager]: Error saving Core Data: \(error)")
            #endif
        }
    }
}
