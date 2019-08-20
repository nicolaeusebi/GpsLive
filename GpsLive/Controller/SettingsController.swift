//
//  SettingsController.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 07/01/2019.
//  Copyright © 2019 Nicola Eusebi. All rights reserved.
//

import UIKit
import FilesProvider




class SettingsController: UIViewController, FileProviderDelegate, SyncDelegate, SessionDelegate {
    
    
    
    

    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnUpdateFirmware: UIButton!
    @IBOutlet weak var lblMessage: UILabel!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    @IBOutlet weak var btnSynch: UIButton!
    @IBOutlet weak var activitySync: UIActivityIndicatorView!
    @IBOutlet weak var lblSyncMEssage: UILabel!
    @IBOutlet weak var lblFirmwareName: UILabel!
    @IBOutlet weak var lblUpdateAntenna: UILabel!
    
    let server: URL = URL(string: "ftp://10.3.141.1/")!
    let username = "nicola"
    let password = "ksportk50"
    let firmwareName = "v1103_firmware"
    
    var ftp: FTPFileProvider?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.activity.isHidden = true
        self.activitySync.isHidden = true
        
        lblFirmwareName.text = firmwareName
        
        if SharedInfo.ISK50Network {
            APIHelper.Ping(self)
        }
        
    }
    @IBAction func btnSyncTouched(_ sender: Any)
    {
        StartSyncData()
    }
    
    @IBAction func btnBackTouched(_ sender: Any)
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnUpdateFirmwareTouched(_ sender: Any)
    {
        
        let alert = UIAlertController(title: NSLocalizedString("Warning", comment: ""), message: NSLocalizedString("This procedure could take some minutes to complete, do not turn off you iPad or Antenna during the procedure. Do you want to proceed?", comment: "") , preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "") , style: UIAlertAction.Style.default, handler: nil))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Continue", comment: "")  ,style: UIAlertAction.Style.default, handler: { (_) -> Void in
            
            self.activity.isHidden = false
            self.activity.startAnimating()
            self.lblMessage.text = "Uploading firmware: 0%"
            self.lblMessage.isHidden = false
            
            let credential = URLCredential(user: self.username, password: self.password, persistence: .permanent)
            self.ftp = FTPFileProvider(baseURL: self.server, mode: FTPFileProvider.Mode.passive, credential: credential, cache: nil)
            self.ftp?.securedDataConnection = false
            self.ftp?.serverTrustPolicy = .disableEvaluation
            self.ftp?.delegate = self as FileProviderDelegate
            
            
            //Upload Firmware to Antenna via FTP
            let source = Bundle.main.url(forResource: self.firmwareName, withExtension:"zip");
            let file: FileHandle? = FileHandle(forReadingAtPath: source!.path)
            
            if file != nil {
                // Read all the data
                let data = file?.readDataToEndOfFile()
                
                self.ftp?.writeContents(path: "/home/nicola/\(self.firmwareName).zip", contents: data, atomically: true, overwrite: true, completionHandler: nil)
                
                // Close the file
                file?.closeFile()
                
            }
            else {
                print("Ooops! Something went wrong!")
            }
            
        }))
        alert.view.tintColor = UIColor.black
        
        
        self.present(alert, animated: true, completion: nil)
        
        
        
    }
    
    
    func startUpdate()
    {
        
        
        let session = NMSSHSession.connect(toHost: "10.3.141.1:22", withUsername: username)
        
        if session.isConnected {
            session.authenticate(byPassword: password)
            
            if session.isAuthorized {
                print("Authentication succeeded")
            }
        }
        
        let response = session.channel.execute("dotnet /home/nicola/UpdateManager/UpdateManager.dll", error: nil)
        print("\(response)")

        session.disconnect()
        
        DispatchQueue.main.async(execute: {
            self.activity.isHidden = true
            self.activity.stopAnimating()
            if response == "ok\n\n"
            {
                self.lblMessage.text = "UPDATE COMPLETED!"
                self.lblMessage.isHidden = false
            }
            else
            {
                self.lblMessage.text = "An error has occurred!"
                self.lblMessage.isHidden = false
            }
        })
        
        
    }
    
    func StartSyncData() {
        DispatchQueue.main.async(execute: {
            self.lblSyncMEssage.isHidden = false;
            self.activitySync.isHidden = false
            self.activitySync.startAnimating()
            self.lblSyncMEssage.text = "Synchronizing data..."
            APIHelper.SyncTeam(self)
        })
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    func fileproviderSucceed(_ fileProvider: FileProviderOperations, operation: FileOperationType)
    {
        DispatchQueue.main.async(execute: {
            //Once the firmare is upload start the update procedure via SSH
            self.startUpdate()
        })
        
        
    }
    
    func fileproviderFailed(_ fileProvider: FileProviderOperations, operation: FileOperationType, error: Error)
    {
        
    }
    
    func fileproviderProgress(_ fileProvider: FileProviderOperations, operation: FileOperationType, progress: Float)
    {
        let percent = Int(progress * 100)
        DispatchQueue.main.async(execute: {
            self.lblMessage.text = "Uploading Firmware: \(percent)%"
            if percent == 100
            {
                self.lblMessage.text = "Installing Firmware. Do not turn off you iPad and Antenna..."
            }
        })
        
    }
    
    func GetTeamCompleted(success: Bool, data: [TeamInfo])
    {
        var teamName = ""
        for curr in data {
            DAL.SaveTeamInfo(curr)
            teamName = curr.Name
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
//        DispatchQueue.main.async() { () -> Void in
//            self.activityIndicator.stopAnimating()
//            self.vwActivityBar.isHidden = true
//        }
    }
    
    func SyncTeamCompleted(success: Bool, data: String?)
    {
        DispatchQueue.main.async() { () -> Void in
            self.activitySync.stopAnimating()
            self.activitySync.isHidden = true
            self.lblSyncMEssage.isHidden = true
        }
    }
    
    func IsSessionActiveCompleted(success: Bool, active: Bool, elapsed: Int) {
        
    }
    
    func StartStopSessionCompleted(success: Bool, start: Bool) {
        
    }
    
    func PingCompleted(success: Bool, time: TimeInterval, version: String?)
    {
        if success && version != nil
        {
            DispatchQueue.main.async() { () -> Void in
                self.lblUpdateAntenna.text = "Update Antenna Firmware (current version v\(version!)):"
            }
            
        }
    }
    
    func GetSessionDataCompleted(success: Bool, data: SessionData, canLoad: Bool) {
        
    }
    
    func CreateSessionCompleted(success: Bool, message: String, data: SessionData) {
        
    }
    
    func GetTotalLiveParametersCompleted(success: Bool, data: [Live_Parameters_Table]) {
        
    }

}
