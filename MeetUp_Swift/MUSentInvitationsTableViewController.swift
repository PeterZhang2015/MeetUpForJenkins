//
//  MUSentInvitationsTableViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUSentInvitationsTableViewController: UITableViewController {
    
    
    var  Invitations = [Invitation]()
    var  SelectRowInvitation: Invitation?
    
    var haveGotSentInvitationInfo: Bool?
    
    
 
    @IBAction func cancelForDetailSentInvitationVC(segue:UIStoryboardSegue) {

        
    }
    

    @IBAction func cancelForAnSentInvitationVC(segue:UIStoryboardSegue) {

        
    }
    
    
    @IBAction func doneForAnSentInvitationVC(segue:UIStoryboardSegue) {
        
        if let AnSentInvitationVC = segue.sourceViewController as? MUAnSentInvitationViewController {
            
            //add the new invitation to the invitation array
            Invitations.append(AnSentInvitationVC.newInvitation!)
            
            tableView.reloadData()
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.haveGotSentInvitationInfo = false
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })

    }
    
    /*  Update Sent invitations table. */
    func updateSentInvitationsTable(jsonData: NSDictionary) -> Void {
        
        let invitationNum = jsonData.valueForKey("invitationNum") as! Int
        
        let arraySentMeetingInfo = jsonData.valueForKey("arraySentMeetingInfo") as! NSArray
        
        self.Invitations.removeAll()
        
        for index in 0 ..< invitationNum
        {
            var oneRowInvitation: Invitation?
            
            oneRowInvitation = decodeInvitationInfo(arraySentMeetingInfo[index])
            
            self.Invitations.append(oneRowInvitation!)
            self.tableView.reloadData()
            
        }
    }
    
    /*  Succeed to get all sent invitation information. */
    func succeedToGetAllSentInvitationInfo(jsonData: NSDictionary) -> Void {
        
        updateSentInvitationsTable(jsonData)
        
        self.haveGotSentInvitationInfo = true
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })

    }
    
    
    /*  Failed to get all sent invitation information. */
    func failedToGetAllSentInvitationInfo(errorMsg: NSString) -> Void {
        
        NSLog("Fail to get all sent invitation information.");
        
        let title = "Fail to get all sent invitation information!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for all sent invitation information. */
    func receivedAllSentInvitationInfoResultFromRemoteServer(data: NSData, response: NSURLResponse) -> Void {
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToGetAllSentInvitationInfo, processFailureHttpResponse: self.failedToGetAllSentInvitationInfo)
        
    }

    
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated);
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.tableView.reloadData()
            
        })
        
        if ((self.haveGotSentInvitationInfo != true))
        {
            
            let url: NSURL = NSURL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getallsentinvitationinfo.php")! // the web link of the provider.
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            // Compose login information with device token, login Email, and loginPassword
            let postString: NSString = "sInviterEmail=\(appDelegate.accountInfo!.Email)"
            NSLog("Input Email for querying sent invitation info ==> %@", appDelegate.accountInfo!.Email);
            
            let request = createHttpPostRequest(url, postString: postString)
        

            interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedAllSentInvitationInfoResultFromRemoteServer, failToGetHttpResponse: self.failedToGetAllSentInvitationInfo)
            
        }  // end of if ((self.haveGotSentInvitationInfo != true))
 
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
        // Return the number of rows in the section.
        return Invitations.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {


        /* Get the cell according to it's identifier. */
        let cell = tableView.dequeueReusableCellWithIdentifier("SentInvitationsCell", forIndexPath: indexPath)
        
        
        // Set the meeting name as the text label of the cell.
        cell.textLabel!.text = self.Invitations[indexPath.row].MeetingName

        return cell

    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        SelectRowInvitation = self.Invitations[indexPath.row]
  
        //performSegueWithIdentifier("SegueToDetailSentInvitationVC", sender: self)

    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        SelectRowInvitation = self.Invitations[indexPath.row]
        
        //performSegueWithIdentifier("SegueToDetailSentInvitationVC", sender: self)
        
        return indexPath
    }
    

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "SegueToDetailSentInvitationVC"{  /* Transfer Invitation information of the selected row from MUSentInvitationsTableViewController to MUDetailSentInvitationViewController*/
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailSentInvitationVC:MUDetailSentInvitationViewController = destinationNavigationController.topViewController as! MUDetailSentInvitationViewController
            
            let detailSentInvitationVC:MUDetailSentInvitationViewController = segue.destinationViewController as! MUDetailSentInvitationViewController
            
            detailSentInvitationVC.AnInvitation = self.SelectRowInvitation
            detailSentInvitationVC.sourceVcType = GlobalConstants.kSentInvitationVC  // 0-Sent Invitation VC, 1-Received Invitation VC
            
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
