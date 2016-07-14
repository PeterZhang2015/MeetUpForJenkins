//
//  MUDetailInviterFriendViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 19/12/2015.
//  Copyright © 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUDetailInviterFriendViewController: UIViewController {

    
    @IBOutlet weak var inviterEmail: UITextView!
  
 
    var InviterFriendEmail: String?
    
    @IBAction func cancelForDetailInviterFriendVC(segue:UIStoryboardSegue) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        inviterEmail.userInteractionEnabled = true
        inviterEmail.editable = false
        
        inviterEmail.text = InviterFriendEmail!
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
