//
//  RadioPlayer.swift
//  SampleRadioApp
//
//  Created by Lucian Cancescu on 06.08.15.
//  Copyright (c) 2015 Lucian Cancescu. All rights reserved.
//
import Foundation
import AVFoundation

class RadioPlayer {
    static let sharedInstance = RadioPlayer()
    private var player = AVPlayer()
    private var isPlaying = false
    
    func play() {
        player.play()
        isPlaying = true
    }
    
    func pause() {
        player.pause()
        isPlaying = false
    }
    
    func toggle() {
        if isPlaying == true {
            pause()
        } else {
            play()
        }
    }
    
    func currentlyPlaying() -> Bool {
        return isPlaying
    }

    func changeCurrentStation(streamURL: String) {
        player.replaceCurrentItem(with: AVPlayerItem(url: URL(string: streamURL)!))
    }
    
}
