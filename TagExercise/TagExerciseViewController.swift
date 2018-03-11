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
        }//if every thing is correct we will do database oepration.
        else {
            _ = seperatedStringArray.map{
                _ = saveTag(tagValue: $0)
            }
            self.errorLabel.isHidden = true
            self.tagTextView.text = ""
        }
        print("\(seperatedStringArray)")
        //printFetchDataFromMOC(moc: CoreDataStack.shared.moc)
    }
//    func printFetchDataFromMOC(moc : NSManagedObjectContext) {
//        let fetchRequest = NSFetchRequest<Tags>(entityName: "Tags")
//        let sortDescriptor = NSSortDescriptor(key: "tagName", ascending: false)
//
//        fetchRequest.sortDescriptors = [sortDescriptor]
//        do {
//            let result : [Tags] = try CoreDataStack.shared.moc.fetch(fetchRequest) as! [Tags]
//            print("\(result)")
//            result.map{print("\($0.tagName)")}
//        } catch let error as NSError {
//            print("Could not fetch \(error), \(error.userInfo)")
//        }
//    }
    func saveTag(tagValue : String)  {
        insertNewObject(tagValue)
    }
    
    func insertNewObject(_ tagValue: String) {
        let context = CoreDataStack.shared.persistentContainer.newBackgroundContext()
        let tag = Tags(context: context)
        tag.tagName = tagValue
        tag.timestamp = Date()
        // Save the context.
        if context.hasChanges {
            do {
                print("item to be insert\n \(context.insertedObjects) and contextAddress \(context)")
                try context.save()
                CoreDataStack.shared.saveContext()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

