//
//  CoreDataStack.swift
//  MyMusic
//
//  Created by Ismayil Ismayilov on 02.10.22.
//

import Foundation
import CoreData

class CoreDataStack {
    
    private let modelName: String
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.storeContainer.viewContext
    }()
    
    init(modelName: String) {
        self.modelName = modelName
    }
    
    private lazy var storeContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: self.modelName)
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                print("Unsolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    
    func saveContext() {
        guard self.managedContext.hasChanges else { return }
        do {
            try self.managedContext.save()
        } catch let error as NSError {
            print("Unsolved error \(error), \(error.userInfo)")
        }
    }
}
