

import SystemConfiguration
import Alamofire

class APIManager: NSObject {
    
    static let sharedInstance = APIManager()
    
    let manager: SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = nil
        configuration.requestCachePolicy = .reloadIgnoringCacheData
        configuration.timeoutIntervalForRequest = 120
        let serverTrustPolicies: [String: ServerTrustPolicy] = [
            "test.com": .disableEvaluation,
            "test.com": .disableEvaluation
        ]
        return SessionManager(configuration: configuration, delegate: SessionDelegate(), serverTrustPolicyManager: ServerTrustPolicyManager(policies: serverTrustPolicies))
    }()
    
    var bgTask: UIBackgroundTaskIdentifier?

    func isConnectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in(sin_len: 0, sin_family: 0, sin_port: 0, sin_addr: in_addr(s_addr: 0), sin_zero: (0, 0, 0, 0, 0, 0, 0, 0))
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        
        return (isReachable && !needsConnection)
    }
    
    func makeAPIRequest(withURL url: String, method: HTTPMethod, parameters: [String:Any]?, setUserPrefHeader: Bool = true, completionHandler: @escaping (Swift.Result<Any, NetworkError>) -> Void) {
        print(method.rawValue, url)
        guard isConnectedToNetwork() else {
            completionHandler(.failure(NetworkError.noInternet))
            return
        }
        var headers = [kContentType:"application/json"]
        if let oauthUser = ThgCEM.shared.currentUser {
            headers[kOAuthToken] = oauthUser.accessToken
            if setUserPrefHeader {
                headers[kXUserprefHash] = ThgCEM.shared.userPrefHash
            }
        }
        if url.contains(Constant.API.reportBaseURL) { headers[kOAuthToken] = OAuthSecret.reportsOAuthToken }
        /*var urlRequest = URLRequest(url: URL(string: url)!)
        urlRequest.allHTTPHeaderFields = headers
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = .reloadIgnoringCacheData
        urlRequest.httpBody = parameter?.jsonData
        let dataTask = Alamofire.request(urlRequest)*/
        let encoding: ParameterEncoding = method == .get ? CustomGetEncoding() : JSONEncoding.default
        
        if let data = parameters?.jsonData, let paramStr = String(data: data, encoding: .utf8) {
            if ThgCEM.shared.printRequest {
                print("Request:", paramStr)
            }
            else {
                ThgCEM.shared.printRequest = true
            }
        }
        if !url.hasSuffix(Constant.API.filterRecordCountURL) {
            bgTask = UIApplication.shared.beginBackgroundTask {
                if let task = self.bgTask {
                    UIApplication.shared.endBackgroundTask(task)
                }
                self.bgTask = UIBackgroundTaskIdentifier.invalid
            }
        }
        
        let dataTask = manager.request(url, method: method, parameters: parameters, encoding:  encoding, headers: headers)
        /*URLCache.shared.getCachedResponse(for: dataTask.task as! URLSessionDataTask) { (cachedURLResponse) in
            if let cachedURLResponse = cachedURLResponse, let response = try? JSONSerialization.jsonObject(with: cachedURLResponse.data) {
                success(response)
                return
            }
        }*/
        dataTask.validate(statusCode: 200..<300).responseJSON { response in
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            let jsonData = response.data
            let code = response.response?.statusCode ?? 0
            if ThgCEM.shared.printResponse {
                ThgCEM.shared.printResponse = false
                print("Status Code:", code)
                if let data = jsonData, let paramStr = String(data: data, encoding: .utf8) {
                    print("Response:", paramStr)
                }
            }
            switch response.result {
            case .success(let value):                
                /*let cachedURLResponse = CachedURLResponse(response: response.response!, data: response.data!, userInfo: nil, storagePolicy: .allowed)
                URLCache.shared.storeCachedResponse(cachedURLResponse, for: dataTask.task as! URLSessionDataTask)*/
                completionHandler(.success(value))
            case .failure(let error):
                //self.storeFailedRequest(url: url, method: method, response: response)
                if (400...499) ~= code, let dic = jsonData?.jsonResponse as? [String:Any], let error = dic[kError] as? String, let message = dic[kErrorMessage] as? String {
                    if !ThgCEM.shared.isLoginForStock, let user = ThgCEM.shared.currentUser {
                        if let userHash = dic[kUserHash] as? String, userHash != ThgCEM.shared.userPrefHash {
                            kAppDelegate.getCurrentUserDetails(completion: {
                                self.makeAPIRequest(withURL: url, method: method, parameters: parameters, setUserPrefHeader: setUserPrefHeader, completionHandler: completionHandler)
                            })
                        }
                        else if code == 400 || error == "need_login" {
                            kAppDelegate.showLoginScreen()
                        }
                        else if code == 401 {
                            if user.refreshExpiresIn > Date() {
                                kAppDelegate.getAccessTokenAndMakeAPICall(url: url, method: method, parameters: parameters, setUserPrefHeader: setUserPrefHeader, completionHandler: completionHandler)
                            }
                            else {
                                kAppDelegate.showLoginScreen()
                            }
                        }
                        else {
                            completionHandler(.failure(.error(message: message)))
                        }
                    }
                    else {                        
                        completionHandler(.failure(.error(message: message)))
                    }
                }
                /*else if error._code == NSURLErrorTimedOut {
                    self.makeAPIRequest(withURL: url, method: method, parameters: parameters, success: success, failure: failure)
                }*/
                else {
                    var errorDesc = error.localizedDescription
                    if errorDesc == "cancelled" { errorDesc = "" }
                    completionHandler(.failure(.error(message: code == 500 ? "Internal Server Error" : errorDesc)))
                }
            }
        }
    }
    
    func makeUploadRequest(withURL url: String, method: HTTPMethod, parameter: [String:Any], completionHandler: @escaping (Swift.Result<Any, NetworkError>) -> Void) {
        print(method.rawValue, url)
        guard isConnectedToNetwork() else {
            completionHandler(.failure(NetworkError.noInternet))
            return
        }
        var headers = [kContentType:"multipart/form-data"]
        if let oauthUser = ThgCEM.shared.currentUser {
            headers[kOAuthToken] = oauthUser.accessToken
        }
        bgTask = UIApplication.shared.beginBackgroundTask {
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        }
        manager.upload(multipartFormData: { (formData) in
            let fileData = parameter[kFileData] as! Data
            let fieldName = parameter[kFieldName] as! String
            let fileName = parameter[kSelectedFileName] as! String
            let mimeType = parameter[kMIMEType] as! String
            formData.append(fileData, withName: fieldName, fileName: fileName, mimeType: mimeType)
        }, to: url, method: method, headers: headers, encodingCompletion: { (result) in
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            switch(result) {
            case .success(let uploadRequest, _, _):
                uploadRequest.validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        completionHandler(.success(value))
                    case .failure(let error):
                        let code = response.response?.statusCode ?? 0
                        if (400...499) ~= code, let dic = response.data?.jsonResponse as? [String:Any], let error = dic[kError] as? String, let message = dic[kErrorMessage] as? String {
                            if let user = ThgCEM.shared.currentUser {
                                if code == 400 || error == "need_login" {
                                    kAppDelegate.showLoginScreen()
                                }
                                else if code == 401 {
                                    if user.refreshExpiresIn > Date() {
                                        kAppDelegate.getAccessTokenAndMakeAPICall(url: url, method: method, parameters: parameter, isUploadRequest: true, completionHandler: completionHandler)
                                    }
                                    else {
                                        kAppDelegate.showLoginScreen()
                                    }
                                }
                                else {
                                    completionHandler(.failure(.error(message: message)))
                                }
                            }
                            else {
                                completionHandler(.failure(.error(message: message)))
                            }
                        }
                        else {
                            completionHandler(.failure(.error(message: error.localizedDescription)))
                        }
                    }
                })
            case .failure(let error):
                completionHandler(.failure(.error(message: error.localizedDescription)))
            }
        })
    }
    
    func makeMultipartFormUploadRequest(withURL url: String, method: HTTPMethod, parameters: [String:Any], completionHandler: @escaping (Swift.Result<Any, NetworkError>) -> Void) {
        print(method.rawValue, url)
        guard isConnectedToNetwork() else {
            completionHandler(.failure(NetworkError.noInternet))
            return
        }
        var headers = [kContentType:"multipart/form-data"]
        if let oauthUser = ThgCEM.shared.currentUser {
            headers[kOAuthToken] = oauthUser.accessToken
        }
        bgTask = UIApplication.shared.beginBackgroundTask {
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        }
        manager.upload(multipartFormData: { (formData) in
            for (key, value) in parameters {
                let anyObject = value as AnyObject
                if let image = value as? UIImage {
                    let pngData = image.pngData()
                    let jpegData = image.jpegData(compressionQuality: 0.9)
                    guard pngData != nil || jpegData != nil else { continue }
                    let filename = Date().timeStampString + ".png"
                    formData.append(jpegData ?? pngData!, withName: key, fileName: filename, mimeType: "image/png")
                }
                else if let data = anyObject.data(using: String.Encoding.utf8.rawValue) {
                    formData.append(data, withName: key)
                }
            }
        }, to: url, method: method, headers: headers, encodingCompletion: { (result) in
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            switch(result) {
            case .success(let uploadRequest, _, _):
                uploadRequest.validate(statusCode: 200..<300).responseJSON(completionHandler: { response in
                    let jsonData = response.data
                    if ThgCEM.shared.printResponse {
                        ThgCEM.shared.printResponse = false
                        print("Status Code:", response.response?.statusCode ?? 0)
                        if let data = jsonData, let paramStr = String(data: data, encoding: .utf8) {
                            print("Response:", paramStr)
                        }
                    }
                    switch response.result {
                    case .success(let value):
                        completionHandler(.success(value))
                    case .failure(let error):
                        let code = response.response?.statusCode ?? 0
                        if (400...499) ~= code, let dic = jsonData?.jsonResponse as? [String:Any], let error = dic[kError] as? String, let message = dic[kErrorMessage] as? String {
                            if let user = ThgCEM.shared.currentUser {
                                if code == 400 || error == "need_login" {
                                    kAppDelegate.showLoginScreen()
                                }
                                else if code == 401 {
                                    if user.refreshExpiresIn > Date() {
                                        kAppDelegate.getAccessTokenAndMakeAPICall(url: url, method: method, parameters: parameters, isMultipartRequest: true, completionHandler: completionHandler)
                                    }
                                    else {
                                        kAppDelegate.showLoginScreen()
                                    }
                                }
                                else {
                                    completionHandler(.failure(.error(message: message)))
                                }
                            }
                            else {
                                completionHandler(.failure(.error(message: message)))
                            }
                        }
                        else {
                            completionHandler(.failure(.error(message: error.localizedDescription)))
                        }
                    }
                })
            case .failure(let error):
                completionHandler(.failure(.error(message: error.localizedDescription)))
            }
        })
    }
    
    func makeDownloadRequest(withURL url: String, method: HTTPMethod, parameter: [String:Any], pdfFileName: String = "", completionHandler: @escaping (Swift.Result<Any, NetworkError>) -> Void) {
        print(method.rawValue, url)
        guard isConnectedToNetwork() else {
            completionHandler(.failure(NetworkError.noInternet))
            return
        }
        var fileName = pdfFileName
        var mimeType = "application/pdf"
        if pdfFileName.isEmpty {
            fileName = parameter[kSelectedFileName] as! String
            mimeType = parameter[kMIMEType] as! String
        }
        var headers = [String:String]()
        if !mimeType.isEmpty {
            headers[kContentType] = mimeType
        }
        if let oauthUser = ThgCEM.shared.currentUser {
            headers[kOAuthToken] = oauthUser.accessToken
        }
        let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            let documentsURL = FileManager.documentDirectoryURL.appendingPathComponent(fileName)
            return (documentsURL, [.removePreviousFile])
        }
        bgTask = UIApplication.shared.beginBackgroundTask {
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
        }
        let params: [String:Any]? = !pdfFileName.isEmpty ? parameter : nil
        print(params ?? "nil")
        let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
        manager.download(url, method: method, parameters: params, encoding: encoding, headers: headers, to: destination).downloadProgress(queue: DispatchQueue.global(qos: .utility)) { (progress) in
            DispatchQueue.main.async {
                let status = progress.fractionCompleted >= 1.0 ? "Please wait..." : "Downloading..."
                SVProgressHUD.showProgress(Float(progress.fractionCompleted), status: status)
            }
        }.validate(statusCode: 200..<300).responseData { response in
            if let task = self.bgTask {
                UIApplication.shared.endBackgroundTask(task)
            }
            self.bgTask = UIBackgroundTaskIdentifier.invalid
            switch response.result {
            case .success(_):
                if let destinationUrl = response.destinationURL {
                    completionHandler(.success(destinationUrl))
                }
            case .failure(let error):
                let code = response.response?.statusCode ?? 0
                if (400...499) ~= code, let dic = response.resumeData?.jsonResponse as? [String:Any], let error = dic[kError] as? String, let message = dic[kErrorMessage] as? String {
                    if let user = ThgCEM.shared.currentUser {
                        if code == 400 || error == "need_login" {
                            kAppDelegate.showLoginScreen()
                        }
                        else if code == 401 {
                            if user.refreshExpiresIn > Date() {
                                kAppDelegate.getAccessTokenAndMakeAPICall(url: url, method: method, parameters: parameter, isDownloadRequest: true, pdfFileName: pdfFileName, completionHandler: completionHandler)
                            }
                            else {
                                kAppDelegate.showLoginScreen()
                            }
                        }
                        else {
                            completionHandler(.failure(.error(message: message)))
                        }
                    }
                    else {
                        completionHandler(.failure(.error(message: message)))
                    }
                }
                else {
                    completionHandler(.failure(.error(message: error.localizedDescription)))
                }
            }
        }
    }
    
    func storeFailedRequest(url: String, method: HTTPMethod, response: DataResponse<Any>) {
        var string = method.rawValue + " " + url + "\n\n"
        if method == .get {
            let urlComponents = URLComponents(string: response.request?.url?.absoluteString ?? "")
            let items = urlComponents?.queryItems ?? []
            var dic = [String:Any]()
            items.forEach { dic[$0.name] = $0.value ?? "" }
            if let data = dic.jsonData, let str = String(data: data, encoding: .utf8) {
                string += "Request" + "\n\n" + str + "\n\n"
            }
        }
        else if let data = response.request?.httpBody, let str = String(data: data, encoding: .utf8) {
            string += "Request" + "\n\n" + str + "\n\n"
        }
        let code = String(response.response?.statusCode ?? 0)
        string += "Response Status Code " + code + "\n\n"
        if let data = response.data, let str = String(data: data, encoding: .utf8) {
            string += "Response" + "\n\n" + str + "\n\n"
        }
        string.data(using: .utf8)?.storeRequestInDocumentDirectory()
    }
    
    func cancelAllRequest(for path: String = Constant.API.searchURL) {
        guard let url = URL(string: path) else { return }
        manager.session.getAllTasks { (tasks) in
            tasks.forEach{
                if $0.originalRequest?.url?.lastPathComponent == url.lastPathComponent {
                    $0.cancel()
                }
            }
        }
    }
}

