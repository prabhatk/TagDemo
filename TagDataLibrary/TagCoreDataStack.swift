//
//  TagCoreDataStack.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation
import CoreData

protocol TagCoreDataStackProtocol:class {
    var errorHandler: (Error) -> Void {get set}
    var persistentContainer: NSPersistentContainer {get}
    var viewContext: NSManagedObjectContext {get}
    var backgroundContext: NSManagedObjectContext {get}
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void)
}

final class TagCoreDataStack: TagCoreDataStackProtocol {
    
    // An instance of TagCoreDataStack represent a functioning Core Data stack, and provides convenience methods and properties.
    static let shared = TagCoreDataStack()
    var errorHandler: (Error) -> Void = {_ in }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        // DataModel Name
        let momdName = "TagDataModel" //pass this as a parameter
        
        //Url for the Model
        guard let modelURL = Bundle(for: type(of: self)).url(forResource: momdName, withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        
        //load manged object model
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let container  = NSPersistentContainer(name: momdName, managedObjectModel: mom)
        container.loadPersistentStores(completionHandler: { [weak self](storeDescription, error) in
            if let error = error {
                TagDataLogger.log(message:"CoreData error \(error), \(String(describing: error._userInfo))")
                self?.errorHandler(error)
            }
        })
        return container
    }()
    
    lazy var viewContext: NSManagedObjectContext = {
        let context:NSManagedObjectContext = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        return context
    }()
    
    lazy var backgroundContext: NSManagedObjectContext = {
        return self.persistentContainer.newBackgroundContext()
    }()
    
    func performForegroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.viewContext.perform {
            block(self.viewContext)
        }
    }
    
    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        self.persistentContainer.performBackgroundTask(block)
    }
}
