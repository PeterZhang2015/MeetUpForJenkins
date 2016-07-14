//
//  MUConstant.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 5/12/16.
//  Copyright © 2016 Chongzheng Zhang. All rights reserved.
//

import Foundation

struct GlobalConstants {
    
    /* Event type of received push notification.  */
    
    // 1-------Notify invited user about coming new invitation. 2-------Notify inviter user about selected time. 3-------Notify inviter user about selected location. 4-------Notify inviter user about meeting starting. 5-------Notify invited user about meeting starting.
    static let kNewInvitationForInvitedUser = 1
    
    static let kSelectedTimeForInviterUser = 2
    
    static let kSelectedLocationForInviterUser = 3
    
    static let kMeetingRemindForInviterUser = 4
    
    static let kMeetingRemindForInvitedUser = 5
    
    /* Device constant.  */
    static let kdeviceToken = "deviceTokenKey"   //Set constant for getting device token.
    
    
    /* ViewController Type.  */
    static let kSentInvitationVC = 0 //    0-Sent Invitation VC, 1-Received Invitation VC
    static let kReceivedInvitationVC = 1

    
}