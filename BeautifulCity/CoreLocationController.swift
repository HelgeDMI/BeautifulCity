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
        
        NSNotificationCenter.defaultCenter().postNotificationName("LOCATIONAVAILABLE", object: self, userInfo: ["loc":location])

        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, e) -> Void in
            if let error = e {
                println("Error: " + toString(e.localizedDescription))
            } else {
                let placemark = placemarks.last as! CLPlacemark
                
                let userInfo = [
                    "city":     placemark.locality!.utf8.description,
                    // "state":    placemark.administrativeArea!.utf8,
                    // "country":  placemark.country!.utf8
                    //"address":  placemark?.addressDictionary
                ]

                let city = toString(userInfo["city"]!)
                println("Location: " + city)
                
                let query = "http://solr.smk.dk:8080/solr/prod_all_dk/select?q=title_first:" + city + "&wt=json"
                Alamofire.request(.GET, query).responseJSON {(_, _, data, _) in
                    
                    var json = JSON(data!)
                    if json["response"]["numFound"] > 0 {
                        
                        NSNotificationCenter.defaultCenter().postNotificationName("ARTAVAILABLE", object: nil, userInfo: ["art":data!])
                        
                    }
                }
            }
        })
        

        
    }
}
