//
//  ArtWebViewController.swift
//  BeautifulCity
//
//  Created by Berger on 30/05/15.
//  Copyright (c) 2015 Jokkmokk. All rights reserved.
//

import Foundation
import SwiftyJSON



class ArtWebViewController: UIViewController {
    
    @IBOutlet var webView: [UIWebView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let art = (UIApplication.sharedApplication().delegate as! AppDelegate).relatedArt
        
        var images = art!["response"]["docs"]
        for (index, image) in enumerate(images) {
            
            let url_string = toString(art!["response"]["docs"][index]["medium_image_url"])
            
            if url_string != "null" {
                println("Title: " +  toString(art!["response"]["docs"][index]["title_first"]))
                println("From: " + toString(art!["response"]["docs"][index]["artist_name"]))
                let url = NSURL(string: url_string)
                let request = NSURLRequest(URL: url!)
                self.webView.first!.loadRequest(request)
            }
            
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func artAvailable(notification:NSNotification) -> Void {

        let artInfo = notification.userInfo as! Dictionary<String,AnyObject>
        var json = JSON(artInfo["art"]!)
        var images = json["response"]["docs"]
        
        for (index, image) in enumerate(images) {
            println(json["response"]["docs"][index]["title_first"])
            println(json["response"]["docs"][index]["medium_image_url"])
        }
    }
    
}