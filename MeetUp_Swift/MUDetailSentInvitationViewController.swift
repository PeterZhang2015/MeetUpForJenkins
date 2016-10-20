//
//  MUDetailSentInvitationViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 2/09/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUDetailSentInvitationViewController: UIViewController {
    
    var AnInvitation: Invitation?
    
    var sourceVcType: Int? //    0-Sent Invitation VC, 1-Received Invitation VC
    
    var selectedMeetingTime: String!
    var selectedMeetingLocation: String!
    
    var HaveSelectedMeetingTime: Int? //    0-not selected, 1-selected
    var HaveSelectedMeetingLocation: Int? //    0-not selected, 1-selected

    @IBOutlet weak var DisplayMeetingNameText: UITextView!
    
    
    @IBOutlet weak var DisplayMeetingDescriptionText: UITextView!
    
    
    @IBOutlet weak var inviterFriendEmail: UIButton!
    
    
    
    @IBAction func cancelForDetailMeetingTimeVC(_ segue:UIStoryboardSegue) {
        
        
    }
    
    @IBAction func cancelForDetailMeetingLocationVC(_ segue:UIStoryboardSegue) {
        
        
    }
    
    @IBAction func cancelForDetailInvitedFriendVC(_ segue:UIStoryboardSegue) {
        
        
    }
    
    @IBAction func cancelForDetailInviterFriendVC(_ segue:UIStoryboardSegue) {
        
    }
    
    @IBAction func CancelForDetailMeetingTimeVC(_ segue:UIStoryboardSegue) {
        
    }

 
    @IBAction func CancelForDetailMeetingLocationVC(_ segue:UIStoryboardSegue) {
        
    }
    
    /*  Succeed to send the selected meeting time information to supported web server. */
    func succeedToSendSelectedMeetingTimeInfo(_ jsonData: NSDictionary) -> Void {
        
        self.AnInvitation?.selectedMeetingTime = self.selectedMeetingTime!
        
    }
    
    
    /*  Failed to send the selected meeting time information to supported web server. */
    func failedToSendSelectedMeetingTimeInfo(_ errorMsg: NSString) -> Void {
        
        NSLog("Select meeting time Failed!");
        
        let title = "Select meeting time Failed!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }

    /* Process the http response from remote server after sending http request which sending the selected meeting time information to supported web server. */
    func receivedSendingSelectedMeetingTimeResultFromRemoteServer(_ data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSendSelectedMeetingTimeInfo, processFailureHttpResponse: self.failedToSendSelectedMeetingTimeInfo)
        
    }
    
    
    @IBAction func selectForDetailMeetingTimeVC(_ segue:UIStoryboardSegue) {
        
        let sourceVC:MUDetailMeetingTimeViewController = segue.source as! MUDetailMeetingTimeViewController
  
        let meetingTimeNum = sourceVC.meetingTimeArray.count
        if (meetingTimeNum == 0)
        {
            let title = "Set meeting time error!"
            let message = "You have to set at least one meeting time!"
            sendAlertView(title, message: message)
        }
        else
        {
            let delegate:UIPickerViewDelegate = sourceVC.meetingTimePicker.delegate!
            
            self.selectedMeetingTime = delegate.pickerView!(sourceVC.meetingTimePicker, titleForRow: sourceVC.meetingTimePicker.selectedRow(inComponent: 0), forComponent: 0)!
            
            self.HaveSelectedMeetingTime = 1 //    0-not selected, 1-selected
            
            
            /*Sending the added invitation to the supported web server. */
            let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/selectedmeetingtime.php")!
            
            let postString: NSString = "sSelectedMeetingTime=\(selectedMeetingTime)&iInvitationID=\(AnInvitation!.InvitationId)" as NSString
            
            let request = createHttpPostRequest(url, postString: postString)
            
            interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedSendingSelectedMeetingTimeResultFromRemoteServer, failToGetHttpResponse: self.failedToSendSelectedMeetingTimeInfo)
            
            
            /******Reset meeting time array by selected meeting time. **********/
            AnInvitation!.MeetingTime.removeAll()
            
            AnInvitation!.MeetingTime.append(selectedMeetingTime)
        }
        


    }
    

    /*  Succeed to send the selected meeting location information to supported web server. */
    func succeedToSendSelectedMeetingLocationInfo(_ jsonData: NSDictionary) -> Void {
        
        self.AnInvitation?.selectedMeetingLocation = self.selectedMeetingLocation
        
    }
    
    
    /*  Failed to send the selected meeting location information to supported web server. */
    func failedToSendSelectedMeetingLocationInfo(_ errorMsg: NSString) -> Void {
        
        NSLog("Select meeting location Failed!");
        
        let title = "Select meeting location Failed!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which sending the selected meeting location information to supported web server. */
    func receivedSendingSelectedMeetingLocaitonResultFromRemoteServer(_ data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode)
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSendSelectedMeetingLocationInfo, processFailureHttpResponse: self.failedToSendSelectedMeetingLocationInfo)
        
    }
    
    @IBAction func SelectForDetailMeetingLocationVC(_ segue:UIStoryboardSegue) {
    
        let sourceVC:MUDetailMeetingLocationViewController = segue.source as! MUDetailMeetingLocationViewController
            
        let meetingLocationNum = sourceVC.meetingLocationArray.count
        if (meetingLocationNum == 0)
        {
            let title = "Set meeting location error!"
            let message = "You have to set at least one location!"
            sendAlertView(title, message: message)
        }
        else
        {
    
            let delegate:UIPickerViewDelegate = sourceVC.meetingLocationPicker.delegate!
         
            self.selectedMeetingLocation = delegate.pickerView!(sourceVC.meetingLocationPicker, titleForRow: sourceVC.meetingLocationPicker.selectedRow(inComponent: 0), forComponent: 0)!

            self.HaveSelectedMeetingLocation = 1 //    0-not selected, 1-selected
            

            /*Set information after setting the meeting location. */
            sourceVC.selectedMeetingLocation = selectedMeetingLocation
            sourceVC.GetToMeetLocationButton.isHidden = false
            sourceVC.HaveSelected = 1  //    0-not selected, 1-selected
            
            AnInvitation?.selectedMeetingLocation = selectedMeetingLocation
            
            /* send data to web server. */
            let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/selectedmeetinglocation.php")!

            // Compose a query string
            let postString: NSString = "sSelectedMeetingLocation=\(selectedMeetingLocation)&iInvitationID=\(AnInvitation!.InvitationId)" as NSString

            let request = createHttpPostRequest(url, postString: postString)
            
            interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedSendingSelectedMeetingLocaitonResultFromRemoteServer, failToGetHttpResponse: self.failedToSendSelectedMeetingLocationInfo)
            
            
            /******Reset meeting lcation array by selected meeting location. **********/
            AnInvitation!.MeetingLocation.removeAll()
            
            AnInvitation!.MeetingLocation.append(selectedMeetingLocation)
            
        }
        
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToDetailMeetingTimeVC"{
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailMeetingTimeVC: MUDetailMeetingTimeViewController
//            = destinationNavigationController.topViewController as! MUDetailMeetingTimeViewController
            
            let detailMeetingTimeVC: MUDetailMeetingTimeViewController
                        = segue.destination as! MUDetailMeetingTimeViewController
            
            detailMeetingTimeVC.meetingTimeArray = AnInvitation!.MeetingTime

            detailMeetingTimeVC.sourceVcType = self.sourceVcType
            detailMeetingTimeVC.HaveSelected = self.HaveSelectedMeetingTime
            detailMeetingTimeVC.selectedMeetingTime = AnInvitation?.selectedMeetingTime
            

        }
        else if segue.identifier == "SegueToDetailMeetingLocationVC"{
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailMeetingLocationVC: MUDetailMeetingLocationViewController = destinationNavigationController.topViewController as! MUDetailMeetingLocationViewController
            
            let detailMeetingLocationVC: MUDetailMeetingLocationViewController = segue.destination as! MUDetailMeetingLocationViewController
            
            detailMeetingLocationVC.meetingLocationArray = AnInvitation!.MeetingLocation
            
            detailMeetingLocationVC.sourceVcType = self.sourceVcType
            detailMeetingLocationVC.HaveSelected = self.HaveSelectedMeetingLocation
            
            detailMeetingLocationVC.selectedMeetingLocation = self.AnInvitation?.selectedMeetingLocation
            
            
        }
        else if segue.identifier == "SegueToDetailInvitedFriendVC"{
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailInvitedFriendVC: MUDetailInvitedFriendViewController = destinationNavigationController.topViewController as! MUDetailInvitedFriendViewController
            
            
            let detailInvitedFriendVC: MUDetailInvitedFriendViewController = segue.destination as! MUDetailInvitedFriendViewController
            
            
            detailInvitedFriendVC.InvitedFriendEmail = AnInvitation?.InvitedFriendEmail

        }
        else if segue.identifier == "SegueToDetailInviterFriendVC"{
            
            
//            let destinationNavigationController:UINavigationController = segue.destinationViewController as! UINavigationController
//            
//            let detailInviterFriendVC: MUDetailInviterFriendViewController = destinationNavigationController.topViewController as! MUDetailInviterFriendViewController
            
            let detailInviterFriendVC: MUDetailInviterFriendViewController = segue.destination as!MUDetailInviterFriendViewController
            
            detailInviterFriendVC.InviterFriendEmail = AnInvitation?.InviterFriendEmail
            
        }
        else
        {
            
        
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if ((self.AnInvitation?.haveSelectedMeetingLocationFlag) == true)
        {
            
            self.HaveSelectedMeetingLocation = 1
        }
        
        if ((self.AnInvitation?.haveSelectedMeetingTimeFlag) == true)
        {
            
            self.HaveSelectedMeetingTime = 1
        }
        
        

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    
        /*Display meeting name. */
        DisplayMeetingNameText.isUserInteractionEnabled = true
        DisplayMeetingNameText.isEditable = false
        
        DisplayMeetingNameText.text = AnInvitation?.MeetingName
        
        /*Display meeting description. */
        DisplayMeetingDescriptionText.isUserInteractionEnabled = true
        DisplayMeetingDescriptionText.isEditable = false
        
        DisplayMeetingDescriptionText.text = AnInvitation?.MeetingDescription


 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
