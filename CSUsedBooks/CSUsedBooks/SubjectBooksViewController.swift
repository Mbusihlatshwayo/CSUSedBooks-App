//
//  SubjectBooksViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/23/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class SubjectBooksViewController: UIViewController {

    
    @IBOutlet var navigationBarTitle: UINavigationBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBarTitle.topItem?.title = "\(selectedCourse)"
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 3
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    /*
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell {
        
        //var cell: bookCell = self.tableView.dequeueReusableCellWithIdentifier("cell1") as bookCell
        var cell: bookCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "")
        return cell
    }
    */

}