struct CustomGetEncoding: ParameterEncoding {
    
    public enum Destination {
        case methodDependent, queryString, httpBody
    }
    
    public enum ArrayEncoding {
        case brackets, noBrackets
        
        func encode(key: String, index:Int) -> String {
            switch self {
            case .brackets:
                return "\(key)[\(index)]"
            case .noBrackets:
                return key
            }
        }
    }

    public enum BoolEncoding {
        case numeric, literal
        
        func encode(value: Bool) -> String {
            switch self {
            case .numeric:
                return value ? "1" : "0"
            case .literal:
                return value ? "true" : "false"
            }
        }
    }
    
    public static var `default`: URLEncoding { return URLEncoding() }
    
    public static var methodDependent: URLEncoding { return URLEncoding() }
    
    public static var queryString: URLEncoding { return URLEncoding(destination: .queryString) }
    
    public static var httpBody: URLEncoding { return URLEncoding(destination: .httpBody) }
    
    public let destination: Destination
    
    public let arrayEncoding: ArrayEncoding
    
    public let boolEncoding: BoolEncoding
    
    public init(destination: Destination = .methodDependent, arrayEncoding: ArrayEncoding = .brackets, boolEncoding: BoolEncoding = .numeric) {
        self.destination = destination
        self.arrayEncoding = arrayEncoding
        self.boolEncoding = boolEncoding
    }
    
