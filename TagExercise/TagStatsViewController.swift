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

struct myConstants {
    static let numberoftimestoduplicate = 1000
}

class TagStatsViewController: UIViewController {
    
    @IBOutlet weak var filterSegmentView : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!
        
    var isAscendingSort = true
    var selectedIndex = 0
    var addButton : UIBarButtonItem?
    
    var tagDataModel:[TagData]? = nil
    var tagMetaDataModel:[TagMetaData]? = nil
    var observer: NSKeyValueObservation?
    
    
    
    deinit {
        // remember to remove it when this object is deallocated
        NSLog("Removed observer for the db context change")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.TagContextObjectsDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let manager = TagDataManager.sharedInstance
        
        self.addButton = UIBarButtonItem(title: "\(myConstants.numberoftimestoduplicate)x", style: .plain, target: self, action: #selector(createDuplicateRecords))
        navigationItem.rightBarButtonItem = addButton
        
        NSLog("Added observer for keypath of Records Fetched")
        observer = manager.observe(\.totalrecordsFetched, options: [.new]) { [weak self] object, change in
            if let value = change.newValue {
                DispatchQueue.main.async {
                    self?.navigationItem.title = "\(value)"
                }
            }
        }
        
        NSLog("Added observer for the db context change")
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name.TagContextObjectsDidChange, object: nil)
        
        NSLog("Loading all tags sort based on ascending")
        self.refreshTableViewOrderBy(ascendingOrder: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func createDuplicateRecords() {
        NSLog("Duplicated the unique record by \(myConstants.numberoftimestoduplicate)x)")
        let manager = TagDataManager.sharedInstance
        manager.createDuplicateRecord(count: Int32(myConstants.numberoftimestoduplicate), completion: { (result: Result<Any>) in
            switch result {
            case .success:
                NSLog("Success, Duplicated records created")
            case .failure(let error):
                NSLog("Failed, with error: \(error)")
            }
        })
    }
    
    
    // filterSegmentChangeAction method will be called once user apply filter on the given data.
    @IBAction func filterSegmentChangeAction(_ sender : UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
        NSLog("Selected segmented index: \(self.selectedIndex )")
        switch self.selectedIndex {
        case 0 :
            isAscendingSort = !isAscendingSort
            if isAscendingSort == true {
                sender.setTitle("A-Z⥮", forSegmentAt: 0)
                self.refreshTableViewOrderBy(ascendingOrder: true)
            }
            else {
                sender.setTitle("Z-A⥮", forSegmentAt: 0)
                self.refreshTableViewOrderBy(ascendingOrder: false)
            }
            break
        case 1:
             self.refreshTableViewOrderByFrequency()
            break
        default:
            break
        }
        sender.selectedSegmentIndex = -1
    }
    
    @objc func reloadTableView() {
        switch self.selectedIndex {
        case 0 :
            self.refreshTableViewOrderBy(ascendingOrder: isAscendingSort)
            break
        case 1:
            self.refreshTableViewOrderByFrequency()
            break
        default:
            break
        }
    }
    
    func refreshTableViewOrderBy (ascendingOrder: Bool) {
        
        let manager = TagDataManager.sharedInstance
        NSLog("Fetch all record based on order ascending: \(ascendingOrder)")
        manager.fetchAllTagRecord(ascending: ascendingOrder) { (result: Result<[TagData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                self.tagDataModel = resultSet as [TagData]
                NSLog("All  record fetched - count: \(itemCount)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "\(itemCount)"
                }
            case .failure(let error):
                NSLog("Failed to fetch the record with error: \(error)")
            }
        }
    }
    
    
    func refreshTableViewOrderByFrequency() {
        
        let manager = TagDataManager.sharedInstance
        NSLog("Fetch all unique tag record based on usage frequency")
        manager.fetchAllUniqueTagReocrd (){ (result: Result<[TagMetaData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                self.tagMetaDataModel = resultSet as [TagMetaData]
                NSLog("All  record fetched - count: \(itemCount)")
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "\(itemCount)"
                }
            case .failure(let error):
                NSLog("Failed to fetch the record with error: \(error)")
            }
        }
    }
}


extension TagStatsViewController : UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.selectedIndex {
        case 0 :
            return (self.tagDataModel?.count) ?? 0
        case 1:
            return (self.tagMetaDataModel?.count) ?? 0
        case 2:
            break
        default:
            break
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        switch self.selectedIndex {
        case 0 :
            let tagData = self.tagDataModel![indexPath.row]
            cell.textLabel!.text = tagData.name!
            cell.detailTextLabel?.text = ""
            break
        case 1:
            let tagMetaData = self.tagMetaDataModel![indexPath.row]
            cell.textLabel!.text =  "TagName:\(tagMetaData.name!)"
            cell.detailTextLabel?.text = "Count:\(tagMetaData.count)"
            break
        case 2:
            break
        default:
            break
        }
        return cell
    }
}


extension TagStatsViewController : UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "EditSegue", sender: self.tagDataModel?[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier  == "EditSegue" {
            let destinationVC = segue.destination as! EditTagViewController
            destinationVC.tagData = sender as? TagData
        }
    }
}
