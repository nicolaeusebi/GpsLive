//
//  TableController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 01/11/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit
import WebKit

class TableController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewDidAppear(_ animated: Bool) {
        if SharedInfo.ISK50Network
        {
            let url = URL(string: "http://10.3.141.1/Home/LiveTable")!
            webView.load(URLRequest(url: url))
            webView.allowsBackForwardNavigationGestures = false
        }
    }

}
