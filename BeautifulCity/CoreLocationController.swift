//
//  CoreLocationController.swift
//  BeautifulCity
//
//  Created by Berger on 29/05/15.
//  Copyright (c) 2015 Jokkmokk. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class CoreLocationController : NSObject, CLLocationManagerDelegate {

    var locationManager:CLLocationManager = CLLocationManager()
    
    override init() {
        super.init()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        self.locationManager.distanceFilter = 50
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("didChangeAuthorizationStatus")
        
        switch status {
        case .NotDetermined:
            println(".NotDetermined")
            break
            
        case .AuthorizedAlways:
            println(".Authorized")
            self.locationManager.startUpdatingLocation()
            break
            
        case .AuthorizedWhenInUse:
            println(".Authorized in Use")
            self.locationManager.startUpdatingLocation()
            break
            
        case .Denied:
            println(".Denied")
            break
            
        default:
            println("Unhandled authorization status")
            break
            
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        let location = locations.last as! CLLocation
        
        println("didUpdateLocations: " + location.coordinate.latitude.description + " " + location.coordinate.longitude.description)
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                println("Error: " + toString(e.localizedDescription))
            } else {
                let placemark = placemarks.last as! CLPlacemark
                
                let userInfo = [
                    "city":     placemark.locality,
                    "state":    placemark.administrativeArea,
                    "country":  placemark.country,
                    "address":  placemark.addressDictionary
                ]
                
                println("Location: " + toString(userInfo))
                
                //println(Alamofire.request(.GET, "http://httpbin.org/get"))
                
                Alamofire.request(.GET, "http://solr.smk.dk:8080/solr/prod_all_dk/select?q=title_first:ordrup&wt=json").responseJSON {(_, _, data, _) in
                    println(toString(data))
                    
                    var json = JSON(data!)
                    println(json["docs"][0])
                }
            }
        })
        
    }

}
