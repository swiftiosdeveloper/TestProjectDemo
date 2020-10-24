import Foundation
import Alamofire
import SystemConfiguration

/// Custom API call class
class NetworkUtilities: NSObject {
    /// Share instance
    static let shared = NetworkUtilities()
    let reachablity = NetworkReachabilityManager()
    //    var AFManager = Alamofire.Session.default
    var bgTask: UIBackgroundTaskIdentifier?
    static let AFManager: Session = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = TimeInterval(120.0)
//        configuration.timeoutIntervalForResource = TimeInterval(120.0)
        config.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        config.urlCache = nil
        let delegate = Session.default.delegate
        let manager = Session.init(configuration: config,
                                   delegate: delegate,
                                   startRequestsImmediately: true,
                                   cachedResponseHandler: nil)
        // let trustmanager = ServerTrustManager(evaluators: ["stamaapp1v.rws-dev.rwsentosa.com": DisabledEvaluator()])
        //ServerTrustManager(allHostsMustBeEvaluated: false,
//                            evaluators: ["stamaapp1v.rws-dev.rwsentosa.com": DisabledEvaluator()])
        //ServerTrustManager(evaluators: ["stamaapp1v.rws-dev.rwsentosa.com": DisabledEvaluator()])
        //let manager = Session(configuration: configuration,
//        delegate: SessionDelegate(),
//        startRequestsImmediately: true,
//        serverTrustManager: trustmanager)
        return manager
    }()
    var isConnectedToInternet: Bool {
        if let isNetworkReachable = self.reachablity?.isReachable,
            isNetworkReachable == true {
            return true
        } else {
            return false
        }
    }
    /// class init method
    override init() {
        super.init()
        DispatchQueue.main.async {
            UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(120.0))
        }
        self.reachablity?.startListening(onUpdatePerforming: {networkStatusListener in
            print("Network Status Changed:", networkStatusListener)
            switch networkStatusListener {
            case .notReachable:
                print("The network is not reachable.")
            case .unknown :
                print("It is unknown whether the network is reachable.")
            case .reachable(.ethernetOrWiFi):
                print("The network is reachable over the WiFi connection")
            case .reachable(.cellular):
                print("The network is reachable over the WWAN connection")
            }
        })
    }
    /// API call
    ///
    /// - Parameters:
    ///   - url: URL
    ///   - method: API cal Methos (GET,POST,PUT)
    ///   - parameter: parameter values
    ///   - success: success data response
    ///   - failure: failure data response
    func makeAPIRequest(withURL url: String,
                        method: HTTPMethod,
                        parameter: [String: Any]?,
                        success: @escaping (Any) -> Void,
                        failure: @escaping (String) -> Void) {
        debugPrint(method.rawValue, url)
        guard isConnectedToInternet else {
            failure(ConstantAlertMessages.NOINTERNET)
            return
        }
        var headers: HTTPHeaders = ["Content-type": "application/json"]
        if !Utility.getDeviceToken().isEmpty {
            headers["Authorization"] = Utility.getDeviceToken()
        }
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        if let data = parameter?.jsonData, let paramStr = String(data: data, encoding: .utf8) {
            if USSRWS.shared.printRequest {
                print("Request:", paramStr)
            } else {
                USSRWS.shared.printRequest = true
            }
        }
        bgTask = UIApplication.shared.beginBackgroundTask {
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        }
        let dataTask = NetworkUtilities.AFManager.request(url,
                                                          method: method,
                                                          parameters: parameter,
                                                          encoding: encoding,
                                                          headers: headers)
        dataTask.validate(statusCode: 200..<300).responseJSON { response in
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            self.sendResponse(response: response, method: method, success: { value in
                success(value)
            }, failure: { error in
                failure(error)
            })
        }
    }
    func sendResponse(response: AFDataResponse<Any>,
                      method: HTTPMethod,
                      success: @escaping (Any) -> Void,
                      failure: @escaping (String) -> Void) {
        let jsonData = response.data
        if USSRWS.shared.printResponse {
            USSRWS.shared.printResponse = false
            print("Status Code:", response.response?.statusCode ?? 0)
            if let data = jsonData, let paramStr = String(data: data, encoding: .utf8) {
                print("Response:", paramStr)
            }
        }
        guard let httpResponse = response.response else {
            failure(ConstantAlertMessages.NORESPONSEFROMSERVER)
            return
        }
        switch httpResponse.statusCode {
        case .success:
            switch response.result {
            case .success(let value):
                self.caseSuccessResponse(value: value, method: method, success: { res in
                    success(res)
                }, failure: { error in
                    failure(error)
                })
            case .failure(let error):
                print("FAILURE : \(error)")
                self.caseFailureResponse(error: error as NSError) { (error) in
                    failure(error)
                }
            }
            debugPrint("")
        case .badRequest:
            failure(ConstantAlertMessages.NORESPONSEFROMSERVER)
        case .unAuthorize:
            failure(ConstantAlertMessages.ERRORNULL)
        case .internalServerError:
            failure(ConstantAlertMessages.ERRORNULL)
        default:
            UIApplication.shared.keyWindow?.rootViewController?.hideLoader()
            failure(ConstantAlertMessages.NORESPONSEFROMSERVER)
        }
    }
    func caseSuccessResponse(value: Any,
                             method: HTTPMethod,
                             success: @escaping (Any) -> Void,
                             failure: @escaping (String) -> Void) {
        if method == HTTPMethod.put {
            success(value)
        } else {
            let dic = value as? [String: Any] ?? [:]
            let resultArray = dic["Result"] as? [[String: Any]] ?? []
            let resultDic = dic["Result"] as? [String: Any] ?? [:]
            if let statusCode = (dic["StatusCode"] as? Int) {
                if statusCode == 200 {
                    if resultArray.isEmpty && resultDic.isEmpty {
                        UIApplication.shared.keyWindow?.rootViewController?.hideLoader()
                        success([:])
                    } else {
                        success(value)
                    }
                } else if statusCode == 404 {
                    failure(ConstantAlertMessages.NORESPONSEFROMSERVER)
                } else {
                    failure(ConstantAlertMessages.ERRORNULL)
                }
            } else {
                failure(ConstantAlertMessages.ERRORNULL)
            }
        }
    }
    func caseFailureResponse(error: NSError, failure: @escaping (String) -> Void) {
        if (error as NSError).code == NSURLErrorTimedOut {
            //Timeout Error
            UIApplication.shared.keyWindow?.rootViewController?.hideLoader()
            failure(ConstantAlertMessages.NORESPONSEFROMSERVER)
        } else {
            //Connection Error
            UIApplication.shared.keyWindow?.rootViewController?.hideLoader()
        }
    }
}
