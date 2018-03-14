//
//  TagCoreDataStack.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation
import CoreData

public enum Result<T>{
    case success(T)
    case failure(Error)
}

extension NSNotification.Name {
    public static let TagContextObjectsDidChange = Notification.Name("TagContextObjectsDidChange")
}

//NotificationCenter.default.post(name:NSNotification.Name(rawValue: "YourMojiManagerNotification"), object: nil)

public class TagDataManager: NSObject {
    
    @objc public dynamic var totalrecordsFetched: Int = 0
    
    private var isDataReadyforRead = false {
        willSet(incomingStatus){
            print("About to set status to: \(incomingStatus)")
        }
        
        didSet(previousStatus) {
            if isDataReadyforRead == true {
                NotificationCenter.default.post(name:NSNotification.Name.TagContextObjectsDidChange, object: nil)
            }
        }
    }
    
    private let coreDataStack = TagCoreDataStack();
    
    /**
     To initialize a singleton object of this class.
     
     -return
     An initialized singleton object, or existing object.
     */
    
    public class var sharedInstance: TagDataManager {
        struct Singelton  {
            static var instance = TagDataManager()
        }
        return Singelton.instance
    }
    
    
    private override init() {
        super.init()
    }
    
    /**
     Fetch all the records from DB.
     
     -Parameters
     -Bool: property to be compared and the order of the sort (ascending or descending).
     
     -return
     Returns a persistent store result or error
     */
    
