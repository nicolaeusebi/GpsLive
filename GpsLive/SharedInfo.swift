//
//  SharedInfo.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 23/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import Foundation

class SharedInfo
{
    static var ISK50Network = false;
    static var TeamID: Int32 = 114;
    static var TeamName: String = "";
    static var SessionStart: TimeInterval = TimeInterval();
    
    static var mainView: MainController? = nil
    
    static func setUserName(_ value: String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "user_name")
    }
    
    static func getUserName() -> String
    {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: "user_name")
        {
            return value
        }
        else
        {
            return ""
        }
    }
    
    static func setPassword(_ value: String)
    {
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: "password")
    }
    
    static func getPassword() -> String
    {
        let defaults = UserDefaults.standard
        if let value = defaults.string(forKey: "password")
        {
            return value
        }
        else
        {
            return ""
        }
    }
}
