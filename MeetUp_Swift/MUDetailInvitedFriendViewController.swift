//
//  MUDetailInvitedFriendViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 3/09/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUDetailInvitedFriendViewController: UIViewController {
    
    @IBOutlet weak var invitedEmailAddress: UITextView!
 
    var InvitedFriendEmail: String?



    override func viewDidLoad() {
        super.viewDidLoad()
        

        invitedEmailAddress.userInteractionEnabled = true
        invitedEmailAddress.editable = false
        
        invitedEmailAddress.text = InvitedFriendEmail!

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        //InvitedFriendEmailLabel.text = InvitedFriendEmail
        
        
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
