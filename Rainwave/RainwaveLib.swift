//
//  RainwaveLib.swift
//  Rainwave
//
//  Created by Guus Beckett on 27/09/2016.
//  Copyright © 2016 Guus Beckett. All rights reserved.
//

import Foundation
import WebKit
import UIKit
import AVFoundation
import Alamofire

func loadRainwaveSite(webView: WKWebView) -> Void {
    let url = NSURL (string: "https://rainwave.cc/")
    let requestObj = NSURLRequest(url: url! as URL)
    webView.load(requestObj as URLRequest)
}

func loginRequest(username : String, password : String, webView: WKWebView) {
    let url = NSURL (string: "https://rainwave.cc/forums/ucp.php?mode=login")
    var loginRequest = URLRequest(url: url! as URL)
    loginRequest.httpMethod = "POST"
    let postString = "username=\(username)&password=\(password)&autologin=on&login=Login"
    loginRequest.httpBody = postString.data(using: .utf8)
    loginRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
    
    let headers: HTTPHeaders = [
        "Content-Type": "application/x-www-form-urlencoded; charset=utf-8",
    ]
    let parameters: Parameters = [
        "username": username,
        "password": password,
        "autologin": "on",
        "login": "Login"
    ]
    
    Alamofire.request("https://rainwave.cc/forums/ucp.php?mode=login", method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: headers).response {
        response in webView.load(NSURLRequest(url: (response.response?.url)!) as URLRequest)
    }
}




func isLoginURL(url: URL) -> Bool {
    if(url.absoluteString.contains("redirect") && !url.absoluteString.contains("")) {
        return true
    }
    return false
}

func isHttpRequest(url: URL) -> Bool {
    if(url.absoluteString.contains("http://")) {
        return true
    }
    return false
}

func convertHttpRequestToHttpsRequest(urlRequest: URLRequest) -> URLRequest {
    let url = NSURL (string: urlRequest.url!.absoluteString.replacingOccurrences(of: "http://", with: "https://"))
    return URLRequest(url: url! as URL)
}


