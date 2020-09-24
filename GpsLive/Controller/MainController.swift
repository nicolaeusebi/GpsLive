//
//  MainController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 14/11/2018.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import UIKit
import WebKit
import SystemConfiguration.CaptiveNetwork

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
    @IBOutlet weak var imgLogo: UIImageView!
    
    var isDiscard = false
    
    var timer = Timer()
    var timerPing = Timer()
    
    var isStopSessionCheck = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityCenter.isHidden = true
        wbView.navigationDelegate = self
        self.setNeedsStatusBarAppearanceUpdate()
        wbView.scrollView.bounces = false
        SharedInfo.mainView = self
        DAL.UpdateDB()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
            return .lightContent
    }
    
    func getWiFiSsid() -> String? {
        var ssid: String?
        if let interfaces = CNCopySupportedInterfaces() as NSArray? {
            for interface in interfaces {
                if let interfaceInfo = CNCopyCurrentNetworkInfo(interface as! CFString) as NSDictionary? {
                    ssid = interfaceInfo[kCNNetworkInfoKeySSID as String] as? String
                    break
                }
            }
        }
        return ssid
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        print("handleAppear")
        let wifiSsid = getWiFiSsid()
        if wifiSsid != nil && wifiSsid!.hasPrefix("K-50") {
            SharedInfo.ISK50Network = true;
        }
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
            imgLogo.isHidden = true
        }
        else
        {
            self.btnStartBig.isHidden = true
            btnSettings.isHidden = true
            imgLogo.isHidden = false
            
            if SharedInfo.getUserName() == "" && SharedInfo.getPassword() == ""
            {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "LoginController") as? LoginController
                vc?.parentController = self
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
        APIHelper.StartSessionNew(self)
        btnStartBig.isHidden = true
        activityCenter.isHidden = false
        activityCenter.startAnimating()
        btnSettings.isHidden = true
        imgLogo.isHidden = false
    }
    
    @IBAction func btnStopTouched(_ sender: Any)
    {
        let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("Do you want to Stop the Live Session?", comment: "") , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Save Session", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            self.isDiscard = false
            APIHelper.GetSessionData(self)
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard Session", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            self.isDiscard = true
            DispatchQueue.main.async(execute: {
                self.wbView.isHidden = true
                self.btnStop.isHidden = true
                self.lblDuration.isHidden = true
                self.vwBottomBar.isHidden = true
                self.lblLoadingSession.text = "DISCARDING SESSION... PLEASE DO NOT TURN OFF YOUR ANTENNA."
                self.lblLoadingSession.isHidden = false
            })
            
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
            if isStopSessionCheck
            {
                isStopSessionCheck = false
                
                if active
                {
                    //TODO errore durante lo stop provare ancora
                    DispatchQueue.main.async(execute: {
                        self.lblLoadingSession.text = "SESSION NOT STOPPED"
                        self.lblLoadingSession.isHidden = false
                    })
                    
                }
                else
                {
                    DispatchQueue.main.async(execute: {
                        self.lblLoadingSession.isHidden = true
                        self.btnStartBig.isHidden = false
                        self.btnSettings.isHidden = false
                        self.imgLogo.isHidden = true
                    })
                }
                
            }
            else
            {
                
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
                                self.btnSettings.isHidden = false
                                self.imgLogo.isHidden = true
                                self.setTeamLogo(teamID: SharedInfo.TeamID)
                                
                                
                                //                            self.StartSyncData()
                            }
                        }
                        
                    }
                }
                
            }
            
            
        }
    }
    
    func setTeamLogo(teamID: Int32)
    {
        do
        {
            let documentsDirectory = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask, appropriateFor:nil, create:false);
            let path = documentsDirectory.path + "//" + "\(teamID).png"
            
            var readImage = UIImage(contentsOfFile: path)
            if readImage != nil
            {
                self.imgLogo.image = readImage
            }

            
        }
        catch let error as NSError {
            print(error)
            
        }
    }
    
    func teamSelected()
    {
        DispatchQueue.main.async() { () -> Void in
            self.btnStartBig.isHidden = false
            self.lblTeam.text = SharedInfo.TeamName.uppercased()
            self.setTeamLogo(teamID: SharedInfo.TeamID)
//            self.StartSyncData()
        }
    }
    
    @objc func updateTime() {

        let currentTime = Date.timeIntervalSinceReferenceDate
        
        //Find the difference between current time and start time.
        
        let elapsedTime: TimeInterval = currentTime - SharedInfo.SessionStart

        if elapsedTime > 0
        {
            setDurationLabel(elapsedTime)
        }
        else
        {
            SharedInfo.SessionStart = currentTime
        }
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

                    if  self.isDiscard
                    {
                        self.isStopSessionCheck = true
                        APIHelper.IsSessionActive(self)
                    }
                    else
                    {
                        self.lblLoadingSession.isHidden = true
                        self.btnStartBig.isHidden = false

                    }
                    
                    
                    
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
            self.setTeamLogo(teamID: SharedInfo.TeamID)
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
            if curr.Number == 100 {
                let image = curr.ImagePath
                if image != nil {
                    DownloadImageFromUrl(profilePicture: image!, filename: "\(curr.Team_ID).png")
                }
                
            }
        }
        APIHelper.GetLiveParameters(self)
    }
    
    func DownloadImageFromUrl(profilePicture: String, filename: String)
    {
        let url = "https://www.k-sportonline.com/\(profilePicture.replacingOccurrences(of: "../../", with: ""))"
        if let checkedUrl = URL(string: url) {
            downloadImage(url: checkedUrl, filename: filename)
        }
    }
    
    func downloadImage(url: URL, filename: String) {
        print("Download Started")
        getDataFromUrl(url: url) { (data, response, error)  in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() { () -> Void in
                let image = UIImage(data: data)
                self.imgLogo.image = image
                if image != nil
                {
                    do
                    {
                        let documentsDirectory = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask, appropriateFor:nil, create:false);
                        let path = documentsDirectory.path + "//" + filename
                        let fileManager = FileManager.default
                        fileManager.createFile(atPath: path, contents: image!.pngData(), attributes: nil)
                        
                    }
                    catch let error as NSError {
                        print(error)
                    }
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }
    
    func GetLiveParametersCompleted(success: Bool, data: [Live_Parameters_Table])
    {
        if data.count > 0
        {
            DAL.DeleteLive_Parameters_Table(ID_Team: data[0].ID_Team)
            for curr in data {
                DAL.SaveLive_Parameters_Table(curr)
            }
        }
        APIHelper.GetTotalLiveParameters(self)
    }
    
    func GetTotalLiveParametersCompleted(success: Bool, data: [Live_Parameters_Table])
    {
        if data.count > 0
        {
            DAL.DeleteLive_Parameters_Totals(ID_Team: data[0].ID_Team)
            for curr in data {
                DAL.Save_Total_Live_Parameters_Table(curr)
            }
        }
        APIHelper.GetLiveDevices(self)
    }
    
    func GetLiveDevicesCompleted(success: Bool, data: [NewLive_Devices])
    {
        DAL.DeleteTeamDevices(teamID: SharedInfo.TeamID)
        for curr in data {
            DAL.SaveNewLive_Devices(curr)
        }
        APIHelper.GetTeamHrThresholds(self)
    }
    
    func GetTeamHrThresholdsCompleted(success: Bool, data: [Team_HRThreshold])
    {
        for curr in data {
            DAL.SaveTeam_HRThreshold(curr)
        }
        APIHelper.GetTeamSpeedThresholds(self)
    }
    
    func GetTeamSpeedThresholdsCompleted(success: Bool, data: [Team_SpeedThreshold])
    {
        for curr in data {
            DAL.SaveTeam_SpeedThreshold(curr)
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
                
                DispatchQueue.main.async() { () -> Void in
                    let alert = UIAlertController(title: NSLocalizedString("", comment: ""), message: NSLocalizedString("Session name:", comment: "") , preferredStyle: UIAlertController.Style.alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Save", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
                        
                        var textField: UITextField? = alert.textFields?.first
                        
                        if textField != nil
                        {
                            data.SessionName = textField!.text ?? data.SessionName
                        }
                        
                        DispatchQueue.main.async(execute: {
                            self.wbView.isHidden = true
                            self.btnStop.isHidden = true
                            self.lblDuration.isHidden = true
                            self.vwBottomBar.isHidden = true
                            self.lblLoadingSession.text = "SAVING SESSION... PLEASE DO NOT TURN OFF YOUR ANTENNA."
                            self.lblLoadingSession.isHidden = false
                            
                        })
                        
                        DAL.SaveSessionData(data)
                        APIHelper.StopSession(self)
                        
                    }))
                    alert.view.tintColor = UIColor.black
                    alert.addTextField(configurationHandler: { textField in
                        textField.text = data.SessionName
                    })

                    
                    self.present(alert, animated: true, completion: nil)
                }
                
                
                
                
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


    
    func CreateSessionCompleted(success: Bool, message: String, data: SessionData)
    {
        if success {
            DAL.SetSessionDataAsLoaded(data)
        }
    
        DispatchQueue.main.async() { () -> Void in
//            self.lblLoadingSession.isHidden = true
            if success
            {
                self.lblLoadingSession.text = "TO START A NEW SESSION CONNECT TO K-50 WIFI"
            }
            else
            {
                self.lblLoadingSession.text = message
            }
        }
    }
    
    
    
    
    
}
