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
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.TagContextObjectsDidChange, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        let manager = TagDataManager.sharedInstance
        
       self.addButton = UIBarButtonItem(title: "x1000", style: .plain, target: self, action: #selector(createDuplicateRecords))
        navigationItem.rightBarButtonItem = addButton
       
        observer = manager.observe(\.totalrecordsFetched, options: [.new]) { [weak self] object, change in
            if let value = change.newValue {
                DispatchQueue.main.async {
                    self?.navigationItem.title = "\(value)"
                }
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableView), name: NSNotification.Name.TagContextObjectsDidChange, object: nil)
        
       self.refreshTableViewOrderBy(ascendingOrder: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc
    func createDuplicateRecords() {
        let manager = TagDataManager.sharedInstance
        manager.createDuplicateRecord(count: 1000, completion: { (result: Result<Any>) in
            switch result {
            case .success:
                NSLog("Success Insert")
            case .failure(let error):
                print("\(error)")
            }
        })
    }
    
    
    // filterSegmentChangeAction method will be called once user apply filter on the given data.
    @IBAction func filterSegmentChangeAction(_ sender : UISegmentedControl) {
        self.selectedIndex = sender.selectedSegmentIndex
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
        
        manager.fetchAllTagRecord(ascending: ascendingOrder) { (result: Result<[TagData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                self.tagDataModel = resultSet as [TagData]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "\(itemCount)"
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    func refreshTableViewOrderByFrequency() {
        let manager = TagDataManager.sharedInstance
        
        manager.fetchAllUniqueTagReocrd (){ (result: Result<[TagMetaData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                self.tagMetaDataModel = resultSet as [TagMetaData]
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    self.navigationItem.title = "\(itemCount)"
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    
    // MARK: - Fetched results controller
    
    //    func configureCell(_ cell: UITableViewCell, withTag tag: TagData) {
    //        cell.textLabel!.text = tag.name!
    //
    //    }
    
}



extension TagStatsViewController : UITableViewDataSource {
    // MARK: - Table View
    
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
