//
//  MUAddeMeetingTimesTableViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 2/09/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUAddeMeetingTimesTableViewController: UITableViewController {

    var  meetingTimeArray = [String]()
    var  SelectRowMeetingTime: String?
    
    
    @IBAction func cancelForAddAMeetingTimeVC(segue:UIStoryboardSegue) {
        
    }
    
    
    
    @IBAction func saveForAddAMeetingTimeVC(segue:UIStoryboardSegue) {
        
        let AMeetingInvitationVC = segue.sourceViewController as? MUAddAMeetingTimeViewController
        
        let datePicker = AMeetingInvitationVC?.newMeetingTime
        
        let dateFormatter = NSDateFormatter()
        
       // dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
       // dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss";
        
        let strDate = dateFormatter.stringFromDate(datePicker!.date)
        
        //add the new time to the meeting time array
        meetingTimeArray.append(strDate)
        
        
        tableView.reloadData()
        
        
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return meetingTimeArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get the cell according to it's identifier. */
        let cell = tableView.dequeueReusableCellWithIdentifier("MeetingTimeCell", forIndexPath: indexPath) 
        
        
        // Set the meeting time as the text label of the cell.
        cell.textLabel!.text = meetingTimeArray[indexPath.row]
        
        return cell
        
    }
    
    

    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

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
