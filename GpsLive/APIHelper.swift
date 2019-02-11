//
//  APIHelper.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 23/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import Foundation
import JsonSerializerSwift

class APIHelper
{
    static let mobileApi = "http://www.k-sportonline.com/Mobile/"
    static let antennaApi = "http://10.3.141.1/Home/"
    
    static func CheckLogin(_ delegate: AuthDelegate, username: String, password: String)
    {

        let urlString = mobileApi + "CheckLogin"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            request.addValue(username, forHTTPHeaderField: "ks_usr")
            request.addValue(password, forHTTPHeaderField: "ks_pwd")
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Success"] as? Bool
                        
                        if success != nil
                        {
                            let username = json["Username"] as? String
                            delegate.CheckLoginCompleted(success: success!, username: username)
                        }
                    }
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func Ping(_ delegate: SessionDelegate)
    {
        
        let urlString = antennaApi + "Ping"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            let start = Date.timeIntervalSinceReferenceDate
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let end = Date.timeIntervalSinceReferenceDate
                        let delay = end - start
                        
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            let version = json["version"] as? String
                            delegate.PingCompleted(success: true, time: delay * 1000, version: version)
                        }
                    }
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func GetSessionTypes(_ delegate: SyncDelegate)
    {
        
            let urlString = mobileApi + "GetSessionTypes"
            
            let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
            if url != nil
            {
                var request = URLRequest(url: url!)
                request.httpMethod = "GET"
                request.addValue("application/json",forHTTPHeaderField: "Content-Type")
                request.addValue("application/json",forHTTPHeaderField: "Accept")

                if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
                {
                    request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                    let pwd = SharedInfo.getPassword()
                    request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
                }
                
                let config = URLSessionConfiguration.default
                let session = URLSession(configuration: config)
                let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                    
                    
                    do {
                        if data != nil
                        {
                            let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                            
                            let success = json["Result"] as? String
                            
                            if success != nil && success == "OK"
                            {
                                
                                let usersData = json["Records"] as! [[String:AnyObject]]
                                
                                var res : [SessionType_DTO] = []
                                
                                for userData  in usersData
                                {
                                    let curr = SessionType_DTO();
                                    curr.Team_ID = userData["Team_ID"] as! Int32
                                    curr.SessionTypeId = userData["SessionTypeId"] as! Int32
                                    curr.SessionName = userData["SessionName"] as! String
//                                    curr.isTotal = userData["isTotal"] as! Bool
                                    curr.KSSessionTypeKey = userData["KSSessionTypeKey"] as? Int32
                                    res.append(curr)
                                }

                                delegate.GetSessionTypesCompleted(success: true, data: res)
                            }
                        }
                        
                    } catch {
                        // stuff if fails
                        print("Error, Could not parse the JSON request")
                    }
                    
                });
                task.resume()
                
            }
        
    }
    
    static func GetParameterInfo(_ delegate: SyncDelegate)
    {
        
        let urlString = mobileApi + "GetParameterInfo"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let usersData = json["Records"] as! [[String:AnyObject]]
                            
                            var res : [ParameterInfo] = []
                            
                            for userData  in usersData
                            {
                                let curr = ParameterInfo();
                                curr.ID_Parameter = userData["ID_Parameter"] as! Int32
                                curr.ID_Team = userData["ID_Team"] as! Int32
                                curr.Name = userData["Name"] as! String
                                curr.Description = userData["Description"] as? String
                                curr.MeasureUnit = userData["MeasureUnit"] as? String
                                curr.NumberOfDecimals = userData["NumberOfDecimals"] as? Int32
                                curr.ParenthesisNote = userData["ParenthesisNote"] as? String
                                curr.KSportParam_Key = userData["KSportParam_Key"] as? Int32
                                curr.ParameterType = userData["ParameterType"] as! String
                                curr.IsUserDefined = userData["IsUserDefined"] as! Bool
                                curr.Formula = userData["Formula"] as? String
                                res.append(curr)
                            }
                            
                            delegate.GetParameterInfoCompleted(success: true, data: res)
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func GetPlayers(_ delegate: SyncDelegate)
    {
        
        let urlString = mobileApi + "GetPlayers"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let usersData = json["Records"] as! [[String:AnyObject]]
                            
                            var res : [PlayerInfo] = []
                            
                            for userData  in usersData
                            {
                                let curr = PlayerInfo();
                                curr.ID = userData["ID"] as! Int32
                                curr.Team_ID = userData["Team_ID"] as! Int32
                                curr.Number = userData["Number"] as! Int32
                                curr.NickName = userData["NickName"] as! String
                                curr.ImagePath = userData["ImagePath"] as? String
                                curr.Position = userData["Position"] as? String
                                curr.IsCurrentSeason = userData["IsCurrentSeason"] as! Bool
                                curr.HrMax = userData["HrMax"] as? Int32
                                curr.HrMin = userData["HrMin"] as? Int32
                                curr.SpeedMax = userData["SpeedMax"] as? Double
                                res.append(curr)
                            }
                            
                            delegate.GetPlayersCompleted(success: true, data: res)
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func GetTeam(_ delegate: SyncDelegate)
    {
        
        let urlString = mobileApi + "GetTeam"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let usersData = json["Records"] as! [[String:AnyObject]]
                            
                            var res : [TeamInfo] = []
                            
                            for userData  in usersData
                            {
                                let curr = TeamInfo();
                                curr.Team_ID = userData["Team_ID"] as! Int32
                                curr.Name = userData["Name"] as! String
                                curr.LiveType = userData["LiveType"] as! Int32
                                curr.LiveChannel = userData["LiveChannel"] as! Int32
                                curr.Logo = userData["Logo"] as! Int32
                                curr.SpeedThresholdsPercentage = userData["SpeedThresholdsPercentage"] as! Bool
                                res.append(curr)
                            }
                            
                            delegate.GetTeamCompleted(success: true, data: res)
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func GetLiveParameters(_ delegate: SyncDelegate)
    {
        
        let urlString = mobileApi + "GetLiveParameters"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let usersData = json["Records"] as! [[String:AnyObject]]
                            
                            var res : [Live_Parameters_Table] = []
                            
                            for userData  in usersData
                            {
                                let curr = Live_Parameters_Table();
                                curr.ID_Team = userData["ID_Team"] as! Int32
                                curr.ColumnNumber = userData["ColumnNumber"] as! Int32
                                curr.ID_Parameter = userData["ID_Parameter"] as! Int32
                                res.append(curr)
                            }
                            
                            delegate.GetLiveParametersCompleted(success: true, data: res)
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    

    
    static func GetLiveDevices(_ delegate: SyncDelegate)
    {
        
        let urlString = mobileApi + "GetLiveDevices"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let usersData = json["Records"] as! [[String:AnyObject]]
                            
                            var res : [NewLive_Devices] = []
                            
                            for userData  in usersData
                            {
                                let curr = NewLive_Devices();
                                curr.TeamID = userData["TeamID"] as! Int32
                                curr.DeviceID = userData["DeviceID"] as! Int32
                                res.append(curr)
                            }
                            
                            delegate.GetLiveDevicesCompleted(success: true, data: res)
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func IsSessionActive(_ delegate: SessionDelegate)
    {
        
        let urlString = antennaApi + "IsSessionActive"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let result = json["result"] as? String
                        let elapsed = json["elapsed"] as! Int
                        
                        if result != nil
                        {
                            
                            if result == "true"
                            {
                                delegate.IsSessionActiveCompleted(success: true, active: true, elapsed: elapsed)
                            }
                            else
                            {
                                delegate.IsSessionActiveCompleted(success: true, active: false, elapsed: elapsed)
                            }
                            
                        }

                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func StartSession(_ delegate: SessionDelegate)
    {
        let date = Date()
        let dateFormatterDate = DateFormatter()
        dateFormatterDate.dateFormat = "yyyy-MM-dd"
        
        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = "HH:mm:ss"
        
        let dateString = dateFormatterDate.string(from: date)
        let timeString = dateFormatterTime.string(from: date)
        
        let urlString = antennaApi + "StartSession?teamID=\(SharedInfo.TeamID)&date=\(dateString)&time=\(timeString)"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let result = json["result"] as? String
                        
                        if result != nil
                        {
                            
                            if result == "OK"
                            {
                                delegate.StartStopSessionCompleted(success: true, start: true)
                            }
                            else
                            {
                                delegate.StartStopSessionCompleted(success: false, start: true)
                            }
                            
                        }
                        
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func StopSession(_ delegate: SessionDelegate)
    {
        
        let urlString = antennaApi + "StopSession?teamID=\(SharedInfo.TeamID)"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let result = json["result"] as? String
                        
                        if result != nil
                        {
                            
                            if result == "OK"
                            {
                                delegate.StartStopSessionCompleted(success: true, start: false)
                            }
                            else
                            {
                                delegate.StartStopSessionCompleted(success: false, start: false)
                            }
                            
                        }
                        
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func SyncTeam(_ delegate: SyncDelegate)
    {
        
        
        let urlString = antennaApi + "SyncTeam"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            
            let model = SyncModel()
            model.Players = DAL.LoadPlayerInfoByTeamID(teamID: SharedInfo.TeamID)
            model.Devices = DAL.LoadNewLive_DevicesByTeam(ID_Team: SharedInfo.TeamID)
            model.LiveParams = DAL.LoadLive_Parameters_TableByTeam(ID_Team: SharedInfo.TeamID)
            model.Parameters = DAL.LoadParameterInfoByTeamID(TeamID: SharedInfo.TeamID)
            model.Teams = DAL.LoadTeamByID(Team_ID: SharedInfo.TeamID)
            model.SessionTypes = DAL.LoadSessionTypeByTeamID(Team_ID: SharedInfo.TeamID)
            
            let serialized  = JSONSerializer.toJson(model, prettify: false)
            
            
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            request.httpBody = serialized.data(using: .utf8)
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["result"] as? String
                        let message = json["message"] as? String
                        
                        
                        
                        if success != nil && success == "OK"
                        {
                            delegate.SyncTeamCompleted(success: true, data: message)
                        }
                        else
                        {
                            delegate.SyncTeamCompleted(success: false, data: message)
                        }
                    }
                    
                } catch {
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    static func GetSessionData(_ delegate: SessionDelegate)
    {
        
        let urlString = antennaApi + "GetSessionData"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task : URLSessionDataTask = session.dataTask(with: request, completionHandler: {(data, response, error) in
                
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["result"] as? String
                        
                        if success != nil && success == "OK"
                        {
                            
                            let sessionData = json["data"] as! [String:AnyObject]
                            let canLoad = json["canLoad"] as? String
                            
                            if canLoad == "OK"
                            {
                            }
                            let session = SessionData()
                            session.SessionName = sessionData["sessionName"] as! String
                            session.Team_Id = sessionData["team_Id"] as! Int32
                            
                            let drillsData = sessionData["drills"] as! [[String:AnyObject]]
                            
                            for drillData  in drillsData
                            {
                                let curr = DrillData();
                                curr.DrillName = drillData["drillName"] as! String
                                curr.SessionTypeId = drillData["sessionTypeId"] as! Int32
                                curr.Training = drillData["training"] as! Bool
                                curr.MachineName = UIDevice.current.name
                                curr.Date = drillData["date"] as! Int32
                                curr.Hour = drillData["hour"] as! Int32
                                
                                let playersData = drillData["playerDatas"] as! [[String:AnyObject]]
                                for playerData  in playersData
                                {
                                    let plCurr = PlayerData_DTO()
                                    plCurr.ID_Player = playerData["iD_Player"] as! Int32
                                    plCurr.ID_Session = playerData["iD_Session"] as! Int32
                                    plCurr.ID_Parameter = playerData["iD_Parameter"] as! Int32
                                    plCurr.Value = playerData["value"] as! Double
                                    
                                    curr.PlayerDatas.append(plCurr)
                                }
                                
                                session.Drills.append(curr)
                            }
                            
                      
                            delegate.GetSessionDataCompleted(success: true, data: session, canLoad: canLoad == "OK")
                        }
                    }
                    
                } catch {
                    // stuff if fails
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }

    static func CreateSession(_ delegate: SessionDelegate, session: SessionData)
    {
        
        
        let urlString = mobileApi + "CreateSession"
        
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        if url != nil
        {
            var request = URLRequest(url: url!)
            request.httpMethod = "POST"

            let serialized  = JSONSerializer.toJson(session, prettify: false)
            
            
            request.addValue("application/json",forHTTPHeaderField: "Content-Type")
            request.addValue("application/json",forHTTPHeaderField: "Accept")
            request.httpBody = serialized.data(using: .utf8)
            
            print(serialized)
            
            if SharedInfo.getUserName() != "" && SharedInfo.getPassword() != ""
            {
                request.addValue(SharedInfo.getUserName(), forHTTPHeaderField: "ks_usr")
                let pwd = SharedInfo.getPassword()
                request.addValue(pwd, forHTTPHeaderField: "ks_pwd")
            }
            
            let config = URLSessionConfiguration.default
            let urlsession = URLSession(configuration: config)
            let task : URLSessionDataTask = urlsession.dataTask(with: request, completionHandler: {(data, response, error) in
                
                do {
                    if data != nil
                    {
                        let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                        
                        let success = json["Result"] as? String
                        let message = json["Message"] as? String
                        
                        
                        if success != nil && success == "OK"
                        {
                            delegate.CreateSessionCompleted(success: true, data: session)
                        }
                        else
                        {
                            delegate.CreateSessionCompleted(success: false, data: session)
                        }
                    }
                    
                } catch {
                    print("Error, Could not parse the JSON request")
                }
                
            });
            task.resume()
            
        }
        
    }
    
    
}

protocol AuthDelegate
{
    func CheckLoginCompleted(success: Bool, username: String?)
}

protocol SyncDelegate
{
    func GetSessionTypesCompleted(success: Bool, data : [SessionType_DTO])
    func GetParameterInfoCompleted(success: Bool, data : [ParameterInfo])
    func GetPlayersCompleted(success: Bool, data : [PlayerInfo])
    func GetTeamCompleted(success: Bool, data : [TeamInfo])
    func GetLiveParametersCompleted(success: Bool, data : [Live_Parameters_Table])
    func GetLiveDevicesCompleted(success: Bool, data : [NewLive_Devices])
    func SyncTeamCompleted(success: Bool, data : String?)
}

protocol SessionDelegate
{
    func IsSessionActiveCompleted(success: Bool, active : Bool, elapsed: Int)
    func StartStopSessionCompleted(success: Bool, start : Bool)
    func PingCompleted(success: Bool, time : TimeInterval, version: String?)
    func GetSessionDataCompleted(success: Bool, data : SessionData, canLoad: Bool)
    func CreateSessionCompleted(success: Bool, data : SessionData)
}
