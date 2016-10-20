//
//  AppDelegate.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit
import FBSDKCoreKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var bIsLogin: Bool?    // Define the bIsLogin in order to judge whether the user has logged in. If the user has not logged in, it should show MUMainViewController to the user, otherwise, it should show TabBarController to the user.
   
    var accountInfo: AccountInfo?  // store the login information when the user login successfully.
    
    var tabBarController: UITabBarController?    // Main tab bar view controller for the application.
    
    let defaults = UserDefaults.standard   //Set defaults to save and get data.
    

    /*Handling when the application launched in didFinishLaunchingWithOptions function. */
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        // Set lauched view.
       // self.window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)  // Get the storyboard according to it's name.
        
        self.tabBarController = storyboard.instantiateViewController(withIdentifier: "MainTabBarVC") as? UITabBarController // instantiate desired ViewController.
        
        if ((self.bIsLogin) != true){   // BOOL value to check if user is logged in or not.If user succefully logged in set value of this as true else false.
            
            print("Register to APNS.")
            
            loginMeetUpApplication(application)

        }
        

        return FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    
    
    /* Register APNS in order to get device token for futher push notification function. */
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("Got token data! (deviceToken)")
        
        let characterSet: CharacterSet = CharacterSet( charactersIn: "<>" )

        let deviceTokenString: String = ( deviceToken.description as NSString )
            .trimmingCharacters( in: characterSet )
            .replacingOccurrences( of: " ", with: "" ) as String
        
        print(deviceTokenString )
        
        defaults.set(deviceTokenString, forKey: GlobalConstants.kdeviceToken)  // Save the retrived device token, and send it to provider when login the application.
        
 
        
    }
    
    /* Fail to register APNS. */
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Couldn’t register to APNS: (error)")
    }
    
    /* Receives push notification from APNS. */
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print("!!!!!!Received Push Notification from APNS!!!!!")
        
        /* Get invitationID from push notification message. */
        if let aps = userInfo["aps"] as? NSDictionary {
            
            receivedNotificationPro(aps)
            
        }
        
    }
    
    
    func application(_ application: UIApplication,
                     open url: URL,
                             sourceApplication: String?,
                             annotation: Any) -> Bool {
        return FBSDKApplicationDelegate.sharedInstance().application(
            application,
            open: url,
            sourceApplication: sourceApplication,
            annotation: annotation)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    
    /*Show the login page of the MeetUp application.*/
    func loginMeetUpApplication(_ application: UIApplication) -> Void {
        
        let types: UIUserNotificationType = [UIUserNotificationType.badge, UIUserNotificationType.alert, UIUserNotificationType.sound]
        
        let settings: UIUserNotificationSettings = UIUserNotificationSettings( types: types, categories: nil )
        
        application.registerUserNotificationSettings( settings )
        application.registerForRemoteNotifications()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)  // Get the storyboard according to it's name.
        
        let LaunchViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC") as! MULaunchViewController   // Get the MULaunchViewController according to it's storyboard identifier.
        
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = LaunchViewController    // Set the MUMainViewController as the RootViewController.
    }

    
    
    /* Process the received push notifications. */
    func receivedNotificationPro(_ aps: NSDictionary) -> Void {
        
        if let invitationID = aps["invitationID"] as? NSNumber {
            
            NSLog("invitationID ==> %d", invitationID);
  
            if let eventType = aps["eventType"] as? NSInteger{
                
                NSLog("eventType ==> %d", eventType);
                
                switch eventType {
                    
                case GlobalConstants.kNewInvitationForInvitedUser:
                    // received push notification for invited user about the new invitation.

                    notifyNewInvitationForInvitedUser(invitationID, eventType: eventType)
                    break
                    
                case GlobalConstants.kSelectedTimeForInviterUser:
                    // received push notification for inviter user about the selected meeting time.
                    
                    notifySelectedTimeForInviterUser(invitationID, eventType: eventType)
                    
                    break
                    
                case GlobalConstants.kSelectedLocationForInviterUser:
                    // received push notification for inviter user about the selected meeting location.
                    
                    notifySelectedLocationForInviterUser(invitationID, eventType: eventType)
                    
                    break
                    
                case GlobalConstants.kMeetingRemindForInviterUser:
                    // received push notification for inviter user about the incoming meeting.
                    
                    notifyIncomingMeetingForInviterUser(invitationID, eventType: eventType)
          
                    break
                    
                case GlobalConstants.kMeetingRemindForInvitedUser:
                    // received push notification for invited user about the selected meeting location by the invited user.
                    
                    notifyIncomingMeetingForInvitedUser(invitationID, eventType: eventType)

                    break
                    
                 default:
                    break
                }
                
                
            }  // end of if let eventType = aps["eventType"] as? NSInteger{
            
            
        }   // end of if let invitationID = aps["invitationID"] as? NSInteger {
  
    }
    
    /*  Show root tabbar item of received invitations to the user. */
    func showReceivedInvitationsTabbar(_ aReceivedInvitation: Invitation) -> Void {
        
        DispatchQueue.main.async(execute: {
            
            let navigationVC: UINavigationController = self.tabBarController?.viewControllers![1] as! UINavigationController
            
            /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
            navigationVC.navigationBar.isTranslucent = false
            /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
            
            let receivedInvitationVC: MUReceivedInvitationsTableViewController = navigationVC.visibleViewController as! MUReceivedInvitationsTableViewController
            
            receivedInvitationVC.receivedInvitations.append(aReceivedInvitation)
            
            receivedInvitationVC.tableView.reloadData()
            
            
            self.window?.makeKeyAndVisible()
            
            /*********** Way of transfering to a specific tabbar. *****************/
            self.tabBarController?.selectedIndex = 1 // 0-send invitation viewcontroller, 1-received invitation viewcontroller, 2-settings.
            self.window?.rootViewController = self.tabBarController
            
            
        })

    }
    
    
    /*  Failed to get the invitation information. */
    func failedToGetTheInvitationInfo(_ invitationID: NSNumber, errorMsg: NSString) -> Void {
        

        let title = "Failed To Get Invitation Information!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    
    /*  Succeed to get the invitation information. */
    func succeedToGetTheInvitationInfo(_ invitationID: NSNumber, jsonData: NSDictionary) -> Void {
        /*Get information from response. */
        let meetingName: String = jsonData.value(forKey: "MeetingName") as! String
        
        let meetingDescription: String = jsonData.value(forKey: "MeetingDescription") as! String
        let invitedEmail: String = jsonData.value(forKey: "InvitedEmail") as! String
        let inviterEmail: String = jsonData.value(forKey: "InviterEmail") as! String
        let meetingTime: [String] = jsonData.value(forKey: "MeetingTime") as! [String]
        let meetingLocation: [String] = jsonData.value(forKey: "MeetingLocation") as! [String]
        
 
        /*Initial received invitations. */
        let aReceivedInvitation = Invitation(InvitationId: invitationID,MeetingName: meetingName, MeetingDescription: meetingDescription, MeetingTime: meetingTime, MeetingLocation: meetingLocation, InvitedFriendEmail: invitedEmail, InviterFriendEmail: inviterEmail,selectedMeetingTime: "", selectedMeetingLocation: "", haveSelectedMeetingTimeFlag: false, haveSelectedMeetingLocationFlag: false)
        
        showReceivedInvitationsTabbar(aReceivedInvitation)
        
    }
    
    /* Process the http response from remote server after sending http request which asked for invitation information according to invitation ID. */
    func receivedInvitationInfoFromRemoteServer(_ invitationID: NSNumber, data: Data, response: URLResponse) -> Void {
  
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response status code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(invitationID, statusCode: statusCode, data: data, processSuccessfulHttpResponse: succeedToGetTheInvitationInfo, processFailureHttpResponse: failedToGetTheInvitationInfo)
        
    }
    
    /* Process the received push notifications on new inviation for invited user. */
    func notifyNewInvitationForInvitedUser(_ invitationID: NSNumber, eventType: NSInteger) -> Void {
       
        NSLog("#########Received push notification 1 ==> Notify invited user about coming new invitation")
 
        /* Send Http message to supported web server in order to get the invitation information. */
        let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getinvitationinfo.php")!  // the web link of the provider.
        
        // Compose request information.
        let postString: NSString = "iInvitationID=\(invitationID)" as NSString
        
        let request = createHttpPostRequest(url, postString: postString)

        interactionWithRemoteServerForAnInvitationThroughHttpPost(invitationID, request: request,  processResponseFunc: self.receivedInvitationInfoFromRemoteServer, failToGetHttpResponse: self.failedToGetTheInvitationInfo)

    }
    
  
    /*  Failed to get the invitation meeting time. */
    func failedToGetTheInvitationMeetingTime(_ invitationID: NSNumber, errorMsg: NSString) -> Void {
  
        let title = "Failed To Get Invitation meeting time!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }
    
    /*Find the matched index in the sent invitations table view controller. */
    func findIndexInSentInvitationTablesByInvitaionId(_ invitationID: NSNumber, sentInvitationsVC: MUSentInvitationsTableViewController) -> (matchResult: Bool, matchedIndex: IndexPath) {
        
        
        var matchResult: Bool = false    /* The result of unMatched. */
        var matchedIndex: IndexPath = IndexPath(row: 0, section: 0) /*Initialization. */
        

        
        /*Find the matched row according to invitation ID. */
        for section in 0..<sentInvitationsVC.tableView.numberOfSections {
            
            for row in 0..<sentInvitationsVC.tableView.numberOfRows(inSection: section) {
                
                let indexPath = IndexPath(row: row, section: section)
                
                
                if(sentInvitationsVC.Invitations[(indexPath as NSIndexPath).row].InvitationId == invitationID)
                {
                    matchResult = true
                    matchedIndex = indexPath
                    
                } // end of if(sentInvitationsVC.Invitations[indexPath.row].InvitationId == invitationID)
                
            }  //end of for row in 0..<sentInvitationsVC.tableView.numberOfRowsInSection(section)
        }  // end of for section in 0..<sentInvitationsVC.tableView.numberOfSections
        
        return (matchResult, matchedIndex)

    }
    
    /* Update selected meeting time for the invitation in the corresponding row in sent invitations view controller. */
    func updateMeetingTimeForTheInvitationInfo(_ invitation: Invitation, selectedMeetingTime: String) -> Void {
        
        invitation.haveSelectedMeetingTimeFlag = true
        
        invitation.MeetingTime.removeAll()
        
        invitation.MeetingTime.append(selectedMeetingTime)
        
        invitation.selectedMeetingTime = selectedMeetingTime
    }
    
    
    /*Get the SentInvitations table view controller. */
    func getSentInvitationsTableVC() -> MUSentInvitationsTableViewController {
        
        let navigationVC: UINavigationController = self.tabBarController?.viewControllers![0] as! UINavigationController
        
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        navigationVC.navigationBar.isTranslucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let sentInvitationsVC: MUSentInvitationsTableViewController = navigationVC.viewControllers[0] as! MUSentInvitationsTableViewController
        
        return sentInvitationsVC
    }
    
    
    
    /*  Pass meeting time to detail sent invitation and show the detail sent invitation to the user. */
    func passMeetingTimeToDetailSentInvitationsTabbar(_ invitationID: NSNumber, selectedMeetingTime: String) -> Void {

        DispatchQueue.main.async(execute: {
            
            let sentInvitationsVC: MUSentInvitationsTableViewController = self.getSentInvitationsTableVC()
            
            let result = self.findIndexInSentInvitationTablesByInvitaionId(invitationID, sentInvitationsVC: sentInvitationsVC)
            
            if (result.matchResult)
            {
                
                self.updateMeetingTimeForTheInvitationInfo(sentInvitationsVC.Invitations[(result.matchedIndex as NSIndexPath).row], selectedMeetingTime: selectedMeetingTime)
                
                
                sentInvitationsVC.tableView(sentInvitationsVC.tableView, didSelectRowAt: result.matchedIndex)
                
                sentInvitationsVC.performSegue(withIdentifier: "SegueToDetailSentInvitationVC", sender: self)
                
                
                let title = "Check selected meeting time!"
                let message = "Meeting time has been selected by the invited user, please have a check!"
                sendAlertView(title, message: message)

            }
            
            
        })  // end of dispatch_async(dispatch_get_main_queue()

        
    }
    
    
    /*  Succeed to get the invitation meeting time. */
    func succeedToGetTheInvitationMeetingTime(_ invitationID: NSNumber, jsonData: NSDictionary) -> Void {
        
        /*Get information from response. */
        let selectedMeetingTime: String = jsonData.value(forKey: "SelectedMeetingTime") as! String
        
        NSLog("selectedMeetingTime ==> %@", selectedMeetingTime)
        
        passMeetingTimeToDetailSentInvitationsTabbar(invitationID, selectedMeetingTime: selectedMeetingTime)
  
        
    }
    
    /* Process the http response from remote server after sending http request which asked for invitation meeting time according to invitation ID. */
    func receivedInvitationMeetingTimeFromRemoteServer(_ invitationID: NSNumber, data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response status code: %ld", statusCode);
        
        processHttpResponseAccordingToStatusCode(invitationID, statusCode: statusCode, data: data, processSuccessfulHttpResponse: succeedToGetTheInvitationMeetingTime, processFailureHttpResponse: failedToGetTheInvitationMeetingTime)
        
    }
    
    /* Process the received push notifications on notifying selected meeting time for inviter user. */
    func notifySelectedTimeForInviterUser(_ invitationID: NSNumber, eventType: NSInteger) -> Void {
        
        NSLog("#########Received push notification 2 ==> Notify inviter user about selected time.")
        
        /* Send Http message to supported web server in order to get selected meeting time for the inviter user. */
        let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getselectedmeetingtime.php")!  // the web link of the provider.
        // Compose request information.
        let postString: NSString = "iInvitationID=\(invitationID)" as NSString
    
        let request = createHttpPostRequest(url, postString: postString)
        
        interactionWithRemoteServerForAnInvitationThroughHttpPost(invitationID, request: request,  processResponseFunc: self.receivedInvitationMeetingTimeFromRemoteServer, failToGetHttpResponse: self.failedToGetTheInvitationMeetingTime)
            
    }
    
    
    /*  Failed to get the invitation meeting Location. */
    func failedToGetTheInvitationMeetingLocation(_ invitationID: NSNumber, errorMsg: NSString) -> Void {
      
        let title = "Failed To Get Invitation Information!"
        let message = errorMsg as String
        sendAlertView(title, message: message)
        
    }

    /* Update selected meeting location for the invitation in the corresponding row in sent invitations view controller. */
    func updateMeetingLocationForTheInvitationInfo(_ invitation: Invitation, selectedMeetingLocation: String) -> Void {
        
        invitation.haveSelectedMeetingLocationFlag = true
        
        invitation.selectedMeetingLocation = selectedMeetingLocation
        
        invitation.MeetingLocation.removeAll()
        
        invitation.MeetingLocation.append(selectedMeetingLocation)
        
        invitation.selectedMeetingLocation = selectedMeetingLocation
        
    }
    
    
    /*  Pass meeting locaitoin to detail sent invitation and show the detail sent invitation to the user. */
    func passMeetingLocationToDetailSentInvitationsTabbar(_ invitationID: NSNumber, selectedMeetingLocation: String) -> Void {
        
        DispatchQueue.main.async(execute: {
            
            
            let sentInvitationsVC: MUSentInvitationsTableViewController = self.getSentInvitationsTableVC()
            
            let result = self.findIndexInSentInvitationTablesByInvitaionId(invitationID, sentInvitationsVC: sentInvitationsVC)
            
            if (result.matchResult)
            {
                self.updateMeetingLocationForTheInvitationInfo(sentInvitationsVC.Invitations[(result.matchedIndex as NSIndexPath).row], selectedMeetingLocation: selectedMeetingLocation)
                
                sentInvitationsVC.tableView(sentInvitationsVC.tableView, didSelectRowAt: result.matchedIndex)
                
                sentInvitationsVC.performSegue(withIdentifier: "SegueToDetailSentInvitationVC", sender: self)
                
                
                let title = "Check selected meeting location!"
                let message = "Meeting location has been selected by the invited user, please have a check!"
                sendAlertView(title, message: message)
                
            }
            
            
        })

        
    }
    
    
    /*  Succeed to get the invitation meeting locagtion. */
    func succeedToGetTheInvitationMeetingLocation(_ invitationID: NSNumber, jsonData: NSDictionary) -> Void {
    
        /*Get information from response. */
        let selectedMeetingLocation: String = jsonData.value(forKey: "SelectedMeetingLocation") as! String
        
        NSLog("selectedMeetingLocation ==> %@", selectedMeetingLocation);

        passMeetingLocationToDetailSentInvitationsTabbar(invitationID, selectedMeetingLocation: selectedMeetingLocation)
        
    }
    
    
    /* Process the http response from remote server after sending http request which asked for invitation meeting location according to invitation ID. */
    func receivedInvitationMeetingLocationFromRemoteServer(_ invitationID: NSNumber, data: Data, response: URLResponse) -> Void {
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        NSLog("Response code: %ld", statusCode);
        
        
        processHttpResponseAccordingToStatusCode(invitationID, statusCode: statusCode, data: data, processSuccessfulHttpResponse: succeedToGetTheInvitationMeetingLocation, processFailureHttpResponse: failedToGetTheInvitationMeetingLocation)

    }
    
    
    /* Process the received push notifications on notifying selected meeting location for invited user. */
    func notifySelectedLocationForInviterUser(_ invitationID: NSNumber, eventType: NSInteger) -> Void {

        NSLog("#########Received push notification 3 ==> Notify inviter user about selected location.")
        
        /* Send Http message to supported web server in order to get selected meeting location for the inviter user. */
        let url: URL = URL(string: "http://192.168.0.3.xip.io/~chongzhengzhang/php/getselectedmeetinglocation.php")!  // the web link of the provider.
        // Compose request information.
        let postString: NSString = "iInvitationID=\(invitationID)" as NSString
        
        let request = createHttpPostRequest(url, postString: postString)
        
        interactionWithRemoteServerForAnInvitationThroughHttpPost(invitationID, request: request,  processResponseFunc: self.receivedInvitationMeetingLocationFromRemoteServer, failToGetHttpResponse: failedToGetTheInvitationMeetingLocation)
   
    }
    
    


    
    
    /* Process the received push notifications on reminding the incoming meeting for inviter user. */
    func notifyIncomingMeetingForInviterUser(_ invitationID: NSNumber, eventType: NSInteger) -> Void {
        
        NSLog("#########Received push notification 4 ==> Notify inviter user about meeting starting.")
        
        //                      dispatch_async(dispatch_get_main_queue(), {
        
        let navigationVC: UINavigationController = self.tabBarController?.viewControllers![0] as! UINavigationController
        
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        navigationVC.navigationBar.isTranslucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let sentInvitationsVC: MUSentInvitationsTableViewController = navigationVC.viewControllers[0] as! MUSentInvitationsTableViewController
        
        // let sentInvitationsVC: MUSentInvitationsTableViewController = navigationVC.topViewController as! MUSentInvitationsTableViewController
        
        
        for section in 0..<sentInvitationsVC.tableView.numberOfSections {
            
            for row in 0..<sentInvitationsVC.tableView.numberOfRows(inSection: section) {
                
                let indexPath = IndexPath(row: row, section: section)
                
                if (sentInvitationsVC.Invitations[(indexPath as NSIndexPath).row].InvitationId == invitationID)
                {
                    
                    sentInvitationsVC.tableView(sentInvitationsVC.tableView, didSelectRowAt: indexPath)
                    sentInvitationsVC.performSegue(withIdentifier: "SegueToDetailSentInvitationVC", sender: self)
                    
                }
                
                
            }
        }

        
    }
    
    /*Find the matched index in the received invitations table view controller. */
    func findIndexInReceivedInvitationTablesByInvitaionId(_ invitationID: NSNumber, ReceivedInvitationsVC: MUReceivedInvitationsTableViewController) -> (matchResult: Bool, matchedIndex: IndexPath) {
        
        
        var matchResult: Bool = false    /* The result of unMatched. */
        var matchedIndex: IndexPath = IndexPath(row: 0, section: 0) /*Initialization. */
        
  
        /*Find the matched row according to invitation ID. */
        for section in 0..<ReceivedInvitationsVC.tableView.numberOfSections {
            
            for row in 0..<ReceivedInvitationsVC.tableView.numberOfRows(inSection: section) {
                
                let indexPath = IndexPath(row: row, section: section)
                
                
                if(ReceivedInvitationsVC.receivedInvitations[(indexPath as NSIndexPath).row].InvitationId == invitationID)
                {
                    matchResult = true
                    matchedIndex = indexPath
                    
                } // end of if(ReceivedInvitationsVC.Invitations[indexPath.row].InvitationId == invitationID)
                
            }  //end of for row in 0..<ReceivedInvitationsVC.tableView.numberOfRowsInSection(section)
        }  // end of for section in 0..<ReceivedInvitationsVC.tableView.numberOfSections
        
        return (matchResult, matchedIndex)
        
    }

    
    
    /*Get the ReceivedInvitations table view controller. */
    func getReceivedInvitationsTableVC() -> MUReceivedInvitationsTableViewController {
        
        let navigationVC: UINavigationController = self.tabBarController?.viewControllers![1] as! UINavigationController
        
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        navigationVC.navigationBar.isTranslucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let ReceivedInvitationsVC: MUReceivedInvitationsTableViewController = navigationVC.viewControllers[0] as! MUReceivedInvitationsTableViewController
        
        return ReceivedInvitationsVC
    }
    
    /* Process the received push notifications on reminding the incoming meeting for invited user. */
    func notifyIncomingMeetingForInvitedUser(_ invitationID: NSNumber, eventType: NSInteger) -> Void {
        
        NSLog("#########Received push notification 5 ==> Notify invited user about meeting starting.")
        

        let ReceivedInvitationsVC: MUReceivedInvitationsTableViewController = self.getReceivedInvitationsTableVC()
     
        let result = self.findIndexInReceivedInvitationTablesByInvitaionId(invitationID, ReceivedInvitationsVC: ReceivedInvitationsVC)
        
        if (result.matchResult)
        {
            ReceivedInvitationsVC.tableView(ReceivedInvitationsVC.tableView, didSelectRowAt: result.matchedIndex)
            
            ReceivedInvitationsVC.performSegue(withIdentifier: "SegueToDetailInvitationVC", sender: self)
        }
        
        
    }

}


// End of AppDelegate.swift

