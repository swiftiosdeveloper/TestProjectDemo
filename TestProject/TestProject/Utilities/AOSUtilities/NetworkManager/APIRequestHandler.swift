

import Foundation
import Alamofire
import AlamofireObjectMapper
import CoreLocation
import SVProgressHUD

/// Description : This function is used for defining abstract methods for send request with single or multiple parameter
protocol APIRequesting {
    func sendRequest(_ request: APIRequest, completion: @escaping (_ result: Bool, _ data: showSuccess, _ error: showError) -> Void)
    func sendRequestWithToken(_ req: APIRequest, completion: @escaping (Bool, showSuccess, showError) -> Void)
    
}

/// Description : This function is used for upload the image on the server
protocol UploadImageManager {
    func uploadImage(_ request: APIRequest,image:UIImage,imageKey:String, completion:@escaping (_ sucess:showSuccess ,_ error:showError)->Void)
}

/// Description : This is APIRequestHandler class which is used for call all the api requests and initialize the session
class APIRequestHandler: APIRequesting , UploadImageManager {
    
    /// Description : Defining the session manager with policy and retrier setup
    var manager: Alamofire.Session = {
        let requestRetrier = NetworkRequestRetrier()   // Create a request retrier
        let evaluator = [currentAppModeOn.baseURL.replacingOccurrences(of: "https://", with: "", options: [.caseInsensitive, .regularExpression]) : DisabledEvaluator()]
        //        let serverTrustManager = ServerTrustManager(allHostsMustBeEvaluated: false,evaluators: [ currentAppModeOn.baseURL.replacingOccurrences(of: "https://", with: "", options: [.caseInsensitive, .regularExpression]) : DisabledEvaluator()])
        let serverTrustManager = ServerTrustManager(evaluators: evaluator)
        
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = TimeInterval(120.0)
        configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
        configuration.urlCache = nil
        
        var afManager = Alamofire.Session(
            configuration: configuration,
            startRequestsImmediately: true, serverTrustManager: serverTrustManager
        )
        //        manager.retrier = requestRetrier        // Set the retrier
        return afManager
    }()
    
    
    /// Description : This method is used for send the request with keyvalue pair as parameter
    /// - Parameter request: request
    /// - Parameter completion: completion block after processing request
    func sendRequest(_ request: APIRequest, completion: @escaping (Bool, showSuccess, showError) -> Void) {
        
        if(NetworkStatus.isInternetAvailable())
        {
            DispatchQueue.main.async {
                if(kAppDelegate.isShowProgess){
                    SVProgressHUD.show()
                    SVProgressHUD.setDefaultMaskType(.custom)
                    SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5)) // your custom color
                }
            }
            print("REQUEST URL :- \(request.url)")
            print("REQUEST PARAM :- \(String(describing: request.parameters))")
            print("REQUEST METHOD :- \(String(describing: request.method))")
            
           

