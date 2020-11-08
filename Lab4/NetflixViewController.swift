//
//  NetflixViewController.swift
//  Lab4
//
//  Created by Katie Vanesko on 11/8/20.
//  Copyright © 2020 Katie Vanesko. All rights reserved.
//

import UIKit
import WebKit

class NetflixViewController: UIViewController {

    
    @IBOutlet weak var webView: WKWebView!
    var movie_name:String?
    var punctuation:[Character:String] = [
        "'": "%27",
        " ": "%20",
        ",": "%2C",
        ";": "%3B",
        ":": "%3A",
        "/": "%2F",
        "?": "%3F",
        "[": "%5B",
        "]": "%5D",
        "(": "%28",
        ")": "%29",
        "{": "%7B",
        "}": "%7D",
        "!": "%21"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var future_url = "https://www.justwatch.com/us/search?q="
        for char in movie_name! {
            if punctuation[char] != nil {
                future_url.append(punctuation[char]!)
            }
            else {
                future_url.append(char)
            }
        }
        print(future_url)
        let url = URL(string: future_url)
        webView.load(NSURLRequest(url: NSURL(string: future_url)! as URL) as URLRequest)
        //        webView.loadFileURL(url!, allowingReadAccessTo: url!)
        //DONT FORCE UNWRAP URL!!
    }


}
