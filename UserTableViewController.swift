//
//  UserTableViewController.swift
//  CrowdTransfer Beta
//
//  Created by Cristian Duguet on 4/22/15.
//  Copyright (c) 2015 CrowdTransfer. All rights reserved.
//

import UIKit
import Parse

class UserTableViewController: UITableViewController {

    var users = [String]()
    var following = [Bool]()
    var usersFollowing = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        // ---------------------- Retrieve Followers List ----------------------
        var query2 = PFQuery(className:"followers")
        //query2.cachePolicy = .CacheThenNetwork //Cache Else Network
        query2.whereKey("follower", equalTo:PFUser.currentUser()!.username!)
        query2.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil {
                // Results were successfully found
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        //println(object["follower"])
                        self.usersFollowing.append(object["following"] as! String)
                    }
                }
                self.tableView.reloadData()
            } else {
                println("error")
                // The network was inaccessible and we have no cached data for
                // this query.
            }
        })

        
        // ---------------------- Retrieve Users List ----------------------
        var query1 = PFUser.query()
        //query1!.cachePolicy = .CacheElseNetwork //Cache Else Network
        query1!.whereKey("username", notEqualTo:PFUser.currentUser()!.username!)
        query1?.findObjectsInBackgroundWithBlock({
            (objects, error) -> Void in
            if error == nil {
                // Results were successfully found
                if let objects = objects as? [PFUser] {
                    for object in objects {
                        self.users.append(object.username!)
                    }
                }
                self.tableView.reloadData()
            } else {
                // The network was inaccessible and we have no cached data for
                // this query.
            }
        })
     
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    // ******************************** CellForRowAtIndexPath : Retornar elementos de Tabla *******************************
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell:UserCell = tableView.dequeueReusableCellWithIdentifier("userCell", forIndexPath: indexPath) as! UserCell
        
        //let cell:OfferCell = self.offersTable.dequeueReusableCellWithIdentifier("offerCell") as! OfferCell

        //let cell: userCell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        
        // -------------------------Create Bool Array -------------------------------
        self.following.removeAll(keepCapacity: true)
        var isFollowing : Bool
        for user in users {
            isFollowing = false
            if contains(usersFollowing, user) {
                isFollowing = true
            }
            following.append(isFollowing)
        }
        //println(following)
        
        // -------------------------Insert Checkmarks according to array---------------
        if following.count > indexPath.row {
            if following[indexPath.row] {
                cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            }
        }
        
        // -------------------------Insert Usernames in Cells--------------------------
        cell.userName?.text = users[indexPath.row] as String
        
        // Configure the cell...
        return cell
    }

    // ******************************** Follow / Unfollow *****************************************
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var cell:UserCell = tableView.cellForRowAtIndexPath(indexPath) as! UserCell
        
        if cell.accessoryType  == UITableViewCellAccessoryType.Checkmark {
            cell.accessoryType = UITableViewCellAccessoryType.None
            
            var query = PFQuery(className:"followers")
            query.whereKey("follower", equalTo:PFUser.currentUser()!.username!)
            query.whereKey("following", equalTo:cell.userName!.text!)
            query.findObjectsInBackgroundWithBlock {
                (objects, error) -> Void in
                if error == nil {
                    // The find succeeded.
                    //println("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            println("Eliminate " + object.objectId!)
                            object.deleteInBackground()
                        }
                    }
                } else {
                    // Log details of the failure
                    println("Error: \(error) \(error!.userInfo!)")
                }
            }
            
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
            var following = PFObject(className: "followers")
            following["following"] = cell.userName?.text
            following["follower"] = PFUser.currentUser()!.username
            following.saveInBackground()
        }
    }

    @IBAction func logOutButton(sender: AnyObject) {
        PFUser.logOut()
        self.performSegueWithIdentifier("logOutSegue", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return count(users)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
