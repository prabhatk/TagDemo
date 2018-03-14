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
            self.saveButton?.isEnabled = false
            
            let manager = TagDataManager.sharedInstance
            manager.updateTagName(object: self.tagData!, newName: self.textField.text!, completion: { (result: Result<Any>) in
                switch result {
                case .success( _):
                    NSLog("DB update, Success")
                case .failure(let error):
                    NSLog("DB update Failed with error \(error)")
                }
                
                DispatchQueue.main.async {
                    self.saveButton?.isEnabled = true
                    self.navigationController?.popViewController(animated: true)
                }
            })
        }
        else {
            self.errorLabel.isHidden = false
            self.saveButton?.isEnabled = true
        }
    }
}
