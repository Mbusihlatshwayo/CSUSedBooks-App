//
//  SubjectsViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/24/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

var selectedIndex: Int = Int()

var linkedIdArr = [String]()

class SubjectsViewController: UIViewController {

    @IBOutlet var myTableView: UITableView!
    
    @IBOutlet var noBooksLabel: UILabel!
    
    @IBOutlet var navigationBarTitle: UINavigationBar!
    
    override func viewWillAppear(animated: Bool) {
        
        self.noBooksLabel.hidden = true
        
    }
    
    @IBAction func backToListingsViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptions.removeAll(keepCapacity: true)
        usernames.removeAll(keepCapacity: true)
        imageFiles.removeAll(keepCapacity: true)
        realUsernames.removeAll(keepCapacity: true)
        linkedIdArr.removeAll(keepCapacity: true)
        realFromUsernames.removeAll(keepCapacity: true) //
        
        self.navigationBarTitle.topItem?.title = "\(selectedSubject)"
        
        pickedSubject = selectedSubject
        
        self.navigationBarTitle.topItem?.title = "\(selectedSubject)"
        
        var subjectQuery = PFQuery(className: "BookPosting")
        
        subjectQuery.whereKey("CourseSubject", equalTo: pickedSubject)
        subjectQuery.findObjectsInBackgroundWithBlock {
            
            (objects, error) -> Void in
            
            if error == nil {
                
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                        
                        descriptions.append(object["Description"] as! String)
                        
                        usernames.append(object["username"] as! String)
                        
                        imageFiles.append(object["imageFile"] as! PFFile)
                        
                        realUsernames.append(object["realUsername"] as! String)
                        
                        linkedIdArr.append(object.objectId! as String)
                        
                        realFromUsernames.append(object["realUsername"] as! String) //
                        
                        self.myTableView.reloadData()
                        
                    }
                    
                }

                if (descriptions.count == 0) {
                    
                    self.noBooksLabel.hidden = false
                    
                } else {
                    
                    self.noBooksLabel.hidden = true
                    
                }
                
            } else {
                
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
                
            }
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return descriptions.count
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 100
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedIndex = indexPath.row
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        imageFiles[selectedIndex].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            
            if (error == nil) {
                
                selectedPhoto = UIImage(data: imageData!)!
                
            }
            
        }
        
        self.performSegueWithIdentifier("detailSegue", sender: self)
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: bookCell = tableView.dequeueReusableCellWithIdentifier("booksCells") as! bookCell
        
        cell.subjectBookDescription.text = descriptions[indexPath.row]
        cell.subjectBookPosterUsername.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock { (imageData, error) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData!)
                
                cell.subjectBookImage.image = image
                
            }
            
        }
        
        return cell
    }
    
    

    
}
