//
//  MUCreateAnAccountViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.


import UIKit

class MUCreateAnAccountViewController: UIViewController ,UITextFieldDelegate{

    
    @IBOutlet weak var SignUpUserName: UITextField!
    @IBOutlet weak var SignUpEmail: UITextField!
    @IBOutlet weak var SignUpPassword: UITextField!
    @IBOutlet weak var SignUpConfirmPassword: UITextField!

    
    @IBAction func CreateAnAccount(sender: AnyObject) {
  
        let signUpInputInfoValid = checkValidationForSignUpInputInfo(SignUpUserName, email: SignUpEmail, password: SignUpPassword, confirmedPassword: SignUpConfirmPassword)
        
        if (signUpInputInfoValid)
        {
            /* Get stored device token. */
            let defaults = NSUserDefaults.standardUserDefaults()   //Set defaults to save and get data.

            let deviceToken = defaults.objectForKey(GlobalConstants.kdeviceToken) as! String?
            
            //    let deviceToken = "1234"  //Just for debug.
            
            /* send sign up data to web server. */
            let url: NSURL = NSURL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/createaccount.php")!
            
            // Compose a query string
            let postString: NSString = "sDeviceToken=\(deviceToken!)&sUsername=\(SignUpUserName.text!)&sEmail=\(SignUpEmail.text!)&sPassword=\(SignUpPassword.text!)"
            
            let request = createHttpPostRequest(url, postString: postString)

            interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedSignUpResultFromRemoteServer, failToGetHttpResponse: self.failedToSignUp)
        }

    }
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.SignUpUserName.delegate = self;
        self.SignUpEmail.delegate = self;
        self.SignUpPassword.delegate = self;
        self.SignUpConfirmPassword.delegate = self;

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    /*  Succeed to create an account for meetup applicaiton. */
    func succeedToSignUp(jsonData: NSDictionary) -> Void {
       
        NSLog("Sign Up Succeed");
        
        let title = "Success!"
        let message = "Create an account successfully!"
        sendAlertView(title, message: message)
    }
    
    /*  Failed to create an account for meetup applicaiton. */
    func failedToSignUp(errorMsg: NSString) -> Void {

        NSLog("Fail to sign up");
        
        let title = "Sign Up Failed!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for creating an account. */
    func receivedSignUpResultFromRemoteServer(data: NSData, response: NSURLResponse) -> Void {
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSignUp, processFailureHttpResponse: self.failedToSignUp)
        
    }
    
    /*Check the validation for the signup input information. */
    func checkValidationForSignUpInputInfo(username: UITextField, email: UITextField, password: UITextField, confirmedPassword: UITextField) -> Bool {
        
        if (username.text!.isEmpty) { //Check whether the username is empty
            
            let title = "No UserName"
            let message = "You have to fill the UserName!"
            sendAlertView(title, message: message)
            
            return false
            
        }
        
        if (email.text!.isEmpty){ //Check whether the Email is empty
            
            let title = "No Email"
            let message = "You have to fill the Email!"
            sendAlertView(title, message: message)
            
            return false
       
        }
        
        if (password.text!.isEmpty){ //Check whether the Email is empty
            
            let title = "No Password"
            let message = "You have to fill the Password!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        if (confirmedPassword.text!.isEmpty){ //Check whether the Email is empty
            
            let title = "No Confirm Password"
            let message = "You have to fill the Confirm Password!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        if (password.text != confirmedPassword.text){  //Check whether the comfirm password is different from password.
            
            let title = "Unmatched Password"
            let message = "Confirm Password is different from Password!"
            sendAlertView(title, message: message)
            
            return false
        }
        
        return true

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
