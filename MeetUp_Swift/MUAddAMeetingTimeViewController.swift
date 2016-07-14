//
//  MUAddAMeetingTimeViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 2/09/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUAddAMeetingTimeViewController: UIViewController {
    
    
    
    
    @IBOutlet weak var newMeetingTime: UIDatePicker!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let currentDate = NSDate()  // get the current date
        newMeetingTime.minimumDate = currentDate
        
        
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
