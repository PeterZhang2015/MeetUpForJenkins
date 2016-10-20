//
//  MUDetailMeetingTimeViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 25/12/2015.
//  Copyright © 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit
import MapKit


class MUDetailMeetingLocationViewController: UIViewController, UIPickerViewDelegate, CLLocationManagerDelegate {


    @IBOutlet weak var meetingLocationPicker: UIPickerView!

    @IBOutlet var GetToMeetLocationButton: UIButton!
    
    var sourceVcType: Int? //    0-Sent Invitation VC, 1-Received Invitation VC
    
    var HaveSelected: Int? //    0-not selected, 1-selected
    
    var  meetingLocationArray = [String]()
    
    var  selectedMeetingLocation: String?
    
    @IBAction func CancelFromGetToMeetingLocationVC(_ segue:UIStoryboardSegue) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*This one is imporant, otherwise program do not know about data source. */
        meetingLocationPicker.delegate = self
        
        if ((self.sourceVcType != GlobalConstants.kReceivedInvitationVC) || (self.HaveSelected == 1))  // Need to hide the "Select" right bar button Item.
        {
            // let oldRightButtom: UIBarButtonItem = (self.navigationController?.navigationItem.rightBarButtonItem)!
            
            self.navigationController?.navigationItem.rightBarButtonItem = nil
            
            self.navigationItem.rightBarButtonItems = nil
            
        }
        
        if (self.HaveSelected == 1)
        {
            GetToMeetLocationButton.isHidden = false
        }
        else
        {
            
            GetToMeetLocationButton.isHidden = true
        }
  
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(_ pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if ((self.HaveSelected != nil) && (self.HaveSelected == 1))
        {
            return 1
            
        }
        else{
          
            return meetingLocationArray.count
        }
        
        
    }
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {

        if ((self.HaveSelected != nil) && (self.HaveSelected == 1))
        {
            return selectedMeetingLocation
            
        }
        else{
            
            return meetingLocationArray[row]
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "SegueToGetToMeetingLocationVC"{  /* Transfer
            from MUDetailMeetingLocationViewController to MUGetToMeetingLocationViewController*/
            
            
            let destinationNavigationController:UINavigationController = segue.destination as! UINavigationController
            
            let getToMeetingLocationVC:MUGetToMeetingLocationViewController = destinationNavigationController.topViewController as! MUGetToMeetingLocationViewController
            
            getToMeetingLocationVC.selectedMeetingLocationAddress = selectedMeetingLocation
    
            
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
