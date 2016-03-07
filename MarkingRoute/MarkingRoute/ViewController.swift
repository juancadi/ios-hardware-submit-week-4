//
//  ViewController.swift
//  MarkingRoute
//
//  Created by JUAN ANDRÉS CÁRDENAS DIAZ on 6/03/16.
//  Copyright © 2016 JUAN ANDRÉS CÁRDENAS DIAZ. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    @IBOutlet weak var mapTypeSegmentedControl: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    
    
    private let locManager = CLLocationManager()
    private var lastCoordinate : CLLocation? = nil
    private var distanceTraveled: Double = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMapTypeSegmentedControl()
        
        locManager.delegate = self
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.distanceFilter = 50
        locManager.requestWhenInUseAuthorization()
        
        self.setZoomMap(15)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func configureMapTypeSegmentedControl() {
        
        mapTypeSegmentedControl.tintColor = UIColor.blackColor()
        mapTypeSegmentedControl.selectedSegmentIndex = 0
        mapTypeSegmentedControl.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: .ValueChanged)
    }
    
    // MARK: Actions
    func selectedSegmentDidChange(segmentedControl: UISegmentedControl) {
        
        switch segmentedControl.selectedSegmentIndex {
            
        case 0:
            map.mapType = .Standard
            break
            
        case 1:
            map.mapType = .Satellite
            break
            
        case 2:
            map.mapType = .Hybrid
            break
            
        default:
            break
        
        }
        
    }
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == .AuthorizedWhenInUse {
            
            locManager.startUpdatingLocation()
            map.showsUserLocation = true
            
        }else{
            
            locManager.stopUpdatingLocation()
            map.showsUserLocation = false
            
        }
    }
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        map.centerCoordinate = manager.location!.coordinate
        let currentLocation : CLLocation = manager.location!
        
        var mapPoint = CLLocationCoordinate2D()
        mapPoint.latitude = currentLocation.coordinate.latitude
        mapPoint.longitude = currentLocation.coordinate.longitude
        
        if lastCoordinate != nil{
            
            let pin = MKPointAnnotation()
            pin.title = "Coordinates: \(mapPoint.latitude), \(mapPoint.longitude)"
            
            let distance = lastCoordinate!.distanceFromLocation(currentLocation)
            distanceTraveled += round(Double(distance.description)!)
            pin.subtitle = "Distance Traveled: \(distanceTraveled)m"
            pin.coordinate = mapPoint
            
            map.addAnnotation(pin)
        
        }else{
        
            let pin = MKPointAnnotation()
            pin.title = "Latitude: \(mapPoint.latitude), Longitude: \(mapPoint.longitude)"
            pin.subtitle = "Start Point"
            pin.coordinate = mapPoint
            
            map.addAnnotation(pin)
        
        
        }
        
        lastCoordinate = currentLocation
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        
        print("Error: Code \(error.code) - \(error.description)")
    
        /*let errorAlert = UIAlertController(title: "Upsss!", message: "Error: \(error.code)", preferredStyle: .Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: {accion in
    
        print("Ok button pressed!")
        })
    
        errorAlert.addAction(okAction)
        self.presentViewController(errorAlert, animated: true, completion: nil)*/
        
    }
    
    
    func setZoomMap(zoomLevel : Int){
        
        for var i=0; i < zoomLevel; i++ {
            
            autoreleasepool{
            
            let span = MKCoordinateSpan(latitudeDelta: map.region.span.latitudeDelta/2, longitudeDelta: map.region.span.longitudeDelta/2)
            let region = MKCoordinateRegion(center: map.region.center, span: span)
            
            map.setRegion(region, animated: true)
                
            }
        
        }
        
    }
    
    

}

