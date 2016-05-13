//
//  TableViewController.swift
//  On The Map
//
//  Created by Campbell Moss on 1/05/16.
//  Copyright © 2016 Campbell Moss. All rights reserved.
//

import UIKit

class TableViewController: BaseViewController {
    
    var studentInformationData = Model.sharedInstance().studentInformationData!
    
    @IBOutlet weak var studentTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        studentTableView.reloadData()
    }

}

// MARK: - TableViewController: UITableViewDelegate, UITableViewDataSource

extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get cell type */
        let cellReuseIdentifier = "StudentInformationTableViewCell"
        let student = studentInformationData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as UITableViewCell!
        
        /* Set cell defaults */
        cell.textLabel!.text = "\(student.firstName) \(student.lastName)"
        //cell.imageView!.image = UIImage(named: "Film")
        //cell.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return studentInformationData.count
    }
}
