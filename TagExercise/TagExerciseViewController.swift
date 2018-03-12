//
//  TagExerciseViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import UIKit
import  CoreData
import TagDataLibrary


class TagExerciseViewController: UIViewController {
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var tagTextView : UITextView!
    
    var tagDataModel:[TagData]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        // check for white spaces and new line characters
        let trimmedString = self.tagTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        // trimming each elements of the tag array
        let seperatedStringArray = (trimmedString.split(separator: ",")).map{$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        // flag to check if all valid string in set oterwise will not perfrom database operation
        var isAllValidTags = true
        // checking
        for tag in seperatedStringArray {
            if tag.isAlphaNumeric() == false {
                isAllValidTags = false
                break
            }
        }
       
        // if falg is false there than error will be shown
        if isAllValidTags == false {
            self.errorLabel.isHidden = false
        }
        
        print("\(seperatedStringArray)")
        //printFetchDataFromMOC(moc: CoreDataStack.shared.moc)
        
        let manager = TagDataManager.sharedInstance
        
        /*manager.insertRecord(tagInputArray: ["hello", "hi"],  completion: { (result: Result<Any>) in
            switch result {
            case .success( _):
                NSLog("success")
            case .failure(let error):
                NSLog("\(error)")
            }
        })*/
        
        NSLog("Fetch Data")
        manager.fetchAllTagRecord(ascending: true) { (result: Result<[TagData]>) in
            switch result {
            case .success(let resultSet):
                let itemCount = resultSet.count
                //NSLog("success %@", itemCount)
                NSLog("Success")
                self.tagDataModel = resultSet
            case .failure(let error):
                print("\(error)")
            }
        }
        
        
        /*manager.createDuplicateRecord(count: 100000, completion: { (result: Result<Any>) in
            switch result {
            case .success:
                NSLog("Success Insert")
            case .failure(let error):
                print("\(error)")
            }
        })*/
        
        
            
        
    }
}

