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

    
    
    @IBOutlet var loginEmailText: UITextField!
    
    @IBOutlet var loginPasswordText: UITextField!
    
    
    @IBOutlet var fbButtonInStoryboard: FBSDKLoginButton!
    
    var loginEmail: String = ""
    var loginPassword: String = ""

    @IBAction func Login(sender: AnyObject) {
        
        let signInInputInfoValid = checkValidationForSignInInputInfo(loginEmailText, password: loginPasswordText)
        
        if (signInInputInfoValid)
        {
            
            self.loginEmail = loginEmailText.text!
            
            self.loginPassword = loginPasswordText.text!
            
            
            loginApplication((loginEmailText.text!), userPassword: (loginPasswordText.text!), loginWithFacebook: 0)
        }
     

    }
    
    /*Check the validation for the signin input information. */
    func checkValidationForSignInInputInfo(email: UITextField, password: UITextField) -> Bool {
        
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
    
    

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if (error != nil)
        {
            NSLog("error ===> %@", error.localizedDescription)
            
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            
            NSLog("Facebook login completely!")
            
            if result.grantedPermissions.contains("email")
            {

                let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields":"id,email,name,picture.width(480).height(480)"])
            
                
                 graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
   
                    if ((error) != nil)
                    {
                        // Process error
                        NSLog("error ===> %@", error.localizedDescription)
                    }
                    else
                    {
                       // NSLog("fetched user: %@", result)
   
  
                  //      let userName : NSString = result.valueForKey("name") as! NSString
                   //     NSLog("User Name is: %@", userName)
               
                        self.loginEmail = result.valueForKey("email") as! String
                        NSLog("User Email is: %@", self.loginEmail)
                        
                        self.loginPassword = ""
                        
                        
                        self.loginApplication(self.loginEmail, userPassword: self.loginPassword, loginWithFacebook: 1)
               
                    }
                })// end of graphRequest.startWithCompletionHandler
            }// end of if result.grantedPermissions.contains("email")
            
  
        }

    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
        NSLog("Facebook login out!")
    
    }
    
    
    /*  Succeed to signin an account for meetup applicaiton. */
    func succeedToSignIn(jsonData: NSDictionary) -> Void {
        
        /*Get AppDelegate. */
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        /*Set the bIsLogin in AppDelegate to true. */
        appDelegate.bIsLogin = true
        
        /*Initial accountInfo object. */
        appDelegate.accountInfo = AccountInfo(Email: self.loginEmail, Password: self.loginPassword)
        
        
        /*Show the successful login result. */
        NSLog("Login Success");
        
        
        /******Initial viewcontroller in TabBar. *********/
        let sentInvitationVC = self.storyboard!.instantiateViewControllerWithIdentifier("SentInvitationsVC") as! MUSentInvitationsTableViewController
        
        
        let receivedInvitationVC = self.storyboard!.instantiateViewControllerWithIdentifier("ReceivedInvitationsVC") as! MUReceivedInvitationsTableViewController
        
        let settingsVC = self.storyboard!.instantiateViewControllerWithIdentifier("SettingsVC") as! MUSettingsTableViewController
        
        
        self.tabBarController?.setViewControllers([sentInvitationVC, receivedInvitationVC, settingsVC], animated: false)
        
        /*Set the root view controller as the sent invitation view controller in tabbar. */
        dispatch_async(dispatch_get_main_queue(), {
            
            self.view.endEditing(true) // This is used to hide keyboard.
            
            appDelegate.tabBarController?.selectedIndex = 0 // 0-send invitation viewcontroller, 1-received invitation viewcontroller, 2-settings.
            
            appDelegate.window?.rootViewController = appDelegate.tabBarController
            
        })

    }
    
    /*  Failed to signin an account for meetup applicaiton. */
    func failedToSignIn(errorMsg: NSString) -> Void {
        
        NSLog("Fail to sign up");
        
        let title = "Sign Up Failed!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }

    
    /* Process the http response from remote server after sending http request which asked for signin an account. */
    func receivedSignInResultFromRemoteServer(data: NSData, response: NSURLResponse) -> Void {
        
        let statusCode = (response as! NSHTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(statusCode, data: data, processSuccessfulHttpResponse: self.succeedToSignIn, processFailureHttpResponse: self.failedToSignIn)
        
    
    }
    
    func loginApplication(userEmail: String, userPassword: String, loginWithFacebook: Int) {
        

        /* Get stored device token. */
        let defaults = NSUserDefaults.standardUserDefaults()   //Set defaults to save and get data.
        
        let deviceToken = defaults.objectForKey(GlobalConstants.kdeviceToken) as! String?
        /* Send device token together with loginEmailand longinPassword to the provider through HTTP request message. */
        
        
        let url: NSURL = NSURL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/login.php")!   // the web link of the provider.

        // Compose login information with device token, login Email, and loginPassword
        let postString: NSString = "devicetoken=\(deviceToken!)&sEmail=\(userEmail)&sPassword=\(userPassword)&iLoginWithFacebook=\(loginWithFacebook)"


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
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
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
