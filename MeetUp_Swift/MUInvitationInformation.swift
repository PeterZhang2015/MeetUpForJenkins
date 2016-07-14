//
//  MUInvitationInformation.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 28/08/2015.
//  Copyright (c) 2015 Chongzheng Zhang. All rights reserved.
//

import UIKit



class Invitation {
    
    // Define properties.
    var InvitationId: NSNumber
    
    var InvitedFriendEmail: String
    var InviterFriendEmail: String
    
    var MeetingDescription: String
    
    var MeetingLocation: [String]
    var MeetingName: String
    var MeetingTime: [String]
    
    var haveSelectedMeetingTimeFlag: Bool
    var haveSelectedMeetingLocationFlag: Bool
    
    var selectedMeetingTime: String
    var selectedMeetingLocation: String
    

  
    // Initialize stored properties.
    init(InvitationId: NSNumber, MeetingName: String, MeetingDescription: String, MeetingTime: [String], MeetingLocation: [String],InvitedFriendEmail: String, InviterFriendEmail: String,selectedMeetingTime: String, selectedMeetingLocation: String, haveSelectedMeetingTimeFlag: Bool, haveSelectedMeetingLocationFlag: Bool) {
        
        self.InvitationId = InvitationId
        self.MeetingName = MeetingName
        self.MeetingDescription = MeetingDescription
        self.MeetingTime = MeetingTime
        self.MeetingLocation = MeetingLocation
        self.InvitedFriendEmail = InvitedFriendEmail
        self.InviterFriendEmail = InviterFriendEmail
        self.selectedMeetingTime = selectedMeetingTime
        self.selectedMeetingLocation = selectedMeetingLocation
        self.haveSelectedMeetingTimeFlag = haveSelectedMeetingTimeFlag
        self.haveSelectedMeetingLocationFlag = haveSelectedMeetingLocationFlag
        
    }
    
}

class InvitationInformation {
    
    // Define properties.
    var Invitations: [Invitation]

    
    // Initialize stored properties.
    init(Invitations: [Invitation]) {
        
        self.Invitations = Invitations
    }

    
}

class AccountInfo {
    
    // Define properties.
    var Email: String
    var Password: String
    
    // Initialize stored properties.
    init(Email: String, Password: String) {
        
        self.Email = Email
        self.Password = Password
    }
    
    
}



    