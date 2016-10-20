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
    
    
 
    @IBAction func cancelForDetailSentInvitationVC(_ segue:UIStoryboardSegue) {

        
    }
    

    @IBAction func cancelForAnSentInvitationVC(_ segue:UIStoryboardSegue) {

        
    }
    
    
    @IBAction func doneForAnSentInvitationVC(_ segue:UIStoryboardSegue) {
        
        if let AnSentInvitationVC = segue.source as? MUAnSentInvitationViewController {
            
            //add the new invitation to the invitation array
            Invitations.append(AnSentInvitationVC.newInvitation!)
            
            tableView.reloadData()
            
        }
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.haveGotSentInvitationInfo = false
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadData()
            
        })

    }
    
    /*  Update Sent invitations table. */
    func updateSentInvitationsTable(_ jsonData: NSDictionary) -> Void {
        
        let invitationNum = jsonData.value(forKey: "invitationNum") as! Int
        
        let arraySentMeetingInfo = jsonData.value(forKey: "arraySentMeetingInfo") as! NSArray
        
        self.Invitations.removeAll()
        
        for index in 0 ..< invitationNum
        {
            var oneRowInvitation: Invitation?
            
            oneRowInvitation = decodeInvitationInfo(arraySentMeetingInfo[index] as AnyObject)
            
            self.Invitations.append(oneRowInvitation!)
            self.tableView.reloadData()
            
        }
    }
    
    /*  Succeed to get all sent invitation information. */
    func succeedToGetAllSentInvitationInfo(_ jsonData: NSDictionary) -> Void {
        
        updateSentInvitationsTable(jsonData)
        
        self.haveGotSentInvitationInfo = true
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadData()
            
        })

    }
    
    
    /*  Failed to get all sent invitation information. */
    func failedToGetAllSentInvitationInfo(_ errorMsg: NSString) -> Void {
        
        NSLog("Fail to get all sent invitation information.");
        
        let title = "Fail to get all sent invitation information!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for all sent invitation information. */
    func receivedAllSentInvitationInfoResultFromRemoteServer(_ data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToGetAllSentInvitationInfo, processFailureHttpResponse: self.failedToGetAllSentInvitationInfo)
        
    }

    
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated);
        
        // It is used to trigger cellForRowAtIndexPath for updating table data in time.
        DispatchQueue.main.async(execute: { () -> Void in
            
            self.tableView.reloadData()
            
        })
        
        if ((self.haveGotSentInvitationInfo != true))
        {
            
            let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getallsentinvitationinfo.php")! // the web link of the provider.
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            // Compose login information with device token, login Email, and loginPassword
            let postString: NSString = "sInviterEmail=\(appDelegate.accountInfo!.Email)" as NSString
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return Invitations.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        /* Get the cell according to it's identifier. */
        let cell = tableView.dequeueReusableCell(withIdentifier: "SentInvitationsCell", for: indexPath)
        
        
        // Set the meeting name as the text label of the cell.
        cell.textLabel!.text = self.Invitations[(indexPath as NSIndexPath).row].MeetingName

        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        SelectRowInvitation = self.Invitations[(indexPath as NSIndexPath).row]
  
        //performSegueWithIdentifier("SegueToDetailSentInvitationVC", sender: self)

    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        SelectRowInvitation = self.Invitations[(indexPath as NSIndexPath).row]
        
        //performSegueWithIdentifier("SegueToDetailSentInvitationVC", sender: self)
        
        return indexPath
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToDetailSentInvitationVC"{  /* Transfer Invitation information of the selected row from MUSentInvitationsTableViewController to MUDetailSentInvitationViewController*/
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailSentInvitationVC:MUDetailSentInvitationViewController = destinationNavigationController.topViewController as! MUDetailSentInvitationViewController
            
            let detailSentInvitationVC:MUDetailSentInvitationViewController = segue.destination as! MUDetailSentInvitationViewController
            
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
