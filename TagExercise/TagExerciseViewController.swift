//
//  TagExerciseViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import UIKit
import  CoreData

class TagExerciseViewController: UIViewController {
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var tagTextView : UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CoreDataStack.shared.printModelName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonAction(_ sender: Any) {
        let trimmedString = self.tagTextView.text.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let seperatedStringArray = (trimmedString.split(separator: ",")).map{$0.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)}
        var isAllValidTags = true
        for tag in seperatedStringArray {
            if tag.isAlphaNumeric() == false {
                isAllValidTags = false
                break
            }
        }
        if isAllValidTags == false {
            self.errorLabel.isHidden = false
        }
        else {
            _ = seperatedStringArray.map{
                _ = saveTag(tagValue: $0)
            }
        }
        print("\(seperatedStringArray)")
        
    }
    
    func saveTag(tagValue : String) -> Bool {
        // apply check for alpha numeric values
        var saveResult = false
        if tagValue.isAlphaNumeric() {
            self.errorLabel.isHidden = true
            // save this to database
            insertNewObject(tagValue)
            saveResult = true
        }
        else {
            self.errorLabel.isHidden = false
        }
        return saveResult
    }
    
    func insertNewObject(_ tagValue: String) {
        let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
        let tag = Tags(context: context)
        tag.tagName = tagValue
        // Save the context.
        if context.hasChanges {
            do {
                print("item to be insert\n \(context.insertedObjects) and contextAddress \(context)")
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension TagExerciseViewController : UITextViewDelegate {
    
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.saveTag(tagValue: self.tagTextView.text!) == false {
            // show alert
        }
        return true
    }
}
