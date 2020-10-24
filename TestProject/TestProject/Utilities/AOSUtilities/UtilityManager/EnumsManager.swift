//
//  EnumsManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit

// MARK: - Enums
enum AppMode {
    case sit, uat, live, clientUAT
    var baseURL: String {
        switch(self) {
        case .sit:
            return "https://new.comnet.com.sg"
        case .uat:
            return "http://new.comnet.com.sg"
        case .clientUAT:
            return "https://utaosapp1v.rws-dev.rwsentosa.com"
        case .live:
            return "" 
        }
    }
    var subURL: String {
        switch(self) {
        case .sit:
            return "/aos_api"
        case .uat:
            return "/AOS_UAT_API"
        case .clientUAT:
            return "/api"
        case .live:
            return ""
        }
    }
    var APIVersion: String {
        switch(self) {
        case .sit:
            return "/API/1.0/"
        case .uat:
            return "/Api"
        case .clientUAT:
            return ""
        case .live:
            return ""
        }
    }
    var signalBaseURl: String {
        switch(self) {
        case .sit:
            return "https://aos-sit.comnet.com.sg/aosHub"
        case .uat:
            return "http://aos-uat.comnet.com.sg/aosHub"
        case .clientUAT:
            return "https://utaosapp1v.rws-dev.rwsentosa.com/aosHub"
        case .live:
            return ""
        }
    }
    var server: String {
        switch(self) {
        case .live: return "Prod"
        default: return "SIT"
        }
    }
}
/// Description : This enum is used to manage view type.
enum VCType : String {
    case operatingInfoVC = "OperatingInfoVC"
    case downTimeVC = "DownTimeVC"
    case waitTimeVC = "WaitTimeVC"
    case countDetailsVC = "CountDetailsVC"
    case none = ""
}

/// Description : This enum is used to manage SignalR modes.
enum SignalMode:String {
    case insert = "Insert", edit = "Edit", delete = "Delete", deletewithupdate = "Delete_With_Update", end = "End", start = "Start", none = ""
}

/// Description : This enum is used to manage active downtimwe summary details.
enum ActivateDownTimeSummary {
    case header
    case downTime(list:DownTimeClass)
    case nodata
}

/// Description : This enum is used to manage downtimwe entry logs.
enum DownTimeEntryLog {
    case headerDownTime(list:DownTimeClass)
    case detailsDownTime(list:DownTimeClass)
}

/// Description : This enum is used to manage downtimwe end.
enum EndDownTimeSummary {
   case header
      case downTime(list:EndDownTimeSummaryDataClass)
      case nodata
}

/// Description : This enum is used to manage wait time  end.
enum WaitTimeListSection {
    case header
    case waitTime(list:WaitTimeClass)
    case nodata
}

/// Description : This enum is used to manage in operabale seat control list selection.
enum InOperableSeatListSection {
    case header
    case inOperableSeat(list:InOpSeatsClass)
    case nodata
}

/// Description : This enum is used to manage in operabale seat control list selection.
enum FalultListSection {
    case header
    case fault(list:FaultDescriptionClass)
    case nodata
}

/// Description : This enum is used to manage in RV control list selection.
enum RvsPopUpSection {
    case header
    case rv(rvs:RideVehicle)
}

/// Description : This enum is used to manage in VTU  control list selection.
enum VtuPopUpSection {
    case header
    case vtu(vtu:VtuClass)
}

/// Description : This enum is used to manage in LANE control list selection.
enum LanePopUpSection {
    case header
    case lane(lane:LaneClass)
}

/// Description : This enum is used to manage in popupl list.
enum SelectedPopUpList:String {
    case addrvs = "AddRvs"
    case addvtu = "AddVtu"
    case addlane = "AddLan"
    case gwdrvnos = "GwdRvNos"
    case rvnos = "RvNos"
    case sparervnos = "SpareRvNos"
    case offlinervnos = "OfflineRvNos"
    case vtu = "Vtu"
    case sparevtunos = "SpareVtuNos"
    case offlinevtunos = "OfflineVtuNos"
    case lane = "Lane"
    case sparelanenos = "SpareLaneNos"
    case offlinelanenos = "OfflineLaneNos"
    case none = ""
}

/// Description : This function is used for manage diffrent types of enum
enum VerticalLocation: String {
    case bottom
    case top
}

/// Description : error struct with construct of statuscode and error message
struct showError {
    var code: Int
    var message: String
}

/// Description : success struct with construct of data and error message
struct showSuccess {
    var data: Any?
    var message: String
}


/// Description : Validation struct with boolean and message information
struct validateResp {
    var isValidated: Bool
    var message: String
}

/// Description : This function is used for manage diffrent types of enum
enum SigalRTarget : String {
    case TARGET_SIGNAL_ReceiveRideCount
    case TARGET_SIGNAL_ReceiveWaitTime
    case TARGET_SIGNAL_ReceiveTechTime
    case TARGET_SIGNAL_ReceiveRideOperation
    case TARGET_SIGNAL_ReceiveDownTime
    case TARGET_SIGNAL_ReceiveAttractionPermission
    case TARGET_SIGNAL_ReceiveDownTechTime
    case TARGET_SIGNAL_ReceiveSummaryRideCount
    case TARGET_SIGNAL_ReceiveParkInterval
    case TARGET_SIGNAL_ReceiveTechTimeInterval
    case TARGET_SIGNAL_ReceiveDashboardSetting


    var value : String {
        switch self {
        case .TARGET_SIGNAL_ReceiveRideCount:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveRideCount
        case .TARGET_SIGNAL_ReceiveWaitTime:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveWaitTime
        case .TARGET_SIGNAL_ReceiveTechTime:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveTechTime
        case .TARGET_SIGNAL_ReceiveRideOperation:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveRideOperation
        case .TARGET_SIGNAL_ReceiveDownTime:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveDownTime
        case .TARGET_SIGNAL_ReceiveAttractionPermission:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveAttractionPermission
        case .TARGET_SIGNAL_ReceiveDownTechTime:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveDownTechTime
        case .TARGET_SIGNAL_ReceiveSummaryRideCount:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveSummaryRideCount
        case .TARGET_SIGNAL_ReceiveParkInterval:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveParkInterval
        case .TARGET_SIGNAL_ReceiveTechTimeInterval:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveTechTimeInterval
        case .TARGET_SIGNAL_ReceiveDashboardSetting:
            return GlobalAppConstant.TYPE_SIGNAL_ReceiveDashboardSetting
        }
    }
}

enum RideControlType {
    case RIDE_CONTROL_TYPE_TEXTBOX, RIDE_CONTROL_TYPE_RADIOBUTTON, RIDE_CONTROL_TYPE_CHECKBOX, RIDE_CONTROL_TYPE_DROPDOWN, RIDE_CONTROL_TYPE_RVNO, RIDE_CONTROL_TYPE_EMAIL, RIDE_CONTROL_TYPE_NUMBERS, RIDE_CONTROL_TYPE_TEXTAREA, RIDE_CONTROL_TYPE_INOPERATABLE_SEAT, RIDE_CONTROL_TYPE_DATE, RIDE_CONTROL_TYPE_TIME, RIDE_OPERATING_CONTROL_TYPE_RVNO_LIST, RIDE_OPERATING_CONTROL_TYPE_VTU_LIST, RIDE_DOWNTIME_CONTROL_TYPE_FAULT_DESCRIPTION_LIST, RIDE_OPERATING_CONTROL_TYPE_USER_LIST, RIDE_OPERATING_CONTROL_TYPE_LANE_LIST, RIDE_OPERATING_CONTROL_TYPE_DISPATCH_INTERVAL
    var type: Int {
        switch self {
        case .RIDE_CONTROL_TYPE_TEXTBOX:
            return 1
        case .RIDE_CONTROL_TYPE_RADIOBUTTON:
            return 2
        case .RIDE_CONTROL_TYPE_CHECKBOX:
            return 3
        case .RIDE_CONTROL_TYPE_DROPDOWN:
            return 4
        case .RIDE_CONTROL_TYPE_RVNO:
            return 5
        case .RIDE_CONTROL_TYPE_EMAIL:
            return 6
        case .RIDE_CONTROL_TYPE_NUMBERS:
            return 7
        case .RIDE_CONTROL_TYPE_TEXTAREA:
            return 8
        case .RIDE_CONTROL_TYPE_INOPERATABLE_SEAT:
            return 9
        case .RIDE_CONTROL_TYPE_DATE:
            return 10
        case .RIDE_CONTROL_TYPE_TIME:
            return 11
        case .RIDE_OPERATING_CONTROL_TYPE_RVNO_LIST:
            return 12
        case .RIDE_OPERATING_CONTROL_TYPE_VTU_LIST:
            return 13
        case .RIDE_DOWNTIME_CONTROL_TYPE_FAULT_DESCRIPTION_LIST:
            return 14
        case .RIDE_OPERATING_CONTROL_TYPE_USER_LIST:
            return 15
        case .RIDE_OPERATING_CONTROL_TYPE_LANE_LIST:
            return 16
        case .RIDE_OPERATING_CONTROL_TYPE_DISPATCH_INTERVAL:
            return 17
        }
    }
}

enum SwipeActionDescriptor {
    case view,edit,techtime,editText,deleteText,editOpSeat
    var properties: (title: String, image: UIImage?, color: UIColor) {
        switch self {
        case .view: return (title: "View", image: UIImage(named: ""), color: .colorLightCellBG)
        case .edit: return (title: "", image: UIImage(named: "ic_edit"), color: .colorCellBG)
        case .techtime: return (title: "", image: UIImage(named: "ic_techtimeclock"), color: .colorCellBG)
        case .editText: return (title: "EDIT", image: UIImage(named: ""), color: .colorCellEdit)
        case .deleteText: return (title: "DELETE", image: UIImage(named: ""), color: .colorRed)
        case .editOpSeat: return (title: "EDIT", image: UIImage(named: ""), color: .colorCellEdit)
        }
    }
}

/// Description : Enum define for ImageType
enum ImageMimeType {
    case PNG, JPEG, JPG, GIF, VIDEO, Unknown, TIFF
    var type: String{
        switch self {
        case .PNG:
            return "image/png"
        case .JPEG:
            return "image/jpeg"
        case .JPG:
            return "image/jpg"
        case .GIF:
            return "image/gif"
        case .VIDEO:
            return "image/video"
        case .Unknown:
            return ""
        case .TIFF:
            return "image/tiff"
        }
    }
    var fileName: String {
        switch self {
        case .PNG:
            return "image.png"
        case .JPEG:
            return "image.jpeg"
        case .JPG:
            return "image.jpg"
        case .GIF:
            return "image.gif"
        case .VIDEO:
            return "image.mp4"
        case .Unknown:
            return ""
        case .TIFF:
            return "image.tiff"
        }
    }
}

public enum Model: String {
    //Simulator
    case simulator     = "simulator/sandbox",
    //iPod
    iPod1              = "iPod 1",
    iPod2              = "iPod 2",
    iPod3              = "iPod 3",
    iPod4              = "iPod 4",
    iPod5              = "iPod 5",
    
    //iPad
    iPad2              = "iPad 2",
    iPad3              = "iPad 3",
    iPad4              = "iPad 4",
    iPadAir            = "iPad Air ",
    iPadAir2           = "iPad Air 2",
    iPadAir3           = "iPad Air 3",
    iPad5              = "iPad 5", //iPad 2017
    iPad6              = "iPad 6", //iPad 2018
    iPad7              = "iPad 7", //iPad 2019
    //iPad Mini
    iPadMini           = "iPad Mini",
    iPadMini2          = "iPad Mini 2",
    iPadMini3          = "iPad Mini 3",
    iPadMini4          = "iPad Mini 4",
    iPadMini5          = "iPad Mini 5",
    
    //iPad Pro
    iPadPro9_7         = "iPad Pro 9.7\"",
    iPadPro10_5        = "iPad Pro 10.5\"",
    iPadPro11          = "iPad Pro 11\"",
    iPadPro12_9        = "iPad Pro 12.9\"",
    iPadPro2_12_9      = "iPad Pro 2 12.9\"",
    iPadPro3_12_9      = "iPad Pro 3 12.9\"",
    //iPhone
    iPhone4            = "iPhone 4",
    iPhone4S           = "iPhone 4S",
    iPhone5            = "iPhone 5",
    iPhone5S           = "iPhone 5S",
    iPhone5C           = "iPhone 5C",
    iPhone6            = "iPhone 6",
    iPhone6Plus        = "iPhone 6 Plus",
    iPhone6S           = "iPhone 6S",
    iPhone6SPlus       = "iPhone 6S Plus",
    iPhoneSE           = "iPhone SE",
    iPhone7            = "iPhone 7",
    iPhone7Plus        = "iPhone 7 Plus",
    iPhone8            = "iPhone 8",
    iPhone8Plus        = "iPhone 8 Plus",
    iPhoneX            = "iPhone X",
    iPhoneXS           = "iPhone XS",
    iPhoneXSMax        = "iPhone XS Max",
    iPhoneXR           = "iPhone XR",
    iPhone11           = "iPhone 11",
    iPhone11Pro        = "iPhone 11 Pro",
    iPhone11ProMax     = "iPhone 11 Pro Max",
    //Apple TV
    AppleTV            = "Apple TV",
    AppleTV_4K         = "Apple TV 4K",
    unrecognized       = "?unrecognized?"
}
