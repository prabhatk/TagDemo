//
//  TagStatsViewController.swift
//  TagExercise
//
//  Created by Prabhat Kasera on 10/03/18.
//  Copyright © 2018 Prabhat Kasera. All rights reserved.
//

import UIKit

class TagStatsViewController: UIViewController {
    @IBOutlet weak var filterSegmentView : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        CoreDataStack.shared.printModelName()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // filterSegmentChangeAction method will be called once user apply filter on the given data.
    @IBAction func filterSegmentChangeAction(_ sender : UISegmentedControl) {
        
    }
    
}

extension TagStatsViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        //TODO : will fetch data from the database so will replace the section value
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //TODO : will change the number from the database
        return 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        return cell
    }
}
