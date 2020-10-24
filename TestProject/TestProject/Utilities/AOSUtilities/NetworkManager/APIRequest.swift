

import Alamofire

/// Description : This is enum for BodyEncoading , which define all diffrent type of encoading which can be give to http request
enum HTTPBodyEncoding {
    case json
    case queryString
    case httpBody
    case undefined
}

/// Description : This is structure which is used for define the apirequest with optional and non-optional parameter
struct APIRequest {
    let url: String
    let method: HTTPMethod
    var parameters: Parameters?
    var headers: HTTPHeaders?
    let encoding: Any?
    let httpbody : Data?
    
    /// Description : This is the init method for url request
    /// - Parameter url: url
    /// - Parameter method: method name
    /// - Parameter parameters: parameters
    /// - Parameter httpbody: httpbody
    /// - Parameter headers: headers
    /// - Parameter encoding: encoding 
    init(url: String, method: HTTPMethod, parameters: Parameters? = nil , httpbody : Data? = nil, headers: HTTPHeaders? = nil, encoding: Any = JSONEncoding.default) {
        self.url = url
        self.method = method
        self.parameters = parameters
        self.headers = [:]
        self.httpbody = httpbody
        self.encoding = JSONEncoding.default//URLEncoding.httpBody
    }
}

struct JSONArrayEncoding: ParameterEncoding {
    private let array: [Parameters]

    init(array: [Parameters]) {
        self.array = array
    }

    func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
        var urlRequest = try urlRequest.asURLRequest()

        let data = try JSONSerialization.data(withJSONObject: array, options: [])

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }

        urlRequest.httpBody = data

        return urlRequest
    }
}
