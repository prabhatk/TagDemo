//
//  EditTagViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 14/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import Foundation
import UIKit
import TagDataLibrary

class EditTagViewController : UIViewController {
    
    var tagData : TagData? = nil
    @IBOutlet weak var textField : UITextField!
    @IBOutlet weak var errorLabel : UILabel!
    var saveButton : UIBarButtonItem? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.saveButton = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveRecords))
        navigationItem.rightBarButtonItem = self.saveButton
        
        if self.tagData == nil {
            self.saveButton?.isEnabled = false
        }
        else {
            self.textField.text = tagData?.name
        }
        self.title = "Edit Tag"
    }
    @objc
    func saveRecords() {
        if self.textField.text?.isAlphaNumeric() == true {
            self.errorLabel.isHidden = true
            // if data saved successfully
            self.tagData = nil
            self.textField.text = ""
            self.saveButton?.isEnabled = false
            //self.navigationController?.popViewController(animated: true)
            // we can also do
            //endif
            
        }
        else {
            self.errorLabel.isHidden = false
            self.saveButton?.isEnabled = true
        }
    }
}
