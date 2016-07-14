


<?php

	include('dbconnect.php');
	
	$strInviterEmail	= $_POST["sInviterEmail"];
    $strInvitedEmail	= $_POST["sInvitedEmail"];
	$strMeetingName		= $_POST["sMeetingName"];
	$strMeetingDescription		= $_POST["sMeetingDescription"];
	
	
	//$arrayMeetingTime	= (Array)$_POST["asMeetingTime"];
	//$arrayMeetingLocation = (Array)$_POST["asMeetingLocation"];
	
	$arrayMeetingTime = json_decode($_POST["asMeetingTime"], true);
	$arrayMeetingLocation = json_decode($_POST["asMeetingLocation"], true);
	
    $iMeetingTimeNum	= $_POST["iMeetingTimeNum"];
    $iMeetingLocationNum	= $_POST["iMeetingLocationNum"];
    
    
    $arr = null;
    
    /* Just for test. */
    $arr["InviterEmail"] = $strInviterEmail;
    $arr["InvitedEmail"] = $strInvitedEmail;
    $arr["MeetingName"] = $strMeetingName;
    $arr["MeetingDescription"] = $strMeetingDescription;
    $arr["MeetingTime"] = $arrayMeetingTime;
    $arr["MeetingLocation"] = $arrayMeetingLocation;
    $arr["MeetingTimeNum"] = $iMeetingTimeNum;
    $arr["MeetingLocationNum"] = $iMeetingLocationNum;

    
    /*** Insert the information in the invitation table. ***/
    $strSQL = "INSERT INTO `meetupdb`.`invitations` (`InviterEmail`, `InvitedEmail`, `MeetingName`, `MeetingDescription`)
    VALUES ('$strInviterEmail', '$strInvitedEmail', '$strMeetingName', '$strMeetingDescription')";
    
    $objQuery = mysql_query($strSQL);
    
    if(!$objQuery) // Insert error.
    {
    
	    $arr["Success"] = "0";  // (0=Failed , 1=Complete)
    
        $arr["error_message"] = "Cannot save invitation data!";
    
        echo json_encode($arr);
    
        echo mysql_error();
    
        exit();
    
    }
    else
    {
	    
	    $invitationID = mysql_insert_id();
	    
	    $arr["InvitationID"] = $invitationID;
	    
	    /*** Insert the information in the invitationtimes table. ***/
	    foreach($arrayMeetingTime as $value)
	    {
	    	$strSQL = "INSERT INTO `meetupdb`.`invitationtimes` (`InvitationID`, `MeetingTime`)
	        			VALUES ('$invitationID', '$value')";
	
	    	$objQuery = mysql_query($strSQL);
	    	
	    	if(!$objQuery) // Insert error.
	    	{
	    	
				$arr["Success"] = "0";  // (0=Failed , 1=Complete)
	    		
	    		$arr["error_message"] = "Cannot save time data!";
	    	
	    		echo json_encode($arr);
	    	
	    		echo mysql_error();
	    	
	    		exit();
	    		break;
	    	
	    	}
	    }
	    
	    /*** Insert the information in the invitationlocations table. ***/
	    foreach($arrayMeetingLocation as $value)
	    {
			$strSQL = "INSERT INTO `meetupdb`.`invitationlocations` (`InvitationID`, `MeetingLocation`)
						VALUES ('$invitationID', '$value')";
	     	
	     	$objQuery = mysql_query($strSQL);
	     	
	     	if(!$objQuery) // Insert error.
	     	{
	     	
	     		$arr["Success"] = "0";  // (0=Failed , 1=Complete)
	     	
	     		$arr["error_message"] = "Cannot save location data!";
	     	
	     		echo json_encode($arr);
	     			
	     		echo mysql_error();
	     	
	     		exit();
	     		break;
	     	
	     	}
		}
	    
		$arr["Success"] = "1";  // (0=Failed , 1=Complete)
	    
		$arr["error_message"] = "Save the invitation successfully!";
	    
		echo json_encode($arr);
	    
		exit();
	    
	}
    
    mysql_close($objConnect);
    
?>