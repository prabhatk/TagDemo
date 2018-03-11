//
//  CoreDataFetchSupportLib.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 3/11/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataFetchSupportLib : NSObject {
    
    static func getFetchResultController<T>( moc : NSManagedObjectContext, predicate : NSPredicate?, entityName : String, sortingAttribute : String , isascending : Bool, delegate : NSFetchedResultsControllerDelegate?) -> NSFetchedResultsController<T> {
        
        let fetchRequest: NSFetchRequest<T> = NSFetchRequest<T>(entityName: entityName)
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: sortingAttribute, ascending: isascending)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        
        let fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: moc, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = delegate
        
        return fetchResultController
    }
    static func changeSortDescriptor<T>( fcr : NSFetchedResultsController<T>, predicate : NSPredicate?, sortingAttribute : String , isascending : Bool, delegate : NSFetchedResultsControllerDelegate?) -> NSFetchedResultsController<T> {
        
        let sortDescriptor = NSSortDescriptor(key: sortingAttribute, ascending: isascending)
        
        fcr.fetchRequest.sortDescriptors = [sortDescriptor]
        
        return fcr
    }
}
