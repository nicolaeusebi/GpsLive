//
//  DAL.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 25/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import Foundation


class DAL
{
    
    
    static var databasePath : String? = "";
    
    static var backupName = ""

    static func CheckDatabase()
    {
        do
        {
            let source = Bundle.main.url(forResource: "gpslive", withExtension:"sqlite3");
            let documentsDirectory = try FileManager.default.url(for: FileManager.SearchPathDirectory.documentDirectory, in:FileManager.SearchPathDomainMask.userDomainMask, appropriateFor:nil, create:false);
            var destination = documentsDirectory
            destination = destination.appendingPathComponent("database.sqlite3")
            databasePath = destination.path;
            
            if (FileManager.default.fileExists(atPath: databasePath!) == false)
            {
                
                try FileManager.default.copyItem(at: source!, to:destination)
            }
        }
        catch let error as NSError {
            print(error)
        }
    }
    
    static func LoadTeams() -> [TeamInfo]
    {
        var teams : [TeamInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM TeamInfo;"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = TeamInfo();
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.Name = results!.string(forColumn: "Name")
                curr.LiveType = results!.int(forColumn: "LiveType")
                curr.LiveChannel = results!.int(forColumn: "LiveChannel")
                curr.Logo = results!.int(forColumn: "Logo")
                curr.SpeedThresholdsPercentage = results!.bool(forColumn: "SpeedThresholdsPercentage")
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadTeamByID(Team_ID: Int32) -> [TeamInfo]
    {
        var teams : [TeamInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM TeamInfo where Team_ID = \(Team_ID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = TeamInfo();
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.Name = results!.string(forColumn: "Name")
                curr.LiveType = results!.int(forColumn: "LiveType")
                curr.LiveChannel = results!.int(forColumn: "LiveChannel")
                curr.Logo = results!.int(forColumn: "Logo")
                curr.SpeedThresholdsPercentage = results!.bool(forColumn: "SpeedThresholdsPercentage")
                teams.append(curr)
            }

            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func SaveTeamInfo(_ team: TeamInfo)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadTeamByID(Team_ID: team.Team_ID)
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO TeamInfo ( Team_ID, Name, LiveType, LiveChannel, Logo, SpeedThresholdsPercentage) VALUES (\(team.Team_ID),'\(team.Name)',\(team.LiveType), \(team.LiveChannel), \(team.Logo) ,\(NSNumber(value: team.SpeedThresholdsPercentage as Bool)));"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update TeamInfo SET Name = '\(team.Name)', LiveType = \(team.LiveType), LiveChannel = \(team.LiveChannel), Logo = \(team.Logo), SpeedThresholdsPercentage = \(NSNumber(value: team.SpeedThresholdsPercentage as Bool)) where Team_ID = \(team.Team_ID);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func LoadSessionTypeByID(Team_ID: Int32, SessionTypeId: Int32) -> [SessionType_DTO]
    {
        var teams : [SessionType_DTO] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM SessionType where SessionTypeId = \(SessionTypeId) and Team_ID = \(Team_ID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = SessionType_DTO();
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.SessionTypeId = results!.int(forColumn: "SessionTypeId")
                curr.SessionName = results!.string(forColumn: "SessionName")
                curr.training = results!.bool(forColumn: "training")
//                curr.isTotal = results!.bool(forColumn: "isTotal")
                if results!.columnIsNull("KSSessionTypeKey") == false
                {
                    curr.KSSessionTypeKey = results!.int(forColumn: "KSSessionTypeKey")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadSessionTypeByTeamID(Team_ID: Int32) -> [SessionType_DTO]
    {
        var teams : [SessionType_DTO] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM SessionType where Team_ID = \(Team_ID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = SessionType_DTO();
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.SessionTypeId = results!.int(forColumn: "SessionTypeId")
                curr.SessionName = results!.string(forColumn: "SessionName")
                curr.training = results!.bool(forColumn: "training")
//                curr.isTotal = results!.bool(forColumn: "isTotal")
                if results!.columnIsNull("KSSessionTypeKey") == false
                {
                    curr.KSSessionTypeKey = results!.int(forColumn: "KSSessionTypeKey")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func SaveSessionType(_ data: SessionType_DTO)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadSessionTypeByID(Team_ID: data.Team_ID, SessionTypeId: data.SessionTypeId)
            
            let ksSessionType  = data.KSSessionTypeKey != nil ? "\(data.KSSessionTypeKey!)" : "NULL"
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO SessionType ( Team_ID, SessionTypeId, SessionName, training, KSSessionTypeKey) VALUES (\(data.Team_ID), \(data.SessionTypeId), '\(data.SessionName)', \(NSNumber(value: data.training as Bool)) , \(ksSessionType));"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update SessionType SET SessionName = '\(data.SessionName)', training = \(NSNumber(value: data.training as Bool)), KSSessionTypeKey = \(ksSessionType) where SessionTypeId = \(data.SessionTypeId);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func SetSessionDataAsLoaded(_ data: SessionData)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            
            
            let insertSQL = "UPDATE SessionData SET Loaded = 1 where idSession = \(data.idSession);"
            
            
            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            if !result! {
                print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            } else {
                
                
            }
            
            
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func SaveSessionData(_ data: SessionData)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            

                
                var insertSQL = "INSERT INTO SessionData ( SessionName, Team_Id) VALUES ('\(data.SessionName)', \(data.Team_Id));"
                
                
                var result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                    let id = Int32(FMDatabase.lastInsertRowId(contactDB!)())
                    data.idSession = id;
                    
                    for drill in data.Drills
                    {
                        insertSQL = "INSERT INTO DrillData (idSession, DrillName, SessionTypeId, Date, Training, Hour, MachineName) VALUES (\(data.idSession), '\(drill.DrillName)', \(drill.SessionTypeId), \(drill.Date), \(NSNumber(value: drill.Training as Bool)), \(drill.Hour), '\(drill.MachineName)');"
                        
                        result = contactDB?.executeUpdate(insertSQL,
                                                              withArgumentsIn: nil)
                        
                        let drillID = Int32(FMDatabase.lastInsertRowId(contactDB!)())
                        
                        for plData in drill.PlayerDatas
                        {
                            insertSQL = "INSERT INTO PlayerData_DTO (idDrill, ID_Player, ID_Parameter, Value) VALUES (\(drillID), \(plData.ID_Player), \(plData.ID_Parameter), \(plData.Value));"
                            
                            result = contactDB?.executeUpdate(insertSQL,
                                                              withArgumentsIn: nil)
                        }
                        
                    }
                    
                }
                

            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func LoadUnloadedSessionData() -> [SessionData]
    {
        var sessions : [SessionData] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM SessionData where Loaded = 0;"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = SessionData();
                curr.SessionName = results!.string(forColumn: "SessionName")
                curr.Team_Id = results!.int(forColumn: "Team_Id")
                curr.idSession = results!.int(forColumn: "idSession")
                sessions.append(curr)
            }
            
            contactDB?.close()
            
            for session in sessions
            {
                session.Drills = LoadDrillDataBySessionID(idSession: session.idSession)
            }
            
            return sessions;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadDrillDataBySessionID(idSession: Int32) -> [DrillData]
    {
        var drills : [DrillData] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM DrillData where idSession = \(idSession);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = DrillData();
                curr.idDrill = results!.int(forColumn: "idDrill")
                curr.DrillName = results!.string(forColumn: "DrillName")
                curr.SessionTypeId = results!.int(forColumn: "SessionTypeId")
                curr.Date = results!.int(forColumn: "Date")
                curr.Training = results!.bool(forColumn: "Training")
                curr.Hour = results!.int(forColumn: "Hour")
                curr.MachineName = results!.string(forColumn: "MachineName")
                drills.append(curr)
            }
            
            contactDB?.close()
            
            for drill in drills
            {
                drill.PlayerDatas = LoadPlayerDataByDrillID(idDrill: drill.idDrill)
            }
            
            return drills;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadPlayerDataByDrillID(idDrill: Int32) -> [PlayerData_DTO]
    {
        var teams : [PlayerData_DTO] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM PlayerData_DTO where idDrill = \(idDrill);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = PlayerData_DTO();
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                curr.ID_Player = results!.int(forColumn: "ID_Player")
                curr.Value = results!.double(forColumn: "Value")
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadParameterInfoByID(ID_Parameter: Int32) -> [ParameterInfo]
    {
        var teams : [ParameterInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM ParameterInfo where ID_Parameter = \(ID_Parameter);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = ParameterInfo();
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.Name = results!.string(forColumn: "Name")
                if results!.columnIsNull("Description") == false
                {
                    curr.Description = results!.string(forColumn: "Description")
                }
                
                if results!.columnIsNull("MeasureUnit") == false
                {
                    curr.MeasureUnit = results!.string(forColumn: "MeasureUnit")
                }
                
                if results!.columnIsNull("NumberOfDecimals") == false
                {
                    curr.NumberOfDecimals = results!.int(forColumn: "NumberOfDecimals")
                }
                
                if results!.columnIsNull("ParenthesisNote") == false
                {
                    curr.ParenthesisNote = results!.string(forColumn: "ParenthesisNote")
                }
                
                if results!.columnIsNull("KSportParam_Key") == false
                {
                    curr.KSportParam_Key = results!.int(forColumn: "KSportParam_Key")
                }
                
                curr.ParameterType = results!.string(forColumn: "ParameterType")
                curr.IsUserDefined = results!.bool(forColumn: "IsUserDefined")
                
                if results!.columnIsNull("Formula") == false
                {
                    curr.Formula = results!.string(forColumn: "Formula")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadParameterInfoByTeamID(TeamID: Int32) -> [ParameterInfo]
    {
        var teams : [ParameterInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM ParameterInfo where ID_Team = \(TeamID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = ParameterInfo();
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.Name = results!.string(forColumn: "Name")
                if results!.columnIsNull("Description") == false
                {
                    curr.Description = results!.string(forColumn: "Description")
                }
                
                if results!.columnIsNull("MeasureUnit") == false
                {
                    curr.MeasureUnit = results!.string(forColumn: "MeasureUnit")
                }
                
                if results!.columnIsNull("NumberOfDecimals") == false
                {
                    curr.NumberOfDecimals = results!.int(forColumn: "NumberOfDecimals")
                }
                
                if results!.columnIsNull("ParenthesisNote") == false
                {
                    curr.ParenthesisNote = results!.string(forColumn: "ParenthesisNote")
                }
                
                if results!.columnIsNull("KSportParam_Key") == false
                {
                    curr.KSportParam_Key = results!.int(forColumn: "KSportParam_Key")
                }
                
                curr.ParameterType = results!.string(forColumn: "ParameterType")
                curr.IsUserDefined = results!.bool(forColumn: "IsUserDefined")
                
                if results!.columnIsNull("Formula") == false
                {
                    curr.Formula = results!.string(forColumn: "Formula")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func SaveParameterInfo(_ data: ParameterInfo)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadParameterInfoByID(ID_Parameter: data.ID_Parameter)
            
            let Description  = data.Description != nil ? "\(data.Description!)" : "NULL"
            let MeasureUnit  = data.MeasureUnit != nil ? "\(data.MeasureUnit!)" : "NULL"
            let NumberOfDecimals  = data.NumberOfDecimals != nil ? "\(data.NumberOfDecimals!)" : "NULL"
            let ParenthesisNote  = data.ParenthesisNote != nil ? "\(data.ParenthesisNote!)" : "NULL"
            let KSportParam_Key  = data.KSportParam_Key != nil ? "\(data.KSportParam_Key!)" : "NULL"
            let Formula  = data.Formula != nil ? "\(data.Formula!)" : "NULL"
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO ParameterInfo ( ID_Parameter, ID_Team, Name, Description, MeasureUnit, NumberOfDecimals, ParenthesisNote, KSportParam_Key, ParameterType, IsUserDefined, Formula) VALUES (\(data.ID_Parameter), \(data.ID_Team), '\(data.Name)', '\(Description)', '\(MeasureUnit)', \(NumberOfDecimals), '\(ParenthesisNote)', \(KSportParam_Key), '\(data.ParameterType)', \(NSNumber(value: data.IsUserDefined as Bool)), '\(Formula)');"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update ParameterInfo SET Name = '\(data.Name)', Description = '\(Description)', MeasureUnit = '\(MeasureUnit)', NumberOfDecimals = \(NumberOfDecimals), ParenthesisNote = '\(ParenthesisNote)', KSportParam_Key = \(KSportParam_Key), ParameterType = '\(data.ParameterType)', IsUserDefined = \(NSNumber(value: data.IsUserDefined as Bool)), Formula = '\(Formula)' where ID_Parameter = \(data.ID_Parameter);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }

    static func LoadPlayerInfoByID(ID: Int32) -> [PlayerInfo]
    {
        var teams : [PlayerInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM PlayerInfo where ID = \(ID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = PlayerInfo();
                curr.ID = results!.int(forColumn: "ID")
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.Number = results!.int(forColumn: "Number")
                curr.NickName = results!.string(forColumn: "NickName")
                
                if results!.columnIsNull("ImagePath") == false
                {
                    curr.ImagePath = results!.string(forColumn: "ImagePath")
                }
                
                if results!.columnIsNull("Position") == false
                {
                    curr.Position = results!.string(forColumn: "Position")
                }
                
                curr.IsCurrentSeason = results!.bool(forColumn: "IsCurrentSeason")
                
                if results!.columnIsNull("HrMax") == false
                {
                    curr.HrMax = results!.int(forColumn: "HrMax")
                }
                
                if results!.columnIsNull("HrMin") == false
                {
                    curr.HrMin = results!.int(forColumn: "HrMin")
                }
                
                if results!.columnIsNull("SpeedMax") == false
                {
                    curr.SpeedMax = results!.double(forColumn: "SpeedMax")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadPlayerInfoByTeamID(teamID: Int32) -> [PlayerInfo]
    {
        var teams : [PlayerInfo] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM PlayerInfo where Team_ID = \(teamID);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = PlayerInfo();
                curr.ID = results!.int(forColumn: "ID")
                curr.Team_ID = results!.int(forColumn: "Team_ID")
                curr.Number = results!.int(forColumn: "Number")
                curr.NickName = results!.string(forColumn: "NickName")
                
                if results!.columnIsNull("ImagePath") == false
                {
                    curr.ImagePath = results!.string(forColumn: "ImagePath")
                }
                
                if results!.columnIsNull("Position") == false
                {
                    curr.Position = results!.string(forColumn: "Position")
                }
                
                curr.IsCurrentSeason = results!.bool(forColumn: "IsCurrentSeason")
                
                if results!.columnIsNull("HrMax") == false
                {
                    curr.HrMax = results!.int(forColumn: "HrMax")
                }
                
                if results!.columnIsNull("HrMin") == false
                {
                    curr.HrMin = results!.int(forColumn: "HrMin")
                }
                
                if results!.columnIsNull("SpeedMax") == false
                {
                    curr.SpeedMax = results!.double(forColumn: "SpeedMax")
                }
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func SavePlayerInfo(_ data: PlayerInfo)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadPlayerInfoByID(ID: data.ID)
            
            let ImagePath  = data.ImagePath != nil ? "\(data.ImagePath!)" : "NULL"
            let Position  = data.Position != nil ? "\(data.Position!)" : "NULL"
            let HrMax  = data.HrMax != nil ? "\(data.HrMax!)" : "NULL"
            let HrMin  = data.HrMin != nil ? "\(data.HrMin!)" : "NULL"
            let SpeedMax  = data.SpeedMax != nil ? "\(data.SpeedMax!)" : "NULL"
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO PlayerInfo ( ID, Team_ID, Number, NickName, ImagePath, Position, IsCurrentSeason, HrMax, HrMin, SpeedMax) VALUES (\(data.ID), \(data.Team_ID), \(data.Number), '\(data.NickName)', '\(ImagePath)', '\(Position)', \(NSNumber(value: data.IsCurrentSeason as Bool)), \(HrMax), \(HrMin), \(SpeedMax));"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update PlayerInfo SET Number = \(data.Number), NickName = '\(data.NickName)', ImagePath = '\(ImagePath)', Position = '\(Position)', IsCurrentSeason = \(NSNumber(value: data.IsCurrentSeason as Bool)), HrMax = \(HrMax), HrMin = \(HrMin), SpeedMax = \(SpeedMax) where ID = \(data.ID);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func LoadLive_Parameters_TableID(ID_Team: Int32, ColumnNumber: Int32) -> [Live_Parameters_Table]
    {
        var teams : [Live_Parameters_Table] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM Live_Parameters_Table where ID_Team = \(ID_Team) AND ColumnNumber = \(ColumnNumber);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = Live_Parameters_Table();
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.ColumnNumber = results!.int(forColumn: "ColumnNumber")
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadTotal_Live_Parameters_TableID(ID_Team: Int32, ID_Parameter: Int32) -> [Live_Parameters_Table]
    {
        var teams : [Live_Parameters_Table] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM Live_Parameters_Totals where ID_Team = \(ID_Team) AND ID_Parameter = \(ID_Parameter);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = Live_Parameters_Table();
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.ColumnNumber = results!.int(forColumn: "ColumnNumber")
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadLive_Parameters_Totals(ID_Team: Int32) -> [Live_Parameters_Table]
    {
        var teams : [Live_Parameters_Table] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM Live_Parameters_Totals where ID_Team = \(ID_Team);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = Live_Parameters_Table();
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadLive_Parameters_TableByTeam(ID_Team: Int32) -> [Live_Parameters_Table]
    {
        var teams : [Live_Parameters_Table] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM Live_Parameters_Table where ID_Team = \(ID_Team);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = Live_Parameters_Table();
                curr.ID_Team = results!.int(forColumn: "ID_Team")
                curr.ColumnNumber = results!.int(forColumn: "ColumnNumber")
                curr.ID_Parameter = results!.int(forColumn: "ID_Parameter")
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    
    static func DeleteLive_Parameters_Table(ID_Team: Int32)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            

                let insertSQL = "DELETE FROM Live_Parameters_Table WHERE ID_Team = \(ID_Team);"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }

            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func DeleteLive_Parameters_Totals(ID_Team: Int32)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            
            let insertSQL = "DELETE FROM Live_Parameters_Totals WHERE ID_Team = \(ID_Team);"
            
            
            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            if !result! {
                print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            } else {
                
            }
            
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func SaveLive_Parameters_Table(_ data: Live_Parameters_Table)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadLive_Parameters_TableID(ID_Team: data.ID_Team, ColumnNumber: data.ColumnNumber)
            
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO Live_Parameters_Table ( ID_Team, ColumnNumber, ID_Parameter) VALUES (\(data.ID_Team), \(data.ColumnNumber), \(data.ID_Parameter));"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update Live_Parameters_Table SET ID_Parameter = \(data.ID_Parameter) where ColumnNumber = \(data.ColumnNumber) AND ID_Team = \(data.ID_Team);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func Save_Total_Live_Parameters_Table(_ data: Live_Parameters_Table)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            
            let loaded = LoadTotal_Live_Parameters_TableID(ID_Team: data.ID_Team, ID_Parameter: data.ID_Parameter)
            
            
            if loaded.count == 0
            {
                
                let insertSQL = "INSERT INTO Live_Parameters_Totals ( ID_Team, ID_Parameter) VALUES (\(data.ID_Team), \(data.ID_Parameter));"
                
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            else
            {
                
                let insertSQL = "Update Live_Parameters_Table SET ID_Parameter = \(data.ID_Parameter) where ColumnNumber = \(data.ColumnNumber) AND ID_Team = \(data.ID_Team);"
                
                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {
                    
                }
                
            }
            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func LoadNewLive_DevicesID(ID_Team: Int32, DeviceID: Int32) -> [NewLive_Devices]
    {
        var teams : [NewLive_Devices] = [];

        let contactDB = FMDatabase(path: databasePath)

        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM NewLive_Devices where TeamID = \(ID_Team) AND DeviceID = \(DeviceID);"

            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)

            while (results?.next() == true)
            {
                let curr = NewLive_Devices();
                curr.TeamID = results!.int(forColumn: "TeamID")
                curr.DeviceID = results!.int(forColumn: "DeviceID")

                teams.append(curr)
            }

            contactDB?.close()

            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }
    
    static func LoadNewLive_DevicesByTeam(ID_Team: Int32) -> [NewLive_Devices]
    {
        var teams : [NewLive_Devices] = [];
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
            let querySQL = "SELECT * FROM NewLive_Devices where TeamID = \(ID_Team);"
            
            let results:FMResultSet? = contactDB?.executeQuery(querySQL,
                                                               withArgumentsIn: nil)
            
            while (results?.next() == true)
            {
                let curr = NewLive_Devices();
                curr.TeamID = results!.int(forColumn: "TeamID")
                curr.DeviceID = results!.int(forColumn: "DeviceID")
                
                teams.append(curr)
            }
            
            contactDB?.close()
            
            return teams;
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            return [];
        }
    }

    static func DeleteTeamDevices(teamID: Int32)
    {
        
        let contactDB = FMDatabase(path: databasePath)
        
        if (contactDB?.open())! {
 
            let insertSQL = "DELETE FROM NewLive_Devices where TeamID = \(teamID);"
            
            
            let result = contactDB?.executeUpdate(insertSQL,
                                                  withArgumentsIn: nil)
            if !result! {
                print("Error: \(contactDB?.lastErrorMessage() ?? "")")
            } else {
                
            }

            contactDB?.close()
            
        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
    static func SaveNewLive_Devices(_ data: NewLive_Devices)
    {

        let contactDB = FMDatabase(path: databasePath)

        if (contactDB?.open())! {

            let loaded = LoadNewLive_DevicesID(ID_Team: data.TeamID, DeviceID: data.DeviceID)


            if loaded.count == 0
            {

                let insertSQL = "INSERT INTO NewLive_Devices ( TeamID, DeviceID) VALUES (\(data.TeamID), \(data.DeviceID));"


                let result = contactDB?.executeUpdate(insertSQL,
                                                      withArgumentsIn: nil)
                if !result! {
                    print("Error: \(contactDB?.lastErrorMessage() ?? "")")
                } else {

                }

            }
            else
            {

            }
            contactDB?.close()

        } else {
            print("Error: \(contactDB?.lastErrorMessage() ?? "")")
        }
    }
    
}
