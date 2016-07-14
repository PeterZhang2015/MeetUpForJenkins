//
//  MUSettingsTableViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

import FBSDKCoreKit
import FBSDKLoginKit

class MUSettingsTableViewController: UITableViewController ,FBSDKLoginButtonDelegate {
    
    
    @IBAction func cancelForSettingsChangePasswordVC(segue:UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        //super.viewWillAppear(animated);
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        if indexPath.section == 0 {
            
            /* Get the EmailCell according to it's identifier. */
            let Emailcell = tableView.dequeueReusableCellWithIdentifier("SettingsEmailCell", forIndexPath: indexPath)
          
            /*Get AppDelegate. */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            Emailcell.setNeedsLayout()
            
            Emailcell.textLabel!.text = appDelegate.accountInfo?.Email
            
            
         //   Emailcell.layoutIfNeeded()
            
            return Emailcell
      
        }
        

            
        if indexPath.section == 1 {
            
            /* Get the ChangePasswordCell according to it's identifier. */
            let ChangePasswordcell = tableView.dequeueReusableCellWithIdentifier("SettingsChangePasswordCell", forIndexPath: indexPath)

            ChangePasswordcell.setNeedsLayout()
            ChangePasswordcell.textLabel?.hidden = false
            
            ChangePasswordcell.textLabel!.numberOfLines = 0;
                
            ChangePasswordcell.textLabel!.text = "Change Password"
          //  ChangePasswordcell.textLabel!.text = "Change Password"
            
            
          //  ChangePasswordcell.setNeedsLayout()
            
          //  ChangePasswordcell.layoutIfNeeded()

            
        //    tableView.reloadData()
   
            return ChangePasswordcell
            

            
        }
        else
        {
                /* Get the LogOutCell according to it's identifier. */
                let LogOutcell = tableView.dequeueReusableCellWithIdentifier("SettingsLogOutCell", forIndexPath: indexPath)
        
                if indexPath.section == 2 {
        
                    LogOutcell.setNeedsLayout()
                    LogOutcell.textLabel!.text = "LogOut"
                    LogOutcell.textLabel!.numberOfLines = 0;
                    
                    LogOutcell.textLabel!.textColor = UIColor.redColor()
                    LogOutcell.textLabel?.textAlignment = .Center
                    
                    
                  //  LogOutcell.layoutIfNeeded()
                }
            
          //  tableView.reloadData()
            
            return LogOutcell

            
        }
        
//        /* Get the LogOutCell according to it's identifier. */
//        let LogOutcell = tableView.dequeueReusableCellWithIdentifier("SettingsLogOutCell", forIndexPath: indexPath)
//        
//        if indexPath.section == 2 {
//            
//            LogOutcell.textLabel!.text = "LogOut"
//            
//        }
        
        
        
        
        
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
        switch section{
        
        case 0:
            return "Email"
            
        case 1:
            return "Password"
            
//        case 2:
//            return "LogOut"
        
        default:
            return nil

        }
        
        
    }
    
    
    /*Initialize storyboard. */
    func initializeTabBar() -> Void {
        
        let navigationVC: UINavigationController = self.tabBarController?.viewControllers![0] as! UINavigationController
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        navigationVC.navigationBar.translucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let sentInvitationsVC: MUSentInvitationsTableViewController = navigationVC.viewControllers[0] as! MUSentInvitationsTableViewController
        sentInvitationsVC.Invitations.removeAll()
        sentInvitationsVC.haveGotSentInvitationInfo = false
        
        let ReceivedInvitationnavigationVC: UINavigationController = self.tabBarController?.viewControllers![1] as! UINavigationController
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        ReceivedInvitationnavigationVC.navigationBar.translucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let receivedInvitationsVC: MUReceivedInvitationsTableViewController = ReceivedInvitationnavigationVC.viewControllers[0] as! MUReceivedInvitationsTableViewController
        receivedInvitationsVC.receivedInvitations.removeAll()
        receivedInvitationsVC.haveGotReceivedInvitationInfo = false
    }
    
    
    
    /*Process LogOut action in alert controller. */
    func processLogOutActionInAlertController() -> Void {
    
        initializeTabBar()

        dispatch_async(dispatch_get_main_queue(), {
   
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)  // Get the storyboard according to it's name.
            let LaunchViewController = storyboard.instantiateViewControllerWithIdentifier("LaunchVC") as! MULaunchViewController   // Get the MULaunchViewController according to it's storyboard identifier.
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            //  appDelegate.window?.makeKeyAndVisible()
            appDelegate.window?.rootViewController = LaunchViewController
            
        })

    }
    
    /*Process Cancel action in alert controller. */
    func processCancelActionInAlertController() -> Void {
        
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == 2)
        {
            
            //  let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
  
            let LogOutAlert = UIAlertController(title: "Log Out", message: "Log out will not delete any data. You can still log in with this account.", preferredStyle: UIAlertControllerStyle.ActionSheet)
         
            addActionForUIAlertController(LogOutAlert, actionTitle: "Log Out", actionProcess: processLogOutActionInAlertController)
                

            addActionForUIAlertController(LogOutAlert, actionTitle: "Cancel", actionProcess: processCancelActionInAlertController)
            
            
            presentViewController(LogOutAlert, animated: true, completion: nil)
  
            
        }  // end of if (indexPath.section == 2)
 
       // performSegueWithIdentifier("SegueToLogin", sender: self)
        
    }

    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
    
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        
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
