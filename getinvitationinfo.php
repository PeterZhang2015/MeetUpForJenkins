


<?php

	/*** Connect to the server database. ***/
	$conn = mysqli_connect("localhost", "meetupap", "Hotmail28?", "meetupap_meetupdb");
	
	if (!$conn)
	{
		die('Could not connect: ' . mysql_error());
	}

	/*Get invitationID from POST message. */
	$iInvitationID		= $_POST["iInvitationID"];
	

	/*Initialize return array. */
    $arr = null;
    
    
    /*** Get the information in the invitation table. ***/
	$strSQL = "SELECT MeetingName, MeetingDescription, InviterEmail, InvitedEmail FROM invitations WHERE InvitationID = '".$iInvitationID."' ";
	$objQuery = mysqli_query($conn, $strSQL);
	//$objResult = mysql_fetch_array($objQuery, MYSQL_ASSOC);
	$objResult = mysqli_fetch_array($objQuery);
	if(!$objResult)   // invitationID does not exist. 
	{
		$arr["Success"] = "0";   // (0=Failed , 1=Complete)
		$arr["error_message"] = "Invitation ID does not exist!";
		
		echo json_encode($arr);
		exit();
	}
	
	$arr["MeetingName"] = $objResult['MeetingName'];
	$arr["MeetingDescription"] = $objResult['MeetingDescription'];
	$arr["InviterEmail"] = $objResult['InviterEmail'];
	$arr["InvitedEmail"] = $objResult['InvitedEmail'];
	
	/*** Get the information in the invitationtimes table. ***/
	$strSQL = "SELECT MeetingTime FROM invitationtimes WHERE InvitationID = '".$iInvitationID."' ";
	$objQuery = mysqli_query($conn, $strSQL);
	
	$arr["MeetingTimeNum"] = "0";
	$i=0;
	while ($objResult = mysqli_fetch_array($objQuery))
	{
		$arr["MeetingTime"][$i] = $objResult['MeetingTime'];
		$i =  $i + 1;
	}

	$arr["MeetingTimeNum"] = $i;
	
	/*** Get the information in the invitationlocations table. ***/
	$strSQL = "SELECT MeetingLocation FROM invitationlocations WHERE InvitationID = '".$iInvitationID."' ";
	$objQuery = mysqli_query($conn, $strSQL);
	
	$arr["MeetingLocationNum"] = "0";
	$i=0;
	while ($objResult = mysqli_fetch_array($objQuery))
	{
		$arr["MeetingLocation"][$i] = $objResult['MeetingLocation'];
		$i =  $i + 1;
	}
	$arr["MeetingLocationNum"] = $i;

	$arr["Success"] = "1";    // (0=Failed , 1=Complete)
    // Return debug information.
	echo json_encode($arr);
	exit();
    

    
    
?>