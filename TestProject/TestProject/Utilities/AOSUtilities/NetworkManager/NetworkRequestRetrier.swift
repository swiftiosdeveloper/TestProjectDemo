

import UIKit
import Alamofire


/// Description: This class is used to manage network request retry if fail.
class NetworkRequestRetrier: RequestRetrier, RequestAdapter {
    
    

    
    private var retriedRequests: [String: Int] = [:]

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        
    }
    
//    func should(_ manager: Session, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
//        
//        guard
//            request.task?.response == nil,
//            let url = request.request?.url?.absoluteString
//        else {
//            removeCachedUrlRequest(url: request.request?.url?.absoluteString)
//            completion(false, 0.0) // don't retry
//            return
//        }
//        
//        guard let retryCount = retriedRequests[url] else {
//            retriedRequests[url] = 1
//            completion(true, 1.0) // retry after 1 second
//            return
//        }
//        
//        if retryCount <= 3 {
//            retriedRequests[url] = retryCount + 1
//            completion(true, 1.0) // retry after 1 second
//        } else {
//            removeCachedUrlRequest(url: url)
//            completion(false, 0.0) // don't retry
//        }
//    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var adaptedRequest = urlRequest
        adaptedRequest.headers.remove(name: APIHeaderFeild.Authorization)
        if let authToken = realmManager.FetchObjects(type: UserModelClass.self)?.first?.jwtToken{
            print(authToken)
            adaptedRequest.headers.add(name: APIHeaderFeild.Authorization, value: APIHeaderFeild.TokenBearer + " " + authToken)
            completion(.success(adaptedRequest))
        }
    }
    
   
    
    private func removeCachedUrlRequest(url: String?) {
        guard let url = url else {
            return
        }
        retriedRequests.removeValue(forKey: url)
    }
    
}
