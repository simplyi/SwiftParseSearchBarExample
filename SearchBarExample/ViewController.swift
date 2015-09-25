//
//  ViewController.swift
//  SearchBarExample
//
//  Created by Sergey Kargopolov on 2015-07-11.
//  Copyright (c) 2015 Sergey Kargopolov. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
 

    var searchResults = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
   
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func searchBarSearchButtonClicked(searchBar: UISearchBar)
    {
        searchBar.resignFirstResponder()
        print("Search word = \(searchBar.text)")
        
        let firstNameQuery = PFQuery(className:"Friends")
        firstNameQuery.whereKey("first_name", containsString: searchBar.text)
        
        let lastNameQuery = PFQuery(className:"Friends")
        lastNameQuery.whereKey("last_name", matchesRegex: "(?i)\(searchBar.text)")
        // a regular expression that will match the search word and the value in the Parse class 
        // and the comparison will be case insensetive. 
        
        
        
        
        
        let query = PFQuery.orQueryWithSubqueries([firstNameQuery, lastNameQuery])
        
        query.findObjectsInBackgroundWithBlock {
            (results: [AnyObject]?, error: NSError?) -> Void in
            
            if error != nil {
                let myAlert = UIAlertController(title:"Alert", message:error?.localizedDescription, preferredStyle:UIAlertControllerStyle.Alert)
                
                let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil)
                
                myAlert.addAction(okAction)
                
                self.presentViewController(myAlert, animated: true, completion: nil)
                
                return
            }
            
            if let objects = results as? [PFObject] {
                
                self.searchResults.removeAll(keepCapacity: false)
                
                for object in objects {
                    let firstName = object.objectForKey("first_name") as! String
                    let lastName = object.objectForKey("last_name") as! String
                    let fullName = firstName + " " + lastName

                    self.searchResults.append(fullName)
                }
                
                dispatch_async(dispatch_get_main_queue()) {
                    self.myTableView.reloadData()
                    self.mySearchBar.resignFirstResponder()
                    
                }
                
                
                
            }
            

            
            
        }

    }
    
 

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let myCell = tableView.dequeueReusableCellWithIdentifier("myCell", forIndexPath: indexPath) 
        
        myCell.textLabel?.text = searchResults[indexPath.row]
        
        return myCell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        mySearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar)
    {
        mySearchBar.resignFirstResponder()
        mySearchBar.text = ""
    }
    
    @IBAction func refreshButtonTapped(sender: AnyObject) {
        mySearchBar.resignFirstResponder()
        mySearchBar.text = ""
        self.searchResults.removeAll(keepCapacity: false)
        self.myTableView.reloadData()
    }
    
    
}

