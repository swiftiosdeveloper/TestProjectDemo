
import UIKit

let kAppDelegate = UIApplication.shared.delegate as! AppDelegate

let DefaultFontSize: CGFloat = 17
let DefaultSmallFontSize: CGFloat = 13

let kCommonSDOptions: SDWebImageOptions = [.retryFailed, .allowInvalidSSLCertificates]



// MARK: - DeviceType constant
struct DeviceType {
    static let isIPad = UIDevice.current.userInterfaceIdiom == .pad
}

struct ScreenSize {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
    static let iPhone5Width: CGFloat = 320
    static let iPhoneXHeight: CGFloat = 812
}

//Set to change API host url
#if CEM
let currentAppMode: AppMode = .live // .uat .test
#else
let currentAppMode: AppMode = .uat // .live .test
#endif

// MARK: - API URL Constant
struct Constant {
    struct API {
        static let baseURL = currentAppMode.hostURL
        static let stockURL = ""
        static let reportBaseURL = ""
        static let scanReportURL = Constant.API.reportBaseURL + "/reports/scan"
        static let pdfDownloadReportURL =  Constant.API.reportBaseURL + "/pdf/download"
        static let loginLogReportURL =  Constant.API.reportBaseURL + "/login/log"
        static let japLanguageURL =  Constant.API.reportBaseURL + "/lang/jp"
        static let resource = "/rest/v10"
        static let serverURL = Constant.API.baseURL + Constant.API.resource
        static let oAuthURL = Constant.API.serverURL + "/oauth2/token"
      
    }
}


// MARK: - DateFormat Constant
struct DateFormat {
    let format: String
}

// MARK: - Validation Message Constant
struct ValidationMessage {
    static let kEmptyUserName = "Please enter username"
    static let kEmptyPassword = "Please enter password"
    static let kEmptyFname = "Please enter first name"
    static let kEmptyLname = "Please enter last name"
    static let kEmptyTitle = "Please enter title"
    static let kEmptyDept = "Please enter department"
    static let kEmptyMobile = "Please enter mobile number"
    static let kInvalidEmail = "Please enter valid email"
}

// MARK: - Information Message Constant

struct InfoMessage {
    
    static let kConnectInternet = "Please ensure you have connection to the internet."
    
}

// MARK: - UserDefaultsKey Constant
struct UserDefaultsKey {
    static let kIsLogin = "isLogin"
}

