
import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import Reachability

/// Description: This calss used to manage network avaibility status.
protocol NetworkAvailablityDelegate{
    func NetworkAvailable()
    func NetworkUnAvailable()
}

class NetworkAvailablity: NSObject {

    var internetReachable : Reachability =  try! Reachability()
    var networkDelegate : NetworkAvailablityDelegate?
    
    public class var sharedInstance : NetworkAvailablity {
           struct Static {
               static let instance : NetworkAvailablity = NetworkAvailablity()
           }
           return Static.instance
       }
    
    override init() {
        
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.checkNetworkStatus(notification:)), name: NSNotification.Name.reachabilityChanged, object: nil)
       do{
        try self.internetReachable.startNotifier()
        }catch{
          print("could not start reachability notifier")
        }
    }
    
    
    // MARK: - Check for network status.
       @objc func checkNetworkStatus(notification : NSNotification){
           
           RunLoop.cancelPreviousPerformRequests(withTarget: self)
           NSObject.cancelPreviousPerformRequests(withTarget: self)
           
           let reachability = notification.object as! Reachability
        switch reachability.connection {
           case .wifi:
               print("Reachable via WiFi")
               self.networkDelegate?.NetworkAvailable()
        case .cellular:
           print("Reachable via WAN")
               self.networkDelegate?.NetworkAvailable()
        case .unavailable:
               self.networkDelegate?.NetworkUnAvailable()
           default:
               self.networkDelegate?.NetworkUnAvailable()

           }
       }
}
