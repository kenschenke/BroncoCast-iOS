//
//  PrivacyPolicyViewController.swift
//  BroncoCast
//
//  Created by Ken Schenke on 2/17/19.
//  Copyright © 2019 Ken Schenke. All rights reserved.
//

import UIKit
import WebKit

class PrivacyPolicyViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = URL(string: UrlMaker.makeUrl(.privacy_policy))
        let myRequest = URLRequest(url: myURL!)
        webView.load(myRequest)
    }
    
}
