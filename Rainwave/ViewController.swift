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
import MediaPlayer

class ViewController: UIViewController, WKNavigationDelegate, AVAudioPlayerDelegate {
    @IBOutlet weak var referenceView: UIView!
    private var alreadyAnimated = false
    @IBOutlet weak var backgroundImage: UIImageView!
    var webView: WKWebView!
    var player = AVPlayer()
    var currentStation : station = .game
    var currentStationStreamURL : String = ""
    var currentStationStreamURLs : [String]!
    var currentlyPlayingStreamIndex = 0
    var user = User.getInstance
    
    @IBAction func Refresh(_ sender: Any) {
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Load User API Login
        user.loadUsersettings()
        
        // Create script message handlers.
        let contentController = WKUserContentController()
        
        // This will inject an `actionSheet` messageHanlder into the Javascript. Calling it will show a native
        // actionsheet, with Strings parsed by the Javascript.
        contentController.add(WKFormMessageHandler { message in
            print("play")
            if(self.currentStation != station(rawValue: message.body as! Int)!) {
                self.pauseRadio()
            }
            self.currentStation = station(rawValue: message.body as! Int)!
            self.setRadioStation(streamURL: self.currentStationStreamURL)
            self.toggleRadio()
            refreshAlbumArt(station: self.currentStation)
        }, name: "rainwavePlay")
        
        contentController.add(WKFormMessageHandler { message in
            print("Stop")
            self.pauseRadio()
        }, name: "rainwaveStop")
        
        contentController.add(WKFormMessageHandler { message in
            self.currentStationStreamURLs = (message.body as! [String])
            self.currentStationStreamURL = self.currentStationStreamURLs[0]
            print(self.currentStationStreamURL)
            if(self.user.id == nil) {
                print("EMPTY!")
            }
        }, name: "rainwaveUseStreamURLs")
        
        contentController.add(WKFormMessageHandler { message in },name: "rainwave")
        
        // Config.
        let config = WKWebViewConfiguration()
        config.userContentController = contentController
        
        webView = WKWebView(frame: CGRect.zero, configuration: config)
        referenceView.addSubview(webView)
        webView.navigationDelegate = self
        webView.scrollView.bounces = false
        
        loadRainwaveSite(webView: webView)
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            UIApplication.shared.beginReceivingRemoteControlEvents()
            print("Receiving remote control events\n")
        } catch {
            print("Audio Session error.\n")
        }

    }
    
    override func viewDidLayoutSubviews() {
        webView.frame = CGRect(origin: CGPoint.zero, size: referenceView.frame.size)
    }
    
    func toggleRadio() {
        if RadioPlayer.sharedInstance.currentlyPlaying() {
            pauseRadio()
        } else {
            playRadio()
        }
    }
    
    func playRadio() {
        RadioPlayer.sharedInstance.play()
    }
    
    func pauseRadio() {
        RadioPlayer.sharedInstance.pause()
        
    }
    
    func setRadioStation(streamURL: String) {
        RadioPlayer.sharedInstance.changeCurrentStation(streamURL: streamURL)
    }
    
    func webView(_: WKWebView, didFinish: WKNavigation!) {
        animateOnlyOnce()
        
        func configureView() {
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    required init(coder aDecoder: NSCoder) {
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
    
    /// A custom class that simply holds a function/handler.
    private final class WKFormMessageHandler: NSObject, WKScriptMessageHandler {
        
        private var handler: (WKScriptMessage) -> ()
        
        init(handler: @escaping (WKScriptMessage) -> ()) {
            self.handler = handler
            super.init()
        }
        
        @objc fileprivate func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
            handler(message)
        }
        
    }
}

