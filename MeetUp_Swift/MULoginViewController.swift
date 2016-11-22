//
//  MULoginViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit

class MULoginViewController: UIViewController ,UITextFieldDelegate ,FBSDKLoginButtonDelegate{
    /*!
     @abstract Sent to the delegate when the button was used to login.
     @param loginButton the sender
     @param result The results of the login
     @param error The error (if any) from the login
     */
    

    
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {

        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email")
            {
            // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }


    // test
    
    @IBOutlet var loginEmailText: UITextField!
    
    @IBOutlet var loginPasswordText: UITextField!
    
    
    @IBOutlet var fbButtonInStoryboard: FBSDKLoginButton!
    
    var loginEmail: String = ""
    var loginPassword: String = ""

    @IBAction func Login(_ sender: AnyObject) {
        
        let signInInputInfoValid = checkValidationForSignInInputInfo(loginEmailText, password: loginPasswordText)
        
        if (signInInputInfoValid)
        {
            
            self.loginEmail = loginEmailText.text!
            
            self.loginPassword = loginPasswordText.text!
            
            
            loginApplication((loginEmailText.text!), userPassword: (loginPasswordText.text!), loginWithFacebook: 0)
        }
     

    }
    
    /*Check the validation for the signin input information. */
    func checkValidationForSignInInputInfo(_ email: UITextField, password: UITextField) -> Bool {
        
        if (email.text!.isEmpty) { //Check whether the Email is empty
            
            let title = "No Email"
            let message = "You have to fill the Email!"
            sendAlertView(title, message: message)
            
            return false
            
        }
        
        if (password.text!.isEmpty){ //Check whether the password is empty

            let title = "No Password"
            let message = "You have to fill the Password!"
            sendAlertView(title, message: message)
            
            return false
            
        }
        
        return true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if (FBSDKAccessToken.currentAccessToken() == nil)
//        {
//            
//            NSLog("Facebook login successfully!")
//        }
//        else
//        {
//            
//            NSLog("Facebook login error!")
//        }
        
      //  let fbLoginButton = FBSDKLoginButton()
        fbButtonInStoryboard.readPermissions = ["public_profile", "email", "user_friends"]
        
        
        fbButtonInStoryboard.delegate = self
      //  self.view.addSubview(fbButtonInStoryboard)

        
        
        self.loginEmailText.delegate = self;
        self.loginPasswordText.delegate = self;
        

        // Do any additional setup after loading the view.
    }
    
    

    
    
    /*  Succeed to signin an account for meetup applicaiton. */
    func succeedToSignIn(_ jsonData: NSDictionary) -> Void {
        
        /*Get AppDelegate. */
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        /*Set the bIsLogin in AppDelegate to true. */
        appDelegate.bIsLogin = true
        
        /*Initial accountInfo object. */
        appDelegate.accountInfo = AccountInfo(Email: self.loginEmail, Password: self.loginPassword)
        
        
        /*Show the successful login result. */
        NSLog("Login Success");
        
        
        /******Initial viewcontroller in TabBar. *********/
        let sentInvitationVC = self.storyboard!.instantiateViewController(withIdentifier: "SentInvitationsVC") as! MUSentInvitationsTableViewController
        
        
        let receivedInvitationVC = self.storyboard!.instantiateViewController(withIdentifier: "ReceivedInvitationsVC") as! MUReceivedInvitationsTableViewController
        
        let settingsVC = self.storyboard!.instantiateViewController(withIdentifier: "SettingsVC") as! MUSettingsTableViewController
        
        
        self.tabBarController?.setViewControllers([sentInvitationVC, receivedInvitationVC, settingsVC], animated: false)
        
        /*Set the root view controller as the sent invitation view controller in tabbar. */
        DispatchQueue.main.async(execute: {
            
            self.view.endEditing(true) // This is used to hide keyboard.
            
            appDelegate.tabBarController?.selectedIndex = 0 // 0-send invitation viewcontroller, 1-received invitation viewcontroller, 2-settings.
            
            appDelegate.window?.rootViewController = appDelegate.tabBarController
            
        })

    }
    
    /*  Failed to signin an account for meetup applicaiton. */
    func failedToSignIn(_ errorMsg: NSString) -> Void {
        
        NSLog("Fail to sign up");
        
        let title = "Sign Up Failed!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }

    
    /* Process the http response from remote server after sending http request which asked for signin an account. */
    func receivedSignInResultFromRemoteServer(_ data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSignIn, processFailureHttpResponse: self.failedToSignIn)
        
    
    }
    
    func loginApplication(_ userEmail: String, userPassword: String, loginWithFacebook: Int) {
        

        /* Get stored device token. */
        let defaults = UserDefaults.standard   //Set defaults to save and get data.
        
        let deviceToken = defaults.object(forKey: GlobalConstants.kdeviceToken) as! String?
        /* Send device token together with loginEmailand longinPassword to the provider through HTTP request message. */
        
        
        let url: URL = URL(string: "http://192.168.0.103.xip.io/~chongzhengzhang/php/login.php")!   // the web link of the provider.

        // Compose login information with device token, login Email, and loginPassword
        let postString: NSString = "devicetoken=\(deviceToken!)&sEmail=\(userEmail)&sPassword=\(userPassword)&iLoginWithFacebook=\(loginWithFacebook)" as NSString


        let request = createHttpPostRequest(url, postString: postString)
        
        interactionWithRemoteServerWithoutInvitationThroughHttpPost(request,  processResponseFunc: self.receivedSignInResultFromRemoteServer, failToGetHttpResponse: self.failedToSignIn)
        
 
    }
    
    
    
//    func application(application: UIApplication,
//        openURL url: NSURL,
//        sourceApplication: String?,
//        annotation: AnyObject?) -> Bool {
//            return FBSDKApplicationDelegate.sharedInstance().application(
//                application,
//                openURL: url,
//                sourceApplication: sourceApplication,
//                annotation: annotation)
//    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
