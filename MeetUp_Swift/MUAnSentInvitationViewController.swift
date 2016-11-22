//
//  MUAnSentInvitationViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 28/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUAnSentInvitationViewController: UIViewController ,UITextFieldDelegate, UITextViewDelegate{
    
    var newInvitation: Invitation?   // An new invitation in MUAnSentInvitationViewController

    var  meetingTimeArray = [String]()
    var  meetingLocationArray = [String]()
    var  invitedFriendEmail: String?
    
    @IBOutlet weak var meetingName: UITextField!

    
    @IBOutlet weak var meetingDescription: UITextView!
    
    @IBAction func doneForAddMeetingTimesVC(_ segue:UIStoryboardSegue) {
        
        if let AddMeetingTimesVC = segue.source as? MUAddeMeetingTimesTableViewController {
            
            //add the new invitation to the invitation array
            self.meetingTimeArray = AddMeetingTimesVC.meetingTimeArray
            
            if (self.meetingTimeArray.count == 0)
            {
                let title = "Set meeting time error!"
                let message = "You have to set at least one meeting time!"
                sendAlertView(title, message: message)
            }
            
           // tableView.reloadData()
            
           // self.navigationController?.popViewControllerAnimated(True)
            
        }
        
    }
    
    @IBAction func doneForAddMeetingLocationsVC(_ segue:UIStoryboardSegue) {
        
        if let AddMeetingLocationsVC = segue.source as? MUAddMeetingLocationsTableViewController {
            
            //add the new invitation to the invitation array
            self.meetingLocationArray = AddMeetingLocationsVC.meetingLocationArray
            
            if (self.meetingLocationArray.count == 0)
            {
                let title = "Set meeting location error!"
                let message = "You have to set at least one meeting location!"
                sendAlertView(title, message: message)
            }
            
            // tableView.reloadData()
            
        }
        
    }
    
    @IBAction func saveForInviteAFriendVC(_ segue:UIStoryboardSegue) {
        
        if let InviteAFriendVC = segue.source as? MUInviteAnFriendViewController {
            
            //add the new invitation to the invitation array
            self.invitedFriendEmail = InviteAFriendVC.InvitedFriendEmail.text
            
            if ((InviteAFriendVC.InvitedFriendEmail.text?.isEmpty) == true)
            {
                let title = "Set invited friend email error!"
                let message = "You have to set at least one invited friend email!"
                sendAlertView(title, message: message)
            }
        
            // tableView.reloadData()
            
        }
        
    }
    @IBAction func cancelForInviteAFriendVC(_ segue:UIStoryboardSegue) {
        

    }
    
    
    /*Check the validation for adding an invitation. */
    func checkValidationForAddingAnInvitation(_ meetingName: UITextField, meetingDescription: UITextView, meetingTimeArray: [String],meetingLocationArray: [String], invitedFriendEmail: String) -> Bool {
        
        if (meetingName.text!.isEmpty) {
            
            
            let title = "No Meeting Name"
            let message = "You have to fill the meeting name!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        /* Check the validation of meeting description. */
        if (meetingDescription.text!.isEmpty){
            
            let title = "No Meeting Description"
            let message = "You have to fill the meeting description!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        /* Check the validation of meeting time. */
        if (meetingTimeArray.count == 0){
            
            let title = "No Meeting Time"
            let message = "You have to select at least one meeting time!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        /* Check the validation of meeting location. */
        if (meetingLocationArray.count == 0){
            
            let title = "No Meeting Location"
            let message = "You have to select at least one meeting location!"
            sendAlertView(title, message: message)

            return false
        }
        
        /* Check the validation of invited friend Email. */
        if (invitedFriendEmail.isEmpty == true){
            
            let title = "No Invited Friend"
            let message = "You have to invite a friend!"
            sendAlertView(title, message: message)

            return false
        }
        
        return true
 
        
    }
    
    
    func createAnInvitationPostString() -> NSString {
        
        /*Get AppDelegate. */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let InvitationId: NSNumber = 0  // It is a false initial invitation ID, the true invitation ID should be returned from website.
        
        let MeetingTimedata = try? JSONSerialization.data(withJSONObject: self.meetingTimeArray, options: [])
        let MeetingTimeJsonArray = NSString(data: MeetingTimedata!, encoding: String.Encoding.utf8.rawValue)
        
        let MeetingLocationdata = try? JSONSerialization.data(withJSONObject: self.meetingLocationArray, options: [])
        let MeetingLocationJsonArray = NSString(data: MeetingLocationdata!, encoding: String.Encoding.utf8.rawValue)
        
        
        newInvitation = Invitation(InvitationId:InvitationId, MeetingName: self.meetingName.text!, MeetingDescription: self.meetingDescription.text, MeetingTime: self.meetingTimeArray, MeetingLocation: self.meetingLocationArray, InvitedFriendEmail: self.invitedFriendEmail!, InviterFriendEmail: appDelegate.accountInfo!.Email,selectedMeetingTime: "", selectedMeetingLocation: "", haveSelectedMeetingTimeFlag: false, haveSelectedMeetingLocationFlag: false)
        
        // Compose login information with device token, login Email, and loginPassword
        let postString: NSString = "sInviterEmail=\(appDelegate.accountInfo!.Email)&sInvitedEmail=\(self.invitedFriendEmail!)&sMeetingName=\(self.meetingName.text!)&sMeetingDescription=\(self.meetingDescription.text!)&asMeetingTime=\(MeetingTimeJsonArray!)&asMeetingLocation=\(MeetingLocationJsonArray!)&iMeetingTimeNum=\(self.meetingTimeArray.count)&iMeetingLocationNum=\(self.meetingLocationArray.count)" as NSString
        
        return postString
    }
    

    
    /*  Succeed to send the added invitation information to supported web server. */
    func succeedToSendTheInvitationInfo(_ jsonData: NSDictionary) -> Void {
        
        /*******Update Invitation ID*********/
        /*Get AppDelegate. */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let InvitationID: NSNumber = jsonData.value(forKey: "InvitationID") as! NSNumber
        
        self.newInvitation?.InvitationId = InvitationID
        
        DispatchQueue.main.async(execute: {
            
            appDelegate.window?.rootViewController = appDelegate.tabBarController
        })    // set the sent invitation table view controller as the root view controller.
        
    }
    
    
    /*  Failed to send the added invitation information to supported web server. */
    func failedToSendTheInvitationInfo(_ errorMsg: NSString) -> Void {
        
        NSLog("Failed to save the invitation!");
        
        let title = "Failed to save the invitation!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    
    
    /* Process the http response from remote server after sending http request which sending added invitation information to supported web server. */
    func receivedSendingTheInvitationResultFromRemoteServer(_ data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSendTheInvitationInfo, processFailureHttpResponse: self.failedToSendTheInvitationInfo)
        
    }
    
    /* Override shouldPerformSegueWithIdentifier in order to check validation.  */
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any!) -> Bool {
 
        /* Check the validation of meeting name. */
        if identifier == "doneForAnSentInvitationVC" {
            
        
            let addedInvitationValid = checkValidationForAddingAnInvitation(meetingName, meetingDescription: meetingDescription, meetingTimeArray: meetingTimeArray, meetingLocationArray: meetingLocationArray, invitedFriendEmail: invitedFriendEmail!)
            
            if (addedInvitationValid)
            {

                /* Send meeting invitation request to the provider through HTTP request message. */
                
                let url: URL = URL(string: "http://192.168.0.103.xip.io/~chongzhengzhang/php/sendinvitation.php")!  // the web link of the provider.
      
                let postString = createAnInvitationPostString()
                
                let request = createHttpPostRequest(url, postString: postString)
                
                interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedSendingTheInvitationResultFromRemoteServer, failToGetHttpResponse: self.failedToSendTheInvitationInfo)
                
                
            }       // end of if (addedInvitationValid)
            else
            {
                
                return false
            }


            return true
        }  // end of if identifier == "doneForAnSentInvitationVC" 
  
        
        // by default, transition
        return true
    }
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
     
        newInvitation?.MeetingName = meetingName.text!
        newInvitation?.MeetingDescription = meetingDescription.text
        invitedFriendEmail = ""
        
        self.meetingName.delegate = self;
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
        // Dispose of any resources that can be recreated.
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "@\n" {
            self.resignFirstResponder()
            return false;
        }

        
        return true
        
    }

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