            manager.request(request.url,
                            method: request.method,
                            parameters: request.parameters,
                            encoding: JSONEncoding.default,
                            headers: headers()).validate().responseJSON { [weak self] response in
                                guard let weakSelf = self else {
                                    print("Self has been deallocated.")
                                    SVProgressHUD.dismiss()
                                    return
                                }
                                 print("ArrayCount : Request \(request.url)")
                                weakSelf.processResponse(response) { success, data, message in
                                    completion(success, data, message)
                                }
            }
        }else{
            //AN_ADDED
            completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: -999, message: ErrorMessages.Msg.kInternetNotConnectedMsg))
            AlertsManager.sharedInstance.showAlert(message:ErrorMessages.Msg.kInternetNotConnectedMsg)
        }
    }
    
    /// Description : This function will process the response based on network code
    /// - Parameter response: json respose
    /// - Parameter completion: completion block with proper response.
    func processResponse(_ response: AFDataResponse<Any>, completion: @escaping (Bool, showSuccess, showError) -> Void) {
        kAppDelegate.isShowProgess = true
        guard let httpResponse = response.response else {
            if globalAppManager.apiURLArray.count > 0 {
                globalAppManager.apiURLArray.removeLast()
            }
            SVProgressHUD.dismiss()
            AlertsManager.sharedInstance.showAlert(message: response.error?.localizedDescription ?? "")
            completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: -999, message: response.error?.localizedDescription ?? "Error") )
            return
        }
        print("RESPONSE CODE :- \(httpResponse.statusCode)")
        print("RESPONSE URL :- \(httpResponse.url)")
        
        switch httpResponse.statusCode {
        case .success:
            
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                print(json ?? "err")
                completion(true, showSuccess.init(data: json?[APIResponseKey.kData] as Any, message: json?[APIResponseKey.kMessgae] as? String ?? ""),showError.init(code: json?[APIResponseKey.kStatusCode] as? Int ?? 0, message: json?[APIResponseKey.kMessgae] as? String ?? ""))
            }catch
            {
                print("error json parsing")
            }
            
        case .badRequest:
            do{
                let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]
                print(json ?? "")
                let statusCode = json?[APIResponseKey.kStatusCode] as? Int ?? 0
                let Msg = json?[APIResponseKey.kMessgae] as? String ?? ""
                completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: statusCode, message: Msg) )
            }catch
            {
                print("error json parsing")
            }
            globalAppManager.apiURLArray.removeAll()
            SVProgressHUD.dismiss()
            break
            
        case .unAuthorize:
            SVProgressHUD.dismiss()
            globalAppManager.apiURLArray.removeAll()
            kAppDelegate.loginViewModel.refreshToken { (showError) in}
            break
        case .internalServerError:
            globalAppManager.apiURLArray.removeAll()
            SVProgressHUD.dismiss()
            do{
                if let json = try JSONSerialization.jsonObject(with: response.data!, options: []) as? [String:Any]{
                    print(json)
                    let statusCode = json[APIResponseKey.kStatusCode] as? Int ?? 0
                    let Msg = json[APIResponseKey.kMessgae] as? String ?? ""
                    completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: statusCode, message: Msg) )
                }else{
                    completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: httpResponse.statusCode, message:  response.error?.localizedDescription ?? ErrorMessages.Msg.kBadRequestMsg) )
                }
            }catch
            {
                print("error json parsing")
            }
            break
            //            completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: -999, message: response.error?.localizedDescription ?? ErrorMessages.Msg.kBadRequestMsg) )
            //            break
            
            
        default:
            completion(false, showSuccess.init(data: nil, message: ""),showError.init(code: -999, message: response.error?.localizedDescription ?? ErrorMessages.Msg.kBadRequestMsg) )
        }
        if globalAppManager.apiURLArray.count > 0 {
            globalAppManager.apiURLArray.removeLast()
            print("ArrayCount : \(globalAppManager.apiURLArray.count)")
            print("ArrayCount : Response \(httpResponse.url)")
        }
        if globalAppManager.apiURLArray.count == 0{
            DispatchQueue.main.async {
                kAppDelegate.isShowProgess = true
                SVProgressHUD.dismiss()
            }
        }
    }
       
    
    /// Description : This method used for send array of parameneter in the request
    /// - Parameter req: request with array of parameter
    /// - Parameter completion: completion block with proper response
    func sendRequestWithToken(_ req: APIRequest, completion: @escaping (Bool, showSuccess, showError) -> Void){
        if(NetworkStatus.isInternetAvailable()){
            DispatchQueue.main.async {
                if(kAppDelegate.isShowProgess){
                    SVProgressHUD.show()
                    SVProgressHUD.setDefaultMaskType(.clear)
                    SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5)) // your custom color
                }
            }
            
            let url = URL.init(string: req.url)!
            var request = URLRequest(url: url)
            request.httpMethod = req.method.rawValue
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            if let authToken = realmManager.FetchObjects(type: UserModelClass.self)?.first?.jwtToken{
                request.setValue(APIHeaderFeild.TokenBearer + " " + authToken, forHTTPHeaderField: APIHeaderFeild.Authorization)
                print("REQUEST TOKEN :- \(request.allHTTPHeaderFields ?? [:])")
            }
            print("REQUEST URL :- \(req.url)")
            print("REQUEST PARAM :- \(req.parameters ?? [:])")
            
            request.httpBody = req.httpbody
            manager.request(request)
                .responseJSON { [weak self] response in
                    guard let weakSelf = self else {
                        print("Self has been deallocated.")
                        SVProgressHUD.dismiss()
                        return
                    }
                    weakSelf.processResponse(response) { success, data, message in
                        completion(success, data, message)
                    }
            }
        }else{
            AlertsManager.sharedInstance.showAlert(message: ErrorMessages.Msg.kInternetNotConnectedMsg)
        }
    }
    
    
    
    /// Description : This method used for send array of parameneter in the request
    /// - Parameter req: request with array of parameter
    /// - Parameter completion: completion block with proper response
    func sendRequestWithArray(url: URL,method: HTTPMethod, parameter: [Parameters], completion: @escaping (Bool, showSuccess, showError) -> Void)
    {
        if(NetworkStatus.isInternetAvailable()){
            DispatchQueue.main.async {
                if(kAppDelegate.isShowProgess){
                    SVProgressHUD.show()
                    SVProgressHUD.setDefaultMaskType(.custom)
                    SVProgressHUD.setBackgroundLayerColor(UIColor.black.withAlphaComponent(0.5)) // your custom color
                }
            }
            
            manager.request(url, method: method, encoding: JSONArrayEncoding(array: parameter), headers: self.headers()).responseJSON { [weak self] response in
                self?.processResponse(response) { success, data, message in
                    SVProgressHUD.dismiss()
                    completion(success, data, message)
                }
            }
        }else{
            AlertsManager.sharedInstance.showAlert(message: ErrorMessages.Msg.kInternetNotConnectedMsg)
        }
    }
    /// Description : This method is used for generate the header data which passed in headers in request
    func headers() -> HTTPHeaders {
        var headers: HTTPHeaders = [
            APIHeaderFeild.Content: APIHeaderFeild.ContentType ]
        //        if let authToken = UserDefaults.standard.secretObject(forKey: UserDefaultsKey.JWTToken) as? String{
        //            print(authToken)
        //            headers[APIHeaderFeild.Authorization] =  APIHeaderFeild.TokenBearer + " " + authToken
        //        }
        
        if let authToken = realmManager.FetchObjects(type: UserModelClass.self)?.first?.jwtToken{
            print(authToken)
            headers[APIHeaderFeild.Authorization] =  APIHeaderFeild.TokenBearer + " " + authToken
        }
        return headers
    }
    
    func cancelAllRequest() {
        manager.session.getAllTasks { (tasks) in
            tasks.forEach{
                $0.cancel()
            }
        }
    }
}