    public func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()
        
        guard let parameters = parameters else { return urlRequest }
        
        if let method = HTTPMethod(rawValue: urlRequest.httpMethod ?? "GET"), encodesParametersInURL(with: method) {
            guard let url = urlRequest.url else {
                throw AFError.parameterEncodingFailed(reason: .missingURL)
            }
            
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
        } else {
            if urlRequest.value(forHTTPHeaderField: kContentType) == nil {
                urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: kContentType)
            }
            
            urlRequest.httpBody = query(parameters).data(using: .utf8, allowLossyConversion: false)
        }
        
        return urlRequest
    }
    
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
        } else if let array = value as? [Any] {
            for (index, value) in array.enumerated() {
                components += queryComponents(fromKey: arrayEncoding.encode(key: key, index: index), value: value)
            }
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(boolEncoding.encode(value: value.boolValue))))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
        } else if let bool = value as? Bool {
            components.append((escape(key), escape(boolEncoding.encode(value: bool))))
        } else {
            components.append((escape(key), escape("\(value)")))
        }
        
        return components
    }
    
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
    private func encodesParametersInURL(with method: HTTPMethod) -> Bool {
        switch destination {
        case .queryString:
            return true
        case .httpBody:
            return false
        default:
            break
        }
        
        switch method {
        case .get, .head, .delete:
            return true
        default:
            return false
        }
    }
}

extension NSNumber {
    fileprivate var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
