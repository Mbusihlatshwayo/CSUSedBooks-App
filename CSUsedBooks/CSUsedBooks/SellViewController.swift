//
//  PeopleViewController.swift
//  CSUsedBooks
//
//  Created by Mbusi Hlatshwayo on 3/19/15.
//  Copyright (c) 2015 Mbusi Hlatshwayo. All rights reserved.
//

import UIKit

class SellViewController: UIViewController {
    
    @IBOutlet var descriptionTextField: UITextField!
    
    @IBOutlet var bookImage: UIImageView!
    
    @IBOutlet var categoryPicker: UIPickerView!
    
    @IBAction func pickImage(sender: AnyObject) {
        
        
        
    }
    
    
    @IBAction func postListing(sender: AnyObject) {
        
        
        
    }
    /*
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courseCatalog.count
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return 1
        
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return courseCatalog[row]
        
    }
    /*
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println()("Picker Touched at \(row)")
    }
    */
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("Current view: PeopleViewController")
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        
    }


}
