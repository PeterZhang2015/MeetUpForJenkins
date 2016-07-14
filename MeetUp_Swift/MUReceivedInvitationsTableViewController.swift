//
//  MUReceivedInvitationsTableViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUReceivedInvitationsTableViewController: UITableViewController {

    var  receivedInvitations = [Invitation]()
    var  SelectRowInvitation: Invitation?
    
    var haveGotReceivedInvitationInfo: Bool?
    
    
    @IBAction func cancelForDetailSentInvitationVC(segue:UIStoryboardSegue) {
        
        let sourceVC:MUDetailSentInvitationViewController = segue.sourceViewController as! MUDetailSentInvitationViewController

        passFlagsFromSourceDetailInvitationToReceivedInvitationsTable(self.receivedInvitations, sourceVC:sourceVC)

    }
    
    /* Passing flags about whether the user has selected meeting time or meeting location from source detail invitation to destination received invitations table. */
    func passFlagsFromSourceDetailInvitationToReceivedInvitationsTable(receivedInvitations: [Invitation], sourceVC:MUDetailSentInvitationViewController) -> Void {

        let invitationNum = self.receivedInvitations.count
        
        for index in 0 ..< invitationNum
        {
            if (receivedInvitations[index].InvitationId == sourceVC.AnInvitation?.InvitationId)
            {
                if (sourceVC.HaveSelectedMeetingTime == 1)
                {
                    receivedInvitations[index].haveSelectedMeetingTimeFlag = true
                }
                if (sourceVC.HaveSelectedMeetingLocation == 1)
                {
                    receivedInvitations[index].haveSelectedMeetingLocationFlag = true
                }
                
                
            }
            
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.haveGotReceivedInvitationInfo = false

        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    /*  Update received invitations table. */
    func updateReceivedInvitationsTable(jsonData: NSDictionary) -> Void {
        
        let invitationNum = jsonData.valueForKey("invitationNum") as! Int
        
        let arraySentMeetingInfo = jsonData.valueForKey("arrayReceivedMeetingInfo") as! NSArray
        
        self.receivedInvitations.removeAll()
        
        for index in 0 ..< invitationNum
        {
            var oneRowInvitation: Invitation?
            
            oneRowInvitation = decodeInvitationInfo(arraySentMeetingInfo[index])
            
            self.receivedInvitations.append(oneRowInvitation!)
            self.tableView.reloadData()
            
        }
    }
    
    
    /*  Succeed to get all received invitation information. */
    func succeedToGetAllReceivedInvitationInfo(jsonData: NSDictionary) -> Void {
        
        updateReceivedInvitationsTable(jsonData)
        
        self.haveGotReceivedInvitationInfo = true
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })
        
    }
    
    
    /*  Failed to get all received invitation information. */
    func failedToGetAllReceivedInvitationInfo(errorMsg: NSString) -> Void {
        
        NSLog("Fail to get all received invitation information.");
        
        let title = "Fail to get all received invitation information!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for all received invitation information. */
    func receivedAllReceivedInvitationInfoResultFromRemoteServer(data: NSData, response: NSURLResponse) -> Void {
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToGetAllReceivedInvitationInfo, processFailureHttpResponse: self.failedToGetAllReceivedInvitationInfo)
        
    }

    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated);
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })
        
        if ((self.haveGotReceivedInvitationInfo != true))
        {
            
            let url: NSURL = NSURL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getallreceivedinvitationinfo.php")! // the web link of the provider.
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            // Compose login information with device token, login Email, and loginPassword
            let postString: NSString = "sInvitedEmail=\(appDelegate.accountInfo!.Email)"   
            NSLog("Input Email for querying sent invitation info ==> %@", appDelegate.accountInfo!.Email);
            
            let request = createHttpPostRequest(url, postString: postString)
            
            interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: receivedAllReceivedInvitationInfoResultFromRemoteServer, failToGetHttpResponse: self.failedToGetAllReceivedInvitationInfo)
                        
        }
        
        
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
        return receivedInvitations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        /* Get the cell according to it's identifier. */
        let cell = tableView.dequeueReusableCellWithIdentifier("ReceivedInvitationsCell", forIndexPath: indexPath)
        
        
        // Set the meeting name as the text label of the cell.
        cell.textLabel!.text = receivedInvitations[indexPath.row].MeetingName
        
        return cell
        
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        SelectRowInvitation = self.receivedInvitations[indexPath.row]
        
        //performSegueWithIdentifier("SegueToDetailInvitationVC", sender: self)
        
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        SelectRowInvitation = self.receivedInvitations[indexPath.row]
        
        //performSegueWithIdentifier("SegueToDetailInvitationVC", sender: self)
        
        return indexPath
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueToDetailInvitationVC"{  /* Transfer Invitation information of the selected row from MUSentInvitationsTableViewController to MUDetailSentInvitationViewController*/
            
            
       //     let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
            
        //    let detailSentInvitationVC:MUDetailSentInvitationViewController = destinationNavigationController.topViewController as! MUDetailSentInvitationViewController
            
            let detailSentInvitationVC:MUDetailSentInvitationViewController = segue.destinationViewController as!MUDetailSentInvitationViewController
            
            detailSentInvitationVC.AnInvitation = self.SelectRowInvitation
            detailSentInvitationVC.sourceVcType = GlobalConstants.kReceivedInvitationVC  // 0-Sent Invitation VC, 1-Received Invitation VC
            
            if (self.SelectRowInvitation?.haveSelectedMeetingLocationFlag == true)
            {
                detailSentInvitationVC.HaveSelectedMeetingLocation = 1
            }
            
            if (self.SelectRowInvitation?.haveSelectedMeetingTimeFlag == true)
            {
                detailSentInvitationVC.HaveSelectedMeetingTime = 1
            }
            
        }
        
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
