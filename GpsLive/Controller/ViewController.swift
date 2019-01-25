//
//  ViewController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 23/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, SyncDelegate, WKNavigationDelegate {
    
    @IBOutlet weak var wbView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        wbView.navigationDelegate = self
        
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        if SharedInfo.ISK50Network
        {
            let url = URL(string: "http://10.3.141.1/Home/LiveDevices")!
            wbView.load(URLRequest(url: url))
            wbView.allowsBackForwardNavigationGestures = false
            
//            APIHelper.SyncTeam(self)
            
        }
        else
        {
            if SharedInfo.getUserName() == "" && SharedInfo.getPassword() == ""
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
                vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                vc?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
                if vc != nil
                {
                    self.present(vc!, animated: true, completion: nil)
                }
            }
            else
            {
                APIHelper.GetTeam(self)
                
                
            }
        }
        
    }
    
    func GetTeamCompleted(success: Bool, data: [TeamInfo])
    {
        for curr in data {
            DAL.SaveTeamInfo(curr)
        }
        APIHelper.GetSessionTypes(self)
    }
    
    func GetSessionTypesCompleted(success: Bool, data: [SessionType_DTO])
    {
        for curr in data {
            DAL.SaveSessionType(curr)
        }
        APIHelper.GetParameterInfo(self)
    }
    
    func GetParameterInfoCompleted(success: Bool, data: [ParameterInfo])
    {
        for curr in data {
            DAL.SaveParameterInfo(curr)
        }
        APIHelper.GetPlayers(self)
    }
    
    func GetPlayersCompleted(success: Bool, data: [PlayerInfo])
    {
        for curr in data {
            DAL.SavePlayerInfo(curr)
        }
        APIHelper.GetLiveParameters(self)
    }
    
    
    
    func GetLiveParametersCompleted(success: Bool, data: [Live_Parameters_Table])
    {
        for curr in data {
            DAL.SaveLive_Parameters_Table(curr)
        }
        APIHelper.GetLiveDevices(self)
    }
    
    func GetLiveDevicesCompleted(success: Bool, data: [NewLive_Devices])
    {
        for curr in data {
            DAL.SaveNewLive_Devices(curr)
        }
    }
    
    func SyncTeamCompleted(success: Bool, data: String?)
    {
        
    }
    
}

