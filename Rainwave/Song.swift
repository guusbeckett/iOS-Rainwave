//
//  Song.swift
//  Rainwave
//
//  Created by Guus Beckett on 31/01/2017.
//  Copyright © 2017 Guus Beckett. All rights reserved.
//

import Foundation
import SwiftyJSON

class Song {
    var id : Int!
    var name : String!
    var artists : String!
    var albumName : String!
    var albumURL : String!
    var favourite : Bool = false
}
