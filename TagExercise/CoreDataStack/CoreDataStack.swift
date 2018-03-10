//
//  CoreDataStack.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack : NSObject {

    static let shared = CoreDataStack(modelName : "TagExercise")
    
    fileprivate let modelName : String
    // MARK: - Core Data stack
    private init(modelName : String) {
        self.modelName = modelName
    }
    func printModelName() {
        print ("model name is \(self.modelName)")
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: self.modelName)//"TagExercise"
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var viewContext : NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}