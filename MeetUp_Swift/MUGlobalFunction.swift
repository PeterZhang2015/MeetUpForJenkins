//
//  MUGlobalFunction.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 27/11/2015.
//  Copyright © 2015 Chongzheng Zhang. All rights reserved.
//

import Foundation
import UIKit
import MapKit


/* Send Alert view to the user. */
func sendAlertView(title: String, message: String) {
    
    dispatch_async(dispatch_get_main_queue(), {
        
        let alertView:UIAlertView = UIAlertView()
        alertView.title = title
        alertView.message = message
      //  alertView.delegate = self
        alertView.addButtonWithTitle("OK")
        alertView.show()
    })

}


/* Create Http request to the supported web server. */
func createHttpPostRequest(destinationUrl: NSURL, postString: NSString)-> NSMutableURLRequest {
 
    let request:NSMutableURLRequest = NSMutableURLRequest(URL:destinationUrl)
    
    request.HTTPMethod = "POST";  //Post to PHP in provider.
    
    //Set information as the HTTP body
    request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
    let postData:NSData = postString.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion:true)!
    let postLength:NSString = String( postData.length )
    
    request.setValue(postLength as String, forHTTPHeaderField: "Content-Length")
    
    request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    
    request.setValue("application/json", forHTTPHeaderField: "Accept")

    return request
    
}


/* Send Http request to supported web server for the information of an invitation and process corressponding response for an invitation. */
func interactionWithRemoteServerForAnInvitationThroughHttpPost(invitationID: NSInteger, request: NSMutableURLRequest, processResponseFunc: (NSInteger, NSData, NSURLResponse) -> Void, failToGetHttpResponse: (NSInteger, NSString) -> Void) -> Void {
    
    
    let session = NSURLSession.sharedSession()

    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in

        if (error != nil)
        {
            print("error: \(error)")
            failToGetHttpResponse(invitationID, error!.localizedDescription)
        }
        else
        {
            if ((data != nil) && (response != nil))
            {

                processResponseFunc(invitationID, data!, response!)
                
            }
            else
            {
                let errorMsg = "Unknown error"
                failToGetHttpResponse(invitationID, errorMsg)
            }
        }
    
        })

    task.resume()
}

/* Send Http request to supported web server without invitation information and process corressponding response for an invitation. */
func interactionWithRemoteServerWithoutInvitationThroughHttpPost(request: NSMutableURLRequest, processResponseFunc: (NSData, NSURLResponse) -> Void, failToGetHttpResponse: (NSString) -> Void) -> Void {
    
    
    let session = NSURLSession.sharedSession()
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        
        if (error != nil)
        {
            print("error: \(error)")
            failToGetHttpResponse(error!.localizedDescription)
        }
        else
        {
            if ((data != nil) && (response != nil))
            {
                
                processResponseFunc(data!, response!)
                
            }
            else
            {
                let errorMsg = "Unknown error"
                failToGetHttpResponse(errorMsg)
            }
        }
        
    })
    
    task.resume()
}



/* Process the HTTP response for an invitation according to the status code. */
func processHttpResponseAccordingToStatusCode(invitationID: NSInteger, statusCode: Int, data: NSData, processSuccessfulHttpResponse: (invitationID: NSInteger, jsonData: NSDictionary) -> Void, processFailureHttpResponse: (invitationID: NSInteger, errorMsg: NSString) -> Void) -> Void {
    
    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
    
    if (statusCode >= 200 && statusCode < 300)
    {
        
        let responseData:NSString  = NSString(data:data, encoding:NSUTF8StringEncoding)!
        
        NSLog("Response ==> %@", responseData);
        
        let success:NSString = jsonData.valueForKey("Success") as! NSString
        
        NSLog("Success ==> %@", success);
        
        if(success == "1")
        {
            /*Get required information Successfully. */
            NSLog("Get required information Successfully. ");
            
            processSuccessfulHttpResponse(invitationID: invitationID, jsonData: jsonData)
            
        }
        else
        {
            /*Fail to get required information. */
            NSLog("Fail to get required information. ");
            var error_msg:NSString
            if jsonData["error_message"] as? NSString != nil {
                error_msg = jsonData["error_message"] as! NSString
            }
            else {
                
                error_msg = "Unknown Error"
                
            }
            
            processFailureHttpResponse(invitationID: invitationID, errorMsg: error_msg)
        }
        
    } // if (statusCode >= 200 && statusCode < 300)
    else
    {
        /*Fail to get required information. */
        NSLog("Fail to get required information. ");
        
        let error_msg = "Wrong status code"
        
        processFailureHttpResponse(invitationID: invitationID, errorMsg: error_msg)
    }  // end of the else of if (statusCode >= 200 && statusCode < 300)

}


