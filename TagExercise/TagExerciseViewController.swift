//
//  TagExerciseViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import UIKit

class TagExerciseViewController: UIViewController {
    @IBOutlet weak var errorLabel : UILabel!
    @IBOutlet weak var tagTextField : UITextField!
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
        if self.saveTag(tagValue: self.tagTextField.text!) == false {
            // show alert
        }
    }
    
}

extension TagExerciseViewController : UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.saveTag(tagValue: self.tagTextField.text!) == false {
            // show alert
        }
        return true
    }
    
    func saveTag(tagValue : String) -> Bool {
        // apply check for alpha numeric values
        var saveResult = false
        if tagValue.isAlphaNumeric() {
            self.errorLabel.isHidden = true
            // save this to database
            saveResult = true
        }
        else {
            self.errorLabel.isHidden = false
        }
        return saveResult
    }
}
