//
//  ViewController.swift
//  BeautifulCity
//
//  Created by Berger on 29/05/15.
//  Copyright (c) 2015 Jokkmokk. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    var lastLocation:CLLocation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "locationAvailable:", name: "LOCATIONAVAILABLE", object: nil)
            
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.setRegion()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationAvailable(notification:NSNotification) -> Void {
        let locationInfo = notification.userInfo as! Dictionary<String,AnyObject>

        var userLocation: CLLocation = locationInfo["loc"]! as! CLLocation
        println(locationInfo)
        self.lastLocation = userLocation
        
        var region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate,
            CLLocationDistance(5000), CLLocationDistance(5000))
        
        self.mapView.setRegion(region, animated: true)
    }
    
    func setRegion() {
        if (self.lastLocation?.coordinate != nil) {
            var region = MKCoordinateRegionMakeWithDistance(self.lastLocation.coordinate,
            CLLocationDistance(5000), CLLocationDistance(5000))
        
            self.mapView.setRegion(region, animated: true)
        }

    }
    
}

