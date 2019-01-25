//
//  MainController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 14/11/2018.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit
import WebKit

class MainController: UIViewController, SyncDelegate, SessionDelegate, WKNavigationDelegate {


    @IBOutlet weak var wbView: WKWebView!
    @IBOutlet weak var btnDevices: UIButton!
    @IBOutlet weak var btnDrills: UIButton!
    @IBOutlet weak var btnTable: UIButton!
    @IBOutlet weak var btnStartBig: UIButton!
    @IBOutlet weak var btnStop: UIButton!
    @IBOutlet weak var lblDuration: UILabel!
    @IBOutlet weak var vwBottomBar: UIView!
//    @IBOutlet weak var vwPing: UIView!
//    @IBOutlet weak var lblPing: UILabel!
    @IBOutlet weak var vwActivityBar: UIView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var lblActivity: UILabel!
    @IBOutlet weak var activityCenter: UIActivityIndicatorView!
    @IBOutlet weak var lblTeam: UILabel!
    @IBOutlet weak var lblLoadingSession: UILabel!
    @IBOutlet weak var btnPlayer: UIButton!
    @IBOutlet weak var btnTile: UIButton!
    @IBOutlet weak var btnSettings: UIButton!
    
    
    var timer = Timer()
    var timerPing = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityCenter.isHidden = true
        wbView.navigationDelegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        wbView.scrollView.bounces = false
        SharedInfo.mainView = self
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        handleAppear()
        
    }
    
    func handleAppear() {
        if SharedInfo.ISK50Network
        {
            self.lblLoadingSession.isHidden = true
            activityCenter.isHidden = false
            activityCenter.startAnimating()
            APIHelper.IsSessionActive(self)
            
            btnDevices.backgroundColor = UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0)
            btnSettings.isHidden = false
        }
        else
        {
            self.btnStartBig.isHidden = true
            btnSettings.isHidden = true
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
                StartFetchData()
                let sessions = DAL.LoadUnloadedSessionData()
                if sessions.count > 0
                {
                    for session in sessions
                    {
                        APIHelper.CreateSession(self, session: session)
                        lblLoadingSession.isHidden = false
                        lblLoadingSession.text = "LOADING \(session.SessionName) ON DYNAMIX..."
                    }
                }
                else
                {
                    lblLoadingSession.isHidden = false
                    lblLoadingSession.text = "TO START A NEW SESSION CONNECT TO K-50 WIFI"
                }
            }
        }
    }
    
    @objc func Ping() {
//        APIHelper.Ping(self)
    }
    
    func StartSyncData() {
        DispatchQueue.main.async(execute: {
            self.vwActivityBar.isHidden = false;
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.lblActivity.text = "Synchronizing data..."
            APIHelper.SyncTeam(self)
        })
    }
    
    func StartFetchData() {
        DispatchQueue.main.async(execute: {
            self.vwActivityBar.isHidden = false;
            self.activityIndicator.isHidden = false
            self.activityIndicator.startAnimating()
            self.lblActivity.text = "Fetching data..."
            APIHelper.GetTeam(self)
        })
    }
    
    func PingCompleted(success: Bool, time: TimeInterval, version: String?)
    {
        if success
        {
//            DispatchQueue.main.async() { () -> Void in
//                self.lblPing.text = "\(Int(time))"
//                self.vwPing.isHidden = false
//                if time < 100
//                {
//                    self.vwPing.backgroundColor = UIColor(red: 29/255.0, green: 249/255.0, blue: 0/255.0, alpha: 1.0)
//                }
//                else if time >= 100 && time < 300
//                {
//                    self.vwPing.backgroundColor = UIColor(red: 249/255.0, green: 252/255.0, blue: 0/255.0, alpha: 1.0)
//                }
//                else if time >= 300 && time < 500
//                {
//                    self.vwPing.backgroundColor = UIColor(red: 252/255.0, green: 154/255.0, blue: 0/255.0, alpha: 1.0)
//                }
//                else
//                {
//                    self.vwPing.backgroundColor = UIColor(red: 252/255.0, green: 0/255.0, blue: 49/255.0, alpha: 1.0)
//                }
//            }
            
        }
    }
    
    @IBAction func btnSettingsTouched(_ sender: Any)
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "SettingsController") as? SettingsController
        vc?.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        vc?.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        if vc != nil
        {
            self.present(vc!, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnDevicesToouched(_ sender: Any)
    {
        setButtonSelected(selected: btnDevices)
        let url = URL(string: "http://10.3.141.1/Home/LiveDevices")!
        wbView.load(URLRequest(url: url))
        wbView.allowsBackForwardNavigationGestures = false
    }
    
    @IBAction func btnDrillsTouched(_ sender: Any)
    {
        setButtonSelected(selected: btnDrills)
        let url = URL(string: "http://10.3.141.1/Home/LiveDrills")!
        wbView.load(URLRequest(url: url))
        wbView.allowsBackForwardNavigationGestures = false
    }
    
    @IBAction func btnTableTouched(_ sender: Any)
    {
        setButtonSelected(selected: btnTable)
        let url = URL(string: "http://10.3.141.1/Home/LiveTable")!
        wbView.load(URLRequest(url: url))
        wbView.allowsBackForwardNavigationGestures = false
    }
    
    @IBAction func btnTileTouched(_ sender: Any)
    {
        setButtonSelected(selected: btnTile)
        let url = URL(string: "http://10.3.141.1/Home/LiveTile")!
        wbView.load(URLRequest(url: url))
        wbView.allowsBackForwardNavigationGestures = false
    }
    @IBAction func btnPlayerTouched(_ sender: Any)
    {
        setButtonSelected(selected: btnPlayer)
        let url = URL(string: "http://10.3.141.1/Home/LivePlayer")!
        wbView.load(URLRequest(url: url))
        wbView.allowsBackForwardNavigationGestures = false
    }
    
    @IBAction func btnPlayBig(_ sender: Any)
    {
        APIHelper.StartSession(self)
        btnStartBig.isHidden = true
        activityCenter.isHidden = false
        activityCenter.startAnimating()
    }
    
    @IBAction func btnStopTouched(_ sender: Any)
    {
        let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("Do you want to Stop the Live Session?", comment: "") , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save Session", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            
            APIHelper.GetSessionData(self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard Session", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            
            APIHelper.StopSession(self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue Live", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            
            
        }))
        alert.view.tintColor = UIColor.black
        
        
        self.present(alert, animated: true, completion: nil)
//        APIHelper.GetSessionData(self)
//        APIHelper.StopSession(self)
    }
    
    
    
    func IsSessionActiveCompleted(success: Bool, active: Bool, elapsed: Int)
    {
        if success {
            activityCenter.isHidden = true
            activityCenter.stopAnimating()
            if active
            {
                DispatchQueue.main.async() { () -> Void in
                    self.wbView.isHidden = false
                    let url = URL(string: "http://10.3.141.1/Home/LiveDevices")!
                    self.wbView.load(URLRequest(url: url))
                    self.wbView.allowsBackForwardNavigationGestures = false
                    self.btnStop.isHidden = false
                    self.lblDuration.isHidden = false
                    self.vwBottomBar.isHidden = false
                    SharedInfo.SessionStart = Date.timeIntervalSinceReferenceDate - TimeInterval(elapsed)
                    let aSelector : Selector = #selector(MainController.updateTime)
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
                }
            }
            else
            {
                DispatchQueue.main.async() { () -> Void in
                    var teams = DAL.LoadTeams()
                    if teams.count > 1
                    {
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(withIdentifier: "SelectTeamController") as! SelectTeamController
                        vc.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                        vc.modalTransitionStyle = UIModalTransitionStyle.coverVertical
                        vc.teams = teams
                        vc.parentController = self
                        
                        self.present(vc, animated: true, completion: nil)
                    }
                    else
                    {
                        if teams.count > 0
                        {
                            SharedInfo.TeamID = teams[0].Team_ID
                            SharedInfo.TeamName = teams[0].Name
                            self.lblTeam.text = SharedInfo.TeamName.uppercased()
                            self.btnStartBig.isHidden = false
//                            self.StartSyncData()
                        }
                    }
                    
                }
            }
        }
    }
    
    func teamSelected()
    {
        DispatchQueue.main.async() { () -> Void in
            self.btnStartBig.isHidden = false
            self.lblTeam.text = SharedInfo.TeamName.uppercased()
//            self.StartSyncData()
        }
    }
    
    @objc func updateTime() {

        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        let elapsedTime: TimeInterval = currentTime - SharedInfo.SessionStart

        setDurationLabel(elapsedTime)
        
    }
    
    func setDurationLabel(_ time: TimeInterval)
    {
        var elapsedTime: TimeInterval =  time
        //calculate the minutes in elapsed time.
        
        let hours = UInt16(elapsedTime / 3600)
        
        elapsedTime -= (TimeInterval(hours) * 3600)
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (TimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.a
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strHours = String(format: "%01d", hours)
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        self.lblDuration.text = "\(strHours):\(strMinutes):\(strSeconds)"
        
    }
    
    func StartStopSessionCompleted(success: Bool, start: Bool)
    {
        if start
        {
            if success
            {
                DispatchQueue.main.async() { () -> Void in
//                    self.btnStartBig.isHidden = true
                    self.wbView.isHidden = false
                    let url = URL(string: "http://10.3.141.1/Home/LiveDevices")!
                    self.wbView.load(URLRequest(url: url))
                    self.wbView.allowsBackForwardNavigationGestures = false
                    self.btnStop.isHidden = false
                    self.lblDuration.isHidden = false
                    self.vwBottomBar.isHidden = false
                    self.activityCenter.isHidden = true
                    self.activityCenter.stopAnimating()
                    SharedInfo.SessionStart = Date.timeIntervalSinceReferenceDate
                    let aSelector : Selector = #selector(MainController.updateTime)
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: aSelector, userInfo: nil, repeats: true)
                }
            }
            else
            {
                
            }
        }
        else
        {
            if success
            {
                DispatchQueue.main.async() { () -> Void in
                    self.btnStartBig.isHidden = false
                    self.wbView.isHidden = true
                    self.btnStop.isHidden = true
                    self.lblDuration.isHidden = true
                    self.vwBottomBar.isHidden = true
                }
            }
        }
    }

    
    
    
    
    func setButtonSelected(selected: UIButton)
    {
        btnDevices.backgroundColor = UIColor.clear
        btnDrills.backgroundColor = UIColor.clear
        btnTable.backgroundColor = UIColor.clear
        btnPlayer.backgroundColor = UIColor.clear
        btnTile.backgroundColor = UIColor.clear
        
        selected.backgroundColor = UIColor(red: 70/255.0, green: 70/255.0, blue: 70/255.0, alpha: 1.0)
    }
    
    func GetTeamCompleted(success: Bool, data: [TeamInfo])
    {
        var teamName = ""
        for curr in data {
            DAL.SaveTeamInfo(curr)
            teamName = curr.Name
            SharedInfo.TeamID = curr.Team_ID
        }
        DispatchQueue.main.async() { () -> Void in
            self.lblTeam.text = teamName.uppercased()
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
        DAL.DeleteTeamDevices(teamID: SharedInfo.TeamID)
        for curr in data {
            DAL.SaveNewLive_Devices(curr)
        }
        DispatchQueue.main.async() { () -> Void in
            self.activityIndicator.stopAnimating()
            self.vwActivityBar.isHidden = true
        }
    }
    
    func SyncTeamCompleted(success: Bool, data: String?)
    {
        DispatchQueue.main.async() { () -> Void in
            self.activityIndicator.stopAnimating()
            self.vwActivityBar.isHidden = true
        }
    }

    func GetSessionDataCompleted(success: Bool, data: SessionData, canLoad: Bool)
    {
        if success {
            if canLoad
            {
                DAL.SaveSessionData(data)
                APIHelper.StopSession(self)
            }
            else
            {
                DispatchQueue.main.async() { () -> Void in
                    let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("Some Devices do not have an associated Player. Please associate a player to every Device and try again.", comment: "") , preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
                        
                        
                    }))
                    alert.view.tintColor = UIColor.black
                    
                    
                    self.present(alert, animated: true, completion: nil)
                }
                
            }
        }
    }


    
    func CreateSessionCompleted(success: Bool, data: SessionData)
    {
//        if success {
            DAL.SetSessionDataAsLoaded(data)
//        }
        
        DispatchQueue.main.async() { () -> Void in
//            self.lblLoadingSession.isHidden = true
            self.lblLoadingSession.text = "TO START A NEW SESSION CONNECT TO K-50 WIFI"
        }
    }
    
}
