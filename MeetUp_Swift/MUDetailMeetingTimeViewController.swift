//
//  MUDetailMeetingTimeViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/12/2015.
//  Copyright © 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit

class MUDetailMeetingTimeViewController: UIViewController, UIPickerViewDelegate {


    @IBOutlet weak var meetingTimePicker: UIPickerView!
    
    var sourceVcType: Int? //    0-Sent Invitation VC, 1-Received Invitation VC
    
    var HaveSelected: Int? //    0-not selected, 1-selected
    
    var  meetingTimeArray = [String]()
    
    var  selectedMeetingTime: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        meetingTimePicker.delegate = self
   
        if ((self.sourceVcType != GlobalConstants.kReceivedInvitationVC) || (self.HaveSelected == 1))  // Need to hide the "Select" right bar button Item.
        {
            self.navigationController?.navigationItem.rightBarButtonItem = nil
            
            self.navigationItem.rightBarButtonItems = nil
            
        }


        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(animated: Bool)
    {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if ((self.HaveSelected != nil) && (self.HaveSelected == 1))
        {
            return 1
            
        }
        else{
            
            return meetingTimeArray.count
        }
        
        
    }
    
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if ((self.HaveSelected != nil) && (self.HaveSelected == 1))
        {
            return selectedMeetingTime
            
        }
        else{
            
            return meetingTimeArray[row]
        }
        
    }
    
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
//        
//            let cell:UITableViewCell = UITableViewCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: nil)
//            
//            cell.backgroundColor = UIColor.clearColor()
//        
//        // cell.tag = 10
//            
//           // cell.accessoryType = UITableViewCellAccessoryType.Checkmark
//        
//    
//            cell.textLabel?.text = meetingTimeArray[row]
// 
//
//            return cell;
//        }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