/* Process the HTTP response without invitation according to the status code. */
func processHttpResponseAccordingToStatusCode(statusCode: Int, data: NSData, processSuccessfulHttpResponse: (jsonData: NSDictionary) -> Void, processFailureHttpResponse: (errorMsg: NSString) -> Void) -> Void {
    
    let jsonData:NSDictionary = (try! NSJSONSerialization.JSONObjectWithData(data, options:NSJSONReadingOptions.MutableContainers )) as! NSDictionary
    
    if (statusCode >= 200 && statusCode < 300)
    {
        
        let responseData:NSString  = NSString(data:data, encoding:NSUTF8StringEncoding)!
        
        NSLog("Response ==> %@", responseData);
        
        let success:NSString = jsonData.valueForKey("Success") as! NSString
        
        NSLog("Success ==> %@", success);
        
        if(success == "1")
        {
            /*Get required information Successfully. */
            NSLog("Get required information Successfully. ");
            
            processSuccessfulHttpResponse(jsonData: jsonData)
            
        }
        else
        {
            /*Fail to get required information. */
            NSLog("Fail to get required information. ");
            var error_msg:NSString
            if jsonData["error_message"] as? NSString != nil {
                error_msg = jsonData["error_message"] as! NSString
            }
            else {
                
                error_msg = "Unknown Error"
                
            }
            
            processFailureHttpResponse(errorMsg: error_msg)
        }
        
    } // if (statusCode >= 200 && statusCode < 300)
    else
    {
        /*Fail to get required information. */
        NSLog("Fail to get required information. ");
        
        let error_msg = "Wrong status code"
        
        processFailureHttpResponse(errorMsg: error_msg)
    }  // end of the else of if (statusCode >= 200 && statusCode < 300)
    
}

/*  Decode arrayMeetingInfo in the JASON value from response of supported web server as an invitation information. */
func decodeInvitationInfo(arryMeetingInfo: AnyObject) -> Invitation {
    
    var oneRowInvitation: Invitation?
    
    let invitationID:NSNumber = arryMeetingInfo["InvitationId"] as! NSNumber
    let meetingName:String = arryMeetingInfo["MeetingName"] as! String
    let meetingDescription:String = arryMeetingInfo["MeetingDescription"] as! String
    let meetingTime:[String] = arryMeetingInfo["MeetingTime"] as! [String]
    let meetingLocation:[String] = arryMeetingInfo["MeetingLocation"] as! [String]
    let invitedFriendEmail:String = arryMeetingInfo["InvitedFriendEmail"] as! String
    let inviterFriendEmail:String = arryMeetingInfo["InviterFriendEmail"] as! String
    let haveSelectedMeetingTimeFlag:Bool = arryMeetingInfo["haveSelectedMeetingTimeFlag"] as! Bool
    let haveSelectedMeetingLocationFlag:Bool = arryMeetingInfo["haveSelectedMeetingLocationFlag"] as! Bool
    
    
    let selectedMeetingTime:String = arryMeetingInfo["selectedMeetingTime"] as! String
    
    let selectedMeetingLocation:String = arryMeetingInfo["selectedMeetingLocation"] as! String
    
    
    oneRowInvitation = Invitation(InvitationId: invitationID,MeetingName: meetingName, MeetingDescription: meetingDescription, MeetingTime: meetingTime, MeetingLocation: meetingLocation, InvitedFriendEmail: invitedFriendEmail, InviterFriendEmail: inviterFriendEmail,selectedMeetingTime: selectedMeetingTime, selectedMeetingLocation: selectedMeetingLocation, haveSelectedMeetingTimeFlag:haveSelectedMeetingTimeFlag, haveSelectedMeetingLocationFlag:haveSelectedMeetingLocationFlag)
    
    return oneRowInvitation!
}


/*Add annotation to Map view. */
func addAnnotationToMapView(mapView: MKMapView, annotationCoordinate: CLLocationCoordinate2D, annotationTitle: String) -> MKPointAnnotation {
    
    let annotation = MKPointAnnotation()
    annotation.coordinate = annotationCoordinate
    annotation.title = annotationTitle
    
    mapView.addAnnotation(annotation)
    
    return annotation
}



/*Get standardTimeExpressionForEstimatedTimeArrival. */
func getStandardTimeExpression(leftTime: NSTimeInterval) -> String {
    
    var leftTimeExpression: String
    
    
    let leftMin = (Int)(leftTime/60)
    
    if (leftMin < 60)
    {
        
        leftTimeExpression = String(format:"%d minutes", (Int)(leftTime/60))
    }
    else{
        
        let leftHour = (Int)(leftMin/60)
        let remainMin = (Int)(leftMin%60)
        
        if (leftHour == 1)
        {
            leftTimeExpression = String(format:"%d hour %d minutes", leftHour, remainMin)
        }
        else{
            
            leftTimeExpression = String(format:"%d hours %d minutes", leftHour, remainMin)
        }
        
    }
    
    return leftTimeExpression
    
}