    public func fetchAllTagRecord(ascending: Bool = false, completion: @escaping (Result<[TagData]>) -> Void) {
        
        // Get the foreground task(MainQueue context)
        coreDataStack.performForegroundTask { context in
            
            // Create Progress
            let progress = Progress(totalUnitCount: 1)
            
            // Become Current
            progress.becomeCurrent(withPendingUnitCount: 1)
            
            do {
                // Create a fetchrequest for TagData
                let fetchRequest: NSFetchRequest<TagData> = TagData.fetchRequest()
                
                // Set the sort descriptor for the tag Name attribute
                let sortDescriptor = NSSortDescriptor(key: "name", ascending: ascending)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                fetchRequest.returnsObjectsAsFaults = false
                
                //intialize the async fetrequest & return the completion block
                let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest:fetchRequest, completionBlock: { (results: NSAsynchronousFetchResult) in
                    
                    if let asynchronousFetchProgress = results.progress {
                        // Remove Observer
                        asynchronousFetchProgress.removeObserver(self, forKeyPath: "completedUnitCount")
                        asynchronousFetchProgress.removeObserver(self, forKeyPath: "totalUnitCount")
                    }
                    
                    let items: [TagData] = results.finalResult!
                    completion(.success(items))
                })
                
                // execute the fetch request
                let asynchronousFetchResult = try context.execute(asynchronousFetchRequest) as! NSPersistentStoreAsynchronousResult
                
                // Add Observer
                if let asynchronousFetchProgress = asynchronousFetchResult.progress {
                    asynchronousFetchProgress.addObserver(self, forKeyPath: "completedUnitCount", options: NSKeyValueObservingOptions.new, context: nil)
                    
                    asynchronousFetchProgress.addObserver(self, forKeyPath: "totalUnitCount", options: NSKeyValueObservingOptions.new, context: nil)
                }
                
                
                // Resign Current
                progress.resignCurrent()
                
            } catch {
                // Report Error
                completion(.failure(error))
            }
        }
    }
    
    /**
     Fetch all the unique records from DB.
     
     - return
     Returns a persistent store result or error
     */
    public func fetchAllUniqueTagReocrd(completion: @escaping (Result<[TagMetaData]>) -> Void) {
        
        // Get the foreground task(MainQueue context)
        coreDataStack.performForegroundTask { context in
            do {
                // Create a fetchrequest for TagData
                let fetchRequest: NSFetchRequest<TagMetaData> = TagMetaData.fetchRequest()
                
                // Set the sort descriptor for the count attribute
                let sortDescriptor = NSSortDescriptor(key: "count", ascending: false)
                fetchRequest.sortDescriptors = [sortDescriptor]
                
                // indicates whether the objects resulting from a fetch request are faults
                fetchRequest.returnsObjectsAsFaults = false
                
                //intialize the async fetrequest & return the completion block
                let asynchronousFetchRequest = NSAsynchronousFetchRequest(fetchRequest:fetchRequest, completionBlock: {  (results: NSAsynchronousFetchResult) in
                    let items : [TagMetaData] = results.finalResult!
                    completion(.success(items))
                })
                // execute the fetch request
                _ = try context.execute(asynchronousFetchRequest)
            } catch {
                // report failure
                completion(.failure(error))
            }
        }
    }
    
    /**
     Insert new record to DB.
     
     -Parameters
     -[String]: Array of String.
     
     - return
     Returns a success or error
     */
    
    public func insertRecord(tagInputArray: [String], completion: @escaping (Result<Any>) -> Void) {
        
        // Get the background task(PrivateQueue context)
        coreDataStack.performBackgroundTask { context in
            
            // Loop thru tagInputArray
            for index in 0 ..< tagInputArray.count {
                
                // Create a new tag data record & set the value for name
                let newTagData = TagData(context: context)
                newTagData.name = tagInputArray[index]
                
                // Create a fetch request for TagMetaData entiry
                let fetchRequest: NSFetchRequest<TagMetaData> = TagMetaData.fetchRequest()
                
                // Create a predicate to check duplicates
                let predicate = NSPredicate(format: "name == %@", tagInputArray[index])
                fetchRequest.predicate = predicate
                
                do {
                    // execute the fetch request
                    let result = try context.fetch(fetchRequest)
                    if result.count == 0 {
                        // If no result found create a new object
                        let newTagMetaData = TagMetaData(context: context)
                        newTagMetaData.name = tagInputArray[index]
                        newTagMetaData.count = 1
                        
                        // Create a relationship (1 to many) with TagMetaData with TagData
                        newTagMetaData.mutableSetValue(forKey: "tagDataRelationship").add(newTagData)
                    } else {
                        // If the tag exists in DB update the count
                        let exsistingTagMetaData : TagMetaData = (result.last)!
                        exsistingTagMetaData.count += 1
                        
                        // Create a relationship (1 to many) with TagMetaData with TagData
                        exsistingTagMetaData.mutableSetValue(forKey: "tagDataRelationship").add(newTagData)
                    }
                } catch {
                    // report failure
                    completion(.failure(error))
                }
            }
            
            do {
                // Try saving contect
                try context.save()
                self.isDataReadyforRead = true
                completion(.success("Success"))
            } catch {
                //report error
                completion(.failure(error))
            }
        }
    }
    
    /**
     Creates Duplicates records.
     
     -Parameters
     -Int: Number of times that records get duplicates.
     
     - return
     Returns a success or error
     */
    public func createDuplicateRecordwithOperationQueue(count: Int32, completion: @escaping (Result<Any>) -> Void) {
        
    }
    
    public func createDuplicateRecord(count: Int32, completion: @escaping (Result<Any>) -> Void) {
        
        // Get the background task(PrivateQueue context)
        coreDataStack.performBackgroundTask { context in
            
            // Create fetchRequest TagMetaData, To get list of existing tags
            let fetchRequest: NSFetchRequest<TagMetaData> = TagMetaData.fetchRequest()
            
            var result: [TagMetaData]?
            do {
                // excute fetch
                result = try context.fetch(fetchRequest)
            } catch {
                completion(.failure(error))
            }
            
            if let result = result {
                for i in 0 ..< result.count {
                    let tagMetaData = result[i] as TagMetaData
                    for _ in 0 ..< count {
                        // Create new tag Data
                        let newTagData = TagData(context: context)
                        newTagData.name = tagMetaData.name
                        
                        // Create the relationship
                        tagMetaData.mutableSetValue(forKey: "tagDataRelationship").add(newTagData)
                    }
                    
                    // Update tagMetaData counter for that record
                    tagMetaData.count += count
                }
            }
            
            do {
                // try saving contect
                try context.save()
                self.isDataReadyforRead = true
                completion(.success("Success"))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    // Key Value observer for aync fetch progress 
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "completedUnitCount" {
            if let recordFetched = change?[.newKey] {
                self.totalrecordsFetched = recordFetched as! Int
                print("Fetched \(recordFetched) Records")
            }
        } else if keyPath == "totalUnitCount" {
            if let number = change?[.newKey] {
                print("Total \(number) Records")
            }
        }
    }
}

