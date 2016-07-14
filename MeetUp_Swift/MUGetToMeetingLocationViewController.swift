//
//  MUGetToMeetingLocationViewController.swift
//  MeetUp_Swift
//
//  Created by Chongzheng Zhang on 3/02/2016.
//  Copyright © 2016 Chongzheng Zhang. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MUGetToMeetingLocationViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    

    @IBOutlet var MapView: MKMapView!
   
   
    class myMapAnnotation : NSObject, MKAnnotation {
        var coordinate: CLLocationCoordinate2D
        var title: String?
        var subtitle: String?
        
        init(coordinate: CLLocationCoordinate2D, title: String, subtitle: String) {
            self.coordinate = coordinate
            self.title = title
            self.subtitle = subtitle
        }
    }
    
    
    var selectedMeetingLocationAddress: String!
    var selectedMeetingLocationCoordinate: CLLocationCoordinate2D!
    
    var currentUserAddressCoordinate = CLLocationCoordinate2D()
    
    let locationManager = CLLocationManager()

    /*Set location manager parameters for the map view. */
    func setLocationManagerParameters(locationManager: CLLocationManager) -> Void {
        
        // Ask for Authorisation from the User. For use in background.
        locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
            locationManager.startUpdatingLocation()
        }
    }
    


    
    override func viewDidLoad() {
        super.viewDidLoad()

        /*Set location manager parameters for the map view. */
        setLocationManagerParameters(locationManager)

        self.MapView.delegate = self
        
        MapView.showsUserLocation = true  // used to show current user location.
        
        /*Show meeting location address in the map view. */
        let destinationTitle = "Meeting Location"
        
        showRoutesToDestinationLocationAddressInTheMapView(self.MapView, currentUserCoordinate:self.currentUserAddressCoordinate, destinationLocationAddress: self.selectedMeetingLocationAddress!, destinationTitle: destinationTitle)
        
//        if (showAddressResult.findCoordinateFlag)
//        {
//            showRouteFromCurrentLocationToDestinationLocation(self.MapView, currentUserAddressCoordinate: self.currentUserAddressCoordinate, destinationLocationCoordinate: showAddressResult.destinationCoordinate)
//        }
 
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        
        currentUserAddressCoordinate = newLocation.coordinate
        
        self.MapView.showsUserLocation = true
        
        NSLog("didUpdateToLocation-currentUserAddressCoordinate.latitude:%d", self.currentUserAddressCoordinate.latitude)
        NSLog("didUpdateToLocation-currentUserAddressCoordinate.longitude:%d", self.currentUserAddressCoordinate.longitude)
        
        
        //       MKCoordinateRegionMakeWithDistance(currentUserAddressCoordinate, 1000, 1000)
        
        
        let span = MKCoordinateSpanMake(0.02, 0.02)
        
        let region = MKCoordinateRegionMake(currentUserAddressCoordinate, span)
        
        self.MapView.setRegion(region, animated: true)
        
        self.MapView.setCenterCoordinate(currentUserAddressCoordinate, animated: true)
        self.MapView.centerCoordinate = self.currentUserAddressCoordinate
        
        
        locationManager.stopUpdatingLocation()

        
    }

    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        let renderer = MKPolylineRenderer(polyline: overlay as! MKPolyline)
        renderer.strokeColor = UIColor.blueColor()
    
        renderer.alpha = 0.7;
        renderer.lineWidth = 4.0;

    
        return renderer
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if (annotation is MKUserLocation) {
            //if annotation is not an MKPointAnnotation (eg. MKUserLocation),
            //return nil so map draws default view for it (eg. blue dot)...
            return nil
        }
        
        let reuseId = "test"
        
        
        var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        if anView == nil {
            anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            //  anView!.image = UIImage(named:"meetupIcon.png")
           //  anView?.pinColor = getRightPinColor(annotation.title!!)
            
            if #available(iOS 9.0, *) {
                anView?.pinTintColor = getRightPinTintColor(annotation.title!!)
            } else {
                // Fallback on earlier versions
            }
            

            anView!.canShowCallout = true
            
            
        }
        else {
            //we are re-using a view, update its annotation reference...
            anView!.annotation = annotation
        }
        
        if #available(iOS 9.0, *) {
            anView?.rightCalloutAccessoryView = estimatedTimeArrivalCallOut(annotation)
            
            
            
            
        } else {
            // Fallback on earlier versions
        }
        

        return anView
    }
    
    
    func estimatedTimeArrivalCallOut(annotation: MKAnnotation) -> UIView {
        
        let etsUIView = UIView()
        
//        let label = UILabel()
//        
//        label.text = "What is that"
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 0
//        
//        etsUIView.addSubview(label)
        
        etsUIView.backgroundColor = .greenColor()
        
        
        
        let widthConstraint = NSLayoutConstraint(item: etsUIView, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 40)
        etsUIView.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: etsUIView, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        etsUIView.addConstraint(heightConstraint)
        
        return etsUIView
        
    }
    
//    func mapView(mapView: MKMapView, didDeselectAnnotationView view: MKAnnotationView) {
//        
//        if ((view.annotation?.title)! != "Meeting location")
//        {
//            view.selected = true
//            self.MapView.selectAnnotation(view.annotation!, animated: true)
//        }
//        
//    }
    
    
    
    func getRightPinColor (pinName:String)-> MKPinAnnotationColor{
        
        var correctPin = MKPinAnnotationColor.init(rawValue: 0)
        
        switch pinName
        {
        case "Meeting location":
            correctPin = MKPinAnnotationColor.Red
            break
        default:
            correctPin = MKPinAnnotationColor.Purple
            break
            
        }
        
        return correctPin!
    }
    
    func getRightPinTintColor (pinName:String)-> UIColor{
        
        var correctTintPin = UIColor()
        
        switch pinName
        {
        case "Meeting location":
            correctTintPin = UIColor.redColor()
            break
        default:
            correctTintPin = UIColor.clearColor()
            break
        }
        
        return correctTintPin
    }
    
//
//    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
//
//     //   for view in views {
//        
//          //  view.selected = true
//         //   mapView.selectAnnotation(view.annotation!, animated: true)
//     //  }
//        
//    }
    
    

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