/*Add EstimatedTimeArrivalToTheMiddlePointOfTheRoute. */
func addEstimatedTimeArrivalToRoute(mapView: MKMapView, route: MKRoute) -> Void {
    
    let points = route.polyline.points()
    
    let leftTime: String = getStandardTimeExpression(route.expectedTravelTime)  // estimated time arrival
    
    let midPoint = points[route.polyline.pointCount/2]
    
    let midCoord: CLLocationCoordinate2D = MKCoordinateForMapPoint(midPoint)
    
    
    let annotation = addAnnotationToMapView(mapView, annotationCoordinate: midCoord, annotationTitle: leftTime)
    
    mapView.selectAnnotation(annotation, animated: true)  // select that annotation to display to the user.
    
}  

/*Show route from current location coordinate to the destination location coordinate in the map view. */
func showRouteFromCurrentLocationToDestinationLocation(mapView: MKMapView, currentUserAddressCoordinate: CLLocationCoordinate2D, destinationLocationCoordinate: CLLocationCoordinate2D) -> Void {
    
    /*******Set route from current location to destination meeting location in the map view. ***********/
    //  let currentLocationCoordinate: CLLocationCoordinate2D = (self.MapView.userLocation.location?.coordinate)!
    
    let request = MKDirectionsRequest()
    request.source = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: currentUserAddressCoordinate.latitude, longitude: currentUserAddressCoordinate.longitude), addressDictionary: nil))
    
    request.destination = MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: destinationLocationCoordinate.latitude, longitude: destinationLocationCoordinate.longitude), addressDictionary: nil))
    
    //request.requestsAlternateRoutes = true
    request.requestsAlternateRoutes = false
    request.transportType = .Automobile
    
    let directions = MKDirections(request: request)

    directions.calculateDirectionsWithCompletionHandler {response, error in
        guard let unwrappedResponse = response else { return }
        
        for route in unwrappedResponse.routes {
            
            addEstimatedTimeArrivalToRoute(mapView, route: route)
     
            mapView.addOverlay(route.polyline)

            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)

        } // end of for route in unwrappedResponse.routes
    }  // end of directions.calculateDirectionsWithCompletionHandler
    
}


/*Show destination location coordinate in the map view. */
func showDestinationLocationCoordinateInTheMapView(mapView: MKMapView, destinationLocationCoordinate: CLLocationCoordinate2D, destinationTitle: String) -> Void {
    
    /*********Add annotation for destination meeting location to the map view.**************/
    let span = MKCoordinateSpanMake(0.02, 0.02)
    
    let region = MKCoordinateRegionMake(destinationLocationCoordinate, span)
    
    mapView.setRegion(region, animated: true)
    
    addAnnotationToMapView(mapView, annotationCoordinate: destinationLocationCoordinate, annotationTitle: destinationTitle)
    
}



/*Show routes to destination location address in the map view. */
func showRoutesToDestinationLocationAddressInTheMapView(mapView: MKMapView, currentUserCoordinate: CLLocationCoordinate2D, destinationLocationAddress: String, destinationTitle: String) ->  Void {
    
   
    /* Pass the information of meeting location coordinate to the MUGetToMeetingLocationViewController*/
    let geocoder = CLGeocoder()
    
    geocoder.geocodeAddressString(destinationLocationAddress, completionHandler: {(placemarks, error) -> Void in
        
        NSLog("Placemark count:%d",(placemarks?.count)!)
        
        if((error) != nil)
        {
            NSLog("Error: %@",(error?.description)!)
            
            let title = "Can not find the address! "
            let message = (error?.description)!
            sendAlertView(title, message: message)
        }
        
        if let placemark = placemarks?.first {
            
            
            let destinationLocationCoordinate = placemark.location?.coordinate
            
            if ((destinationLocationCoordinate) != nil){
                
                showDestinationLocationCoordinateInTheMapView(mapView, destinationLocationCoordinate: destinationLocationCoordinate!, destinationTitle: destinationTitle)
                
                showRouteFromCurrentLocationToDestinationLocation(mapView, currentUserAddressCoordinate: currentUserCoordinate, destinationLocationCoordinate: destinationLocationCoordinate!)
                
                
            }// end of if ((destinationLocationCoordinate) != nil)
        }  // end of if let placemark = placemarks?.first
    })  // end of geocoder.geocodeAddressString
    
    
}


/*Adde action for UIAlertController. */
func addActionForUIAlertController(alertController: UIAlertController ,actionTitle: String, actionProcess:(Void) -> Void) -> Void {
    
    alertController.addAction(UIAlertAction(title: actionTitle, style: .Default, handler: { (action: UIAlertAction!) in
        
        actionProcess()
        
    }))
}




// end of MUGobalFunction.swift













