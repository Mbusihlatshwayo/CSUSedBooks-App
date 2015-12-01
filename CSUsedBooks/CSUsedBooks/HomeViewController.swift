//
//  HomeViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/19/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit


var courseCatalog = ["Accounting", "Administration" , "American Studies" , "Anthropology" , "Arabic" , "Art" , "Aerospace Studies" , "American Sign Language" , "Biology" , "Child Development" , "Chemistry" , "Chinese" , "Criminal Justice", "Communication Studies" , "Computer Science", "Computer Engineering", "Educational Administration", "Educational Counseling", "Economics" , "Career and Technical Studies", "Correctional and Alternative", "Curriculum and Instruction", "Science Education", "Education", "English", "Rehabilitation counseling", "Special Education", "Instructional Technology", "Finance", "Foreign Language", "French", "Geography", "Geology", "Human Development", "History", "Health Science", "Humanities", "Information Systems and Tech", "Japanese", "Kinesiology", "Korean" ,"Math", "Management", "Marketing", "Music", "Natural Sciences", "Nursing", "Public Administration", "Persian", "Philosophy", "Physics", "Paralegal Studies", "Political Science" , "Psychology", "Supply Chain Management", "Sociology", "Spanish", "Social Sciences" , "Social Work", "Theatre Arts", "University Studies", "Other"]

var selectedSubject = "Accounting"

var unreadMessages = [String]()

var tabBarBadge:Int = 0

class HomeViewController: UIViewController, UITextFieldDelegate , UITableViewDelegate {

    @IBAction func backToHomeViewController(segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(animated: Bool) {

        super.viewWillAppear(true)
        
        unreadMessages.removeAll(keepCapacity: false)
        
        // update the badge if the user has mail in the mailbox unred
        var tabArray = self.tabBarController?.tabBar.items as NSArray!
        var tabItem = tabArray.objectAtIndex(1) as! UITabBarItem
        
        let currentInstallation = PFInstallation.currentInstallation()
        currentInstallation.addUniqueObject(PFUser.currentUser()!.username!, forKey: "channels")
        currentInstallation.saveInBackground()
        
        FBRequestConnection.startForMeWithCompletionHandler({ (connection, result, error) -> Void in
            
            // Cast result to optional dictionary type
            var resultdict = result as? NSDictionary
            
            if (resultdict != nil) {
                // Extract a value from the dictionary
                name = resultdict!["first_name"] as! String
                
            }
            
        })
        
        var unreadQuery = PFQuery(className: "Message")
        unreadQuery.whereKey("realToUser", equalTo: PFUser.currentUser()!.username!)
        
        unreadQuery.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            // set messages to read here
            
            if error == nil {
                
                // The find succeeded.
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    
                    for object in objects {
                            
                        if (object["readStatus"] != nil) {
                            
                            var read = Bool()
                            if (object["readStatus"] as! String == "no") {
                                
                                unreadMessages.append("read")
                                
                            }
                            
                        }
                        
                    }
                    
                    tabBarBadge = unreadMessages.count
                    if (unreadMessages.count == 0) {
                        
                        tabItem.badgeValue = nil
                        
                    } else {
                        
                        tabItem.badgeValue = String(unreadMessages.count)
                      
                    }
                    
                }
                
            } else {
                
                // Log details of the failure
                print("Error: \(error) \(error!.userInfo)")
                
            }
            
        }
    
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return courseCatalog.count
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = courseCatalog[indexPath.row]
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        selectedSubject = courseCatalog[indexPath.row]
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        performSegueWithIdentifier("BookSegue", sender: self)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
        
    }
    
}
