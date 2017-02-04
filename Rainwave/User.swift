//
//  User.swift
//  Rainwave
//
//  Created by Guus Beckett on 02/02/2017.
//  Copyright © 2017 Guus Beckett. All rights reserved.
//

import Foundation

class User {
    static let getInstance = User()
    var id : String!
    var apikey : String!
    var isLoggedIn : Bool = false
    
    func loadUsersettings() {
        let settings = UserDefaults.standard
        self.id = settings.string(forKey: "userid")
        self.apikey = settings.string(forKey: "apikey")
        isLoggedIn = (self.id != nil && self.apikey != nil)
    }
}
