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
    
    
    @IBAction func cancelForSettingsChangePasswordVC(_ segue:UIStoryboardSegue) {
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //super.viewWillAppear(animated);
        
        tableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        

        if (indexPath as NSIndexPath).section == 0 {
            
            /* Get the EmailCell according to it's identifier. */
            let Emailcell = tableView.dequeueReusableCell(withIdentifier: "SettingsEmailCell", for: indexPath)
          
            /*Get AppDelegate. */
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            Emailcell.setNeedsLayout()
            
            Emailcell.textLabel!.text = appDelegate.accountInfo?.Email
            
            
         //   Emailcell.layoutIfNeeded()
            
            return Emailcell
      
        }
        

            
        if (indexPath as NSIndexPath).section == 1 {
            
            /* Get the ChangePasswordCell according to it's identifier. */
            let ChangePasswordcell = tableView.dequeueReusableCell(withIdentifier: "SettingsChangePasswordCell", for: indexPath)

            ChangePasswordcell.setNeedsLayout()
            ChangePasswordcell.textLabel?.isHidden = false
            
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
                let LogOutcell = tableView.dequeueReusableCell(withIdentifier: "SettingsLogOutCell", for: indexPath)
        
                if (indexPath as NSIndexPath).section == 2 {
        
                    LogOutcell.setNeedsLayout()
                    LogOutcell.textLabel!.text = "LogOut"
                    LogOutcell.textLabel!.numberOfLines = 0;
                    
                    LogOutcell.textLabel!.textColor = UIColor.red
                    LogOutcell.textLabel?.textAlignment = .center
                    
                    
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        
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
        navigationVC.navigationBar.isTranslucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let sentInvitationsVC: MUSentInvitationsTableViewController = navigationVC.viewControllers[0] as! MUSentInvitationsTableViewController
        sentInvitationsVC.Invitations.removeAll()
        sentInvitationsVC.haveGotSentInvitationInfo = false
        
        let ReceivedInvitationnavigationVC: UINavigationController = self.tabBarController?.viewControllers![1] as! UINavigationController
        /***It is used to adjust first row of table viewcontroller under the navigation item. otherwise, the first row will moves up and hides under the nav-bar.****/
        ReceivedInvitationnavigationVC.navigationBar.isTranslucent = false
        /***reference: https://github.com/samvermette/SVPullToRefresh/issues/181***/
        
        let receivedInvitationsVC: MUReceivedInvitationsTableViewController = ReceivedInvitationnavigationVC.viewControllers[0] as! MUReceivedInvitationsTableViewController
        receivedInvitationsVC.receivedInvitations.removeAll()
        receivedInvitationsVC.haveGotReceivedInvitationInfo = false
    }
    
    
    
    /*Process LogOut action in alert controller. */
    func processLogOutActionInAlertController() -> Void {
    
        initializeTabBar()

        DispatchQueue.main.async(execute: {
   
            let loginManager = FBSDKLoginManager()
            loginManager.logOut() // this is an instance function
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)  // Get the storyboard according to it's name.
            let LaunchViewController = storyboard.instantiateViewController(withIdentifier: "LaunchVC") as! MULaunchViewController   // Get the MULaunchViewController according to it's storyboard identifier.
            
            /*Get AppDelegate. */
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            //  appDelegate.window?.makeKeyAndVisible()
            appDelegate.window?.rootViewController = LaunchViewController
            
        })

    }
    
    /*Process Cancel action in alert controller. */
    func processCancelActionInAlertController() -> Void {
        
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ((indexPath as NSIndexPath).section == 2)
        {
            
            //  let refreshAlert = UIAlertController(title: "Refresh", message: "All data will be lost.", preferredStyle: UIAlertControllerStyle.Alert)
  
            let LogOutAlert = UIAlertController(title: "Log Out", message: "Log out will not delete any data. You can still log in with this account.", preferredStyle: UIAlertControllerStyle.actionSheet)
         
            addActionForUIAlertController(LogOutAlert, actionTitle: "Log Out", actionProcess: processLogOutActionInAlertController)
                

            addActionForUIAlertController(LogOutAlert, actionTitle: "Cancel", actionProcess: processCancelActionInAlertController)
            
            
            present(LogOutAlert, animated: true, completion: nil)
  
            
        }  // end of if (indexPath.section == 2)
 
       // performSegueWithIdentifier("SegueToLogin", sender: self)
        
    }

    
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
