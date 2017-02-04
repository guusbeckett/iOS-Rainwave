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
import MediaPlayer
import Alamofire
import AlamofireImage
import SwiftyJSON

func loadRainwaveSite(webView: WKWebView) -> Void {
    let url = NSURL (string: "https://rainwave.cc/")
    let requestObj = NSURLRequest(url: url! as URL)
    webView.load(requestObj as URLRequest)
}

func refreshAlbumArt(station: station) {
    getInfoNowPlaying(station: station)
}

enum station : Int {
    case game = 1
    case ocremix = 2
    case covers = 3
    case chiptune = 4
    case all = 5
}

func stationName(station: station) -> String {
    switch station {
    case .game:
        return "Game"
    case .ocremix:
        return "OC ReMix"
    case .covers:
        return "Covers"
    case .chiptune:
        return "Chiptune"
    case .all:
        return "All"
    }
}

func stationNameToStation(stationName: String) -> station {
    switch stationName {
    case "Game":
        return .game
    case "OC ReMix":
        return .ocremix
    case "Covers":
        return .covers
    case "Chiptune":
        return .chiptune
    case "All":
        return .all
    default:
        return .all
    }
}

func getInfoNowPlaying(station: station) {
    let user = User.getInstance
    let requestString = user.isLoggedIn ? "https://rainwave.cc/api4/info?sid=\(station.rawValue)&user_id=\(user.id!)&key=\(user.apikey!)" : "https://rainwave.cc/api4/info?sid=\(station.rawValue)"
    Alamofire.request(requestString).responseJSON { response in
        let song : Song = Song()
        let json = JSON(data: response.data!)
        song.id =  json["sched_current"]["songs"][0]["id"].int!
        song.name = json["sched_current"]["songs"][0]["title"].string!
        song.albumName = json["sched_current"]["songs"][0]["albums"][0]["name"].string!
        song.albumURL = "https://rainwave.cc"+json["sched_current"]["songs"][0]["albums"][0]["art"].string!+"_320.jpg"
        song.artists = ""
        song.favourite = json["sched_current"]["songs"][0]["fave"].boolValue
        for item in json["sched_current"]["songs"][0]["artists"] {
            if (song.artists != ""){ song.artists = song.artists + ", " }
            song.artists = song.artists + item.1["name"].string!
        }
        updateAlbumArt(song: song)
    }
    //sched_current
}

func waitForNextSong(station: station) {
    let user = User.getInstance
    let requestString = user.isLoggedIn ? "https://rainwave.cc/api4/info?sid=\(station.rawValue)&user_id=\(user.id!)&key=\(user.apikey!)" : "https://rainwave.cc/api4/info?sid=\(station.rawValue)"
    Alamofire.request(requestString).responseJSON { response in
        let song : Song = Song()
        let json = JSON(data: response.data!)
        song.id =  json["sched_current"]["songs"][0]["id"].int!
        song.name = json["sched_current"]["songs"][0]["title"].string!
        song.albumName = json["sched_current"]["songs"][0]["albums"][0]["name"].string!
        song.albumURL = "https://rainwave.cc"+json["sched_current"]["songs"][0]["albums"][0]["art"].string!+"_320.jpg"
        song.artists = ""
        song.favourite = json["sched_current"]["songs"][0]["fave"].boolValue
        for item in json["sched_current"]["songs"][0]["artists"] {
            if (song.artists != ""){ song.artists = song.artists + ", " }
            song.artists = song.artists + item.1["name"].string!
        }
        updateAlbumArt(song: song)
    }

}

private func updateAlbumArt(song: Song) {
    //Download album art then do this:
    Alamofire.request(song.albumURL).responseImage { response in
        if let data = response.result.value {
            let image = data
            if NSClassFromString("MPNowPlayingInfoCenter") != nil {
                let albumArt = MPMediaItemArtwork(image: image)
                let songInfo = [
                    MPMediaItemPropertyTitle: song.name,
                    MPMediaItemPropertyArtist: song.artists,
                    MPMediaItemPropertyAlbumTitle: song.albumName,
                    MPMediaItemPropertyArtwork: albumArt
                    ] as [String : Any]
                MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
            }
        }
    }
}

func loadDefaultAlbumArt(station: station) {
    if NSClassFromString("MPNowPlayingInfoCenter") != nil {
        let image:UIImage = UIImage(named: "default_album_art")!
        let albumArt = MPMediaItemArtwork(image: image)
        let songInfo = [
            MPMediaItemPropertyTitle: "Rainwave",
            MPMediaItemPropertyArtist: stationName(station: station),
            MPMediaItemPropertyArtwork: albumArt
            ] as [String : Any]
        MPNowPlayingInfoCenter.default().nowPlayingInfo = songInfo
    }
}
