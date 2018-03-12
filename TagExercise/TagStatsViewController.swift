//
//  TagStatsViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import UIKit
import CoreData
import TagDataLibrary

class TagStatsViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var filterSegmentView : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!
    var isAscendingSort = false
    var addButton : UIBarButtonItem?
    var spinnerButton : UIBarButtonItem?
    var spinner : UIActivityIndicatorView?
    
    var tagDataModel:[TagData]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.tableView.register(UITableViewCell.classForKeyedUnarchiver(), forCellReuseIdentifier: "Cell")
        
        
        /*self.addButton = UIBarButtonItem(title: "x1000", style: .plain, target: self, action: #selector(makeMultipleRecords))*/
        navigationItem.rightBarButtonItem = addButton
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.spinnerButton = UIBarButtonItem(customView: self.spinner!)
        
        let manager = TagDataManager.sharedInstance
        
        manager.fetchAllTagRecord(ascending: true) { (result: Result<[TagData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                self.tagDataModel = resultSet
            case .failure(let error):
                print("\(error)")
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // filterSegmentChangeAction method will be called once user apply filter on the given data.
    @IBAction func filterSegmentChangeAction(_ sender : UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0 :
           
            isAscendingSort = !isAscendingSort
            if isAscendingSort == true {
                sender.setTitle("A-Z⥮", forSegmentAt: 0)
            }
            else {
                sender.setTitle("Z-A⥮", forSegmentAt: 0)
            }
            
            break
        case 1:
            break
        case 2:
            /*let fcr = CoreDataFetchSupportLib.changeSortDescriptor(fcr: self.fetchedResultsController, predicate: nil, sortingAttribute: "timestamp", isascending: false, delegate: nil)
            self.fetchedResultsController = fcr*/
            break
        default:
            break
        }
        /*sender.selectedSegmentIndex = -1
        do {
            self.fetchedResultsController.delegate = self
            try self.fetchedResultsController.performFetch()
            self.tableView.reloadData()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }*/
        
    }
    
   
    // MARK: - Fetched results controller
    
    /*func configureCell(_ cell: UITableViewCell, withTag tag: Tags) {
        cell.textLabel!.text = tag.tagName
    }*/
    
    
    /*var fetchedResultsController: NSFetchedResultsController<Tags> {
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Tags> = NSFetchRequest<Tags>(entityName: "Tags")
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 20
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "timestamp", ascending: false)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        // Edit the section name key path and cache name if appropriate.
        // nil for section name key path means "no sections".
        let aFetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.moc, sectionNameKeyPath: nil, cacheName: nil)
        aFetchedResultsController.delegate = self
        _fetchedResultsController = aFetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }*/
    //var _fetchedResultsController: NSFetchedResultsController<Tags>? = nil
}
/*
extension TagStatsViewController  {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
        case .delete:
            tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
        default:
            return
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            configureCell(tableView.cellForRow(at: indexPath!)!, withTag: anObject as! Tags)
        case .move:
            configureCell(tableView.cellForRow(at: indexPath!)!, withTag: anObject as! Tags)
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}*/

/*
extension TagStatsViewController : UITableViewDataSource {
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let section = fetchedResultsController.sections?.count ?? 0
        print("\n###numberOfSection \(section) - \(self.fetchedResultsController.managedObjectContext)")
        return section
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = fetchedResultsController.sections![section]
        let numberOfObjects = sectionInfo.numberOfObjects
        print("\n###numberOfObjects \(sectionInfo.numberOfObjects)")
        return numberOfObjects
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let tag = fetchedResultsController.object(at: indexPath)
        configureCell(cell, withTag: tag)
        return cell
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let context = fetchedResultsController.managedObjectContext
            context.delete(fetchedResultsController.object(at: indexPath))
            
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}*/
