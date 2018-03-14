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
        self.processInputfromTextView()
    }
    
    
    @IBAction func clearButtonAction(_ sender: Any) {
        let manager = TagDataManager.sharedInstance
        manager.clearData(completion: { (result: Result<Any>) in
            switch result {
            case .success( _):
                NSLog("DB data cleared success")
            case .failure(let error):
                NSLog("DB data Failed to clear with error \(error)")
            }
            
        })
    } 
    
    func processInputfromTextView() {
        
        // check for white spaces and new line characters
        let trimmedString = self.tagTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        
        // trimming each elements of the tag array
        let seperatedStringArray = (trimmedString.split(separator: ",")).map{$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        
        // checking
        for tag in seperatedStringArray {
            if tag.isAlphaNumeric() == false {
                NSLog("Tag :\(tag) is not alpha numeric")
                self.errorLabel.isHidden = false
                return;
            }
        }
        
        //Hide the error lable
        self.errorLabel.isHidden = true

        self.tagTextView.text = ""
        NSLog("Tags to be inserted: \(seperatedStringArray)")
        
        let manager = TagDataManager.sharedInstance
        manager.insertRecord(tagInputArray: seperatedStringArray,  completion: { (result: Result<Any>) in
            switch result {
            case .success( _):
                NSLog("DB data insert, Success")
            case .failure(let error):
                NSLog("DB data insert, Failed with error \(error)")
            }
        })
    }
}

