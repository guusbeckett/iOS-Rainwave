//
//  ViewController.swift
//  Rainwave
//
//  Created by Guus Beckett on 27/09/2016.
//  Copyright © 2016 Guus Beckett. All rights reserved.
//

import UIKit
import WebKit
import AVFoundation

class ViewController: UIViewController, WKNavigationDelegate {
    @IBOutlet weak var referenceView: UIView!
    private var alreadyAnimated = false
    @IBOutlet weak var backgroundImage: UIImageView!
    var webView: WKWebView
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        referenceView.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        loadRainwaveSite(webView: webView)
        
    }
    override func viewDidLayoutSubviews() {
        webView.frame = CGRect(origin: CGPoint.zero, size: referenceView.frame.size)
    }
    
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        animateOnlyOnce()
        
        func configureView() {
        }
    }

    
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        print(navigationAction.request.url!.absoluteString)
        
        //ugly workaround to fix links which not yet link to https content
        if (isHttpRequest(url: navigationAction.request.url!)) {
            decisionHandler(WKNavigationActionPolicy.cancel)
            webView.load(convertHttpRequestToHttpsRequest(urlRequest: navigationAction.request))
        }
        else {
            decisionHandler(WKNavigationActionPolicy.allow)
        }
    
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init(coder aDecoder: NSCoder) {
        self.webView = WKWebView(frame: CGRect.zero)
        super.init(coder: aDecoder)!
    }
    
    func animateOnlyOnce() -> Void {
        if(!alreadyAnimated) {
            UIView.animate(withDuration: 0.5, delay: 0.1,
                           options: UIViewAnimationOptions.curveEaseIn, animations: {
                            self.referenceView.alpha = 1.0
                            self.backgroundImage.alpha = 0.0
                }, completion: nil)
            alreadyAnimated = true
        }
    }
    
}

