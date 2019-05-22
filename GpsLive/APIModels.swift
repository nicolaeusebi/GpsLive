//
//  APIModels.swift
//  GpsLive
//
//  Created by Nicola Eusebi on 24/10/18.
//  Copyright © 2018 Nicola Eusebi. All rights reserved.
//

import Foundation

class SyncModel
{
    var Teams: [TeamInfo] = []
    var Players: [PlayerInfo] = []
    var LiveParams: [Live_Parameters_Table] = []
    var TotalParams: [Live_Parameters_Table] = []
    var Devices: [NewLive_Devices] = []
    var Parameters: [ParameterInfo] = []
    var SessionTypes: [SessionType_DTO] = []
}

class SessionType_DTO
{
    var Team_ID : Int32 = 0
    var SessionTypeId : Int32 = 0
    var SessionName : String = ""
    var training : Bool = false
    var KSSessionTypeKey : Int32? = 0
}

class ParameterInfo
{
    var ID_Parameter : Int32 = 0
    var ID_Team : Int32 = 0
    var Name : String = ""
    var Description : String? = ""
    var MeasureUnit : String? = ""
    var NumberOfDecimals : Int32? = 0
    var ParenthesisNote : String? = ""
    var KSportParam_Key : Int32? = 0
    var ParameterType : String = ""
    var IsUserDefined : Bool = false
    var Formula : String? = nil
}

class PlayerInfo
{
    var ID : Int32 = 0
    var Team_ID : Int32 = 0
    var Number : Int32 = 0
    var NickName : String = ""
    var ImagePath : String? = ""
    var Position : String? = ""
    var IsCurrentSeason : Bool = false
    var HrMax : Int32? = nil
    var HrMin : Int32? = nil
    var SpeedMax : Double? = nil
    
}

class TeamInfo
{
    var Team_ID : Int32 = 0
    var Name : String = ""
    var LiveType : Int32 = 0
    var LiveChannel : Int32 = 0
    var Logo : Int32 = 0
    var SpeedThresholdsPercentage : Bool = false
    
}

class Live_Parameters_Table
{
    var ID_Team : Int32 = 0
    var ColumnNumber : Int32 = 0
    var ID_Parameter : Int32 = 0
    
}

class NewLive_Devices
{
    var TeamID : Int32 = 0
    var DeviceID : Int32 = 0

}

public class SessionData
{
    var idSession : Int32 = 0
    var SessionName : String = ""
    var Team_Id : Int32 = 0
    var Drills: [DrillData] = []
}

public class DrillData
{
    var idDrill : Int32 = 0
    var DrillName : String = ""
    var SessionTypeId : Int32 = 0
    var Training : Bool = false
    var Date : Int32 = 0
    var Hour : Int32 = 0
    var MachineName : String = ""
    var PlayerDatas: [PlayerData_DTO] = []
}

public class PlayerData_DTO
{
    var ID_Player : Int32 = 0
    var ID_Session : Int32 = 0
    var ID_Parameter : Int32 = 0
    var Value : Double = 0
}
