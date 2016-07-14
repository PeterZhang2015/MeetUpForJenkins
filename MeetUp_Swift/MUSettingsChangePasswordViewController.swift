//
//  MUSettingsChangePasswordViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 15/10/2015.
//  Copyright © 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUSettingsChangePasswordViewController: UIViewController {

    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var newPasswordAgain: UITextField!

    @IBAction func updateForChangePasswordVC(sender: AnyObject) {
        
    }
    
    
    /*Check the validation for the change password information. */
    func checkValidationForSignUpInputInfo(currentPassword: UITextField, newPassword: UITextField, newPasswordAgain: UITextField) -> Bool {
        
        if (currentPassword.text!.isEmpty) { //Check whether the Current Password is empty
            
            let title = "No Current Password"
            let message = "You have to fill the Current Password!"
            sendAlertView(title, message: message)
            return false
        }
            
        if (newPassword.text!.isEmpty){ //Check whether the new password is empty
            
            let title = "No New Password"
            let message = "You have to fill the New Password!"
            sendAlertView(title, message: message)
            return false
        }
            
        if (newPasswordAgain.text!.isEmpty){ //Check whether the new password again is empty
            
            let title = "No New Password Again"
            let message = "You have to fill the New Password Again!"
            sendAlertView(title, message: message)
            return false
        }
            
        if (newPassword.text != newPasswordAgain.text){ //Check whether the new password again is the same as the new password
            
            let title = "Different New Password"
            let message = "New Password Again must be the same as the New Password!"
            sendAlertView(title, message: message)
            return false
        }
        
        return true
        
    }
    
    
    /*  Succeed to change password for the user account. */
    func succeedToChangePassword(jsonData: NSDictionary) -> Void {
        
        /*Show the successful result. */
        NSLog("Change Password Successfully");
        
        let title = "Successed to change passsword!!"
        let message = "Change Passsword Successfully!"
        sendAlertView(title, message: message)
        
        dispatch_async(dispatch_get_main_queue(), {
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            /*Set the current view controller as the main tab bar of the application. */
            appDelegate.window?.rootViewController = appDelegate.tabBarController
            //self.dismissViewControllerAnimated(true, completion: nil)
        })  // end of dispatch_async(dispatch_get_main_queue()
        
    }
    
    /*  Failed to change password for the user account. */
    func failedToChangePassword(errorMsg: NSString) -> Void {
        
        NSLog("Failed To Change Passsword!");
        
        let title = "Failed To Change Passsword!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for changing password. */
    func receivedChangingPasswordResultFromRemoteServer(data: NSData, response: NSURLResponse) -> Void {
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToChangePassword, processFailureHttpResponse: self.failedToChangePassword)
        
        
    }
    
    /* Override shouldPerformSegueWithIdentifier in order to check validation.  */
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        
        /* Check the validation of meeting name. */
        if identifier == "SegueFromChangePasswordVC" {

            let changePasswordInfoValid = checkValidationForSignUpInputInfo(currentPassword, newPassword: newPassword, newPasswordAgain: newPasswordAgain)
            
            if (changePasswordInfoValid)
            {
                let url: NSURL = NSURL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/changepassword.php")!  // the web link of the provider.
   
                /*Get AppDelegate. */
                let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                let myEmail = appDelegate.accountInfo!.Email
                // Compose change password information with user email, current password, and new password.
                let postString: NSString = "sEmail=\(myEmail)&sCurrentPassword=\(currentPassword.text!)&sNewPassword=\(newPassword.text!)"
                
                let request = createHttpPostRequest(url, postString: postString)
                
                interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedChangingPasswordResultFromRemoteServer, failToGetHttpResponse: self.failedToChangePassword)

            } // end of if (changePasswordInfoValid)

        }  // end of if identifier == "SegueFromChangePasswordVC" {
        

        return true
    }

 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
