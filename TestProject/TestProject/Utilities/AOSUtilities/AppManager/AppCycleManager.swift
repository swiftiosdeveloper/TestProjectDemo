

import UIKit


/// Description: This calss is used to manage application lifr cycle.

// MARK: - Protocols

protocol AppCycleManagerDelegate {
    func willResignActive(_ notification: Notification)
    func willEnterForeground(_ notification: Notification)
    func didEnterBackground(_ notification: Notification)
    func didActivate(_ notification: Notification)
}
// MARK: - Class
class AppCycleManager: NSObject {
    static let shared = AppCycleManager()
    var delegate:AppCycleManagerDelegate?
    override init() {
        super.init()
        self.addApplicationObserver()
    }
    func addApplicationObserver(){
        if #available(iOS 13.0, *) {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive(_:)), name: UIScene.willDeactivateNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIScene.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIScene.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didActivate(_:)), name: UIScene.didActivateNotification, object: nil)
        } else {
            NotificationCenter.default.addObserver(self, selector: #selector(willResignActive(_:)), name: UIApplication.willResignActiveNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground(_:)), name: UIApplication.didEnterBackgroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: UIApplication.willEnterForegroundNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(didActivate(_:)), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }
    @objc func willResignActive(_ notification: Notification) {
        // code to execute
        debugPrint("willResignActive")
        SignalRManager.shared.disconnect()
        SignalRManager.shared.stopSignalTimer()
        delegate?.willResignActive(notification)
    }
    @objc func willEnterForeground(_ notification: Notification) {
        // code to execute
        debugPrint("willEnterForeground")
        SignalRManager.shared.reConnect()
        SignalRManager.shared.startSignalTimer()
        delegate?.willEnterForeground(notification)
    }
    @objc func didEnterBackground(_ notification: Notification) {
        // code to execute
        debugPrint("didEnterBackground")
        SignalRManager.shared.disconnect()
        delegate?.didEnterBackground(notification)
        SignalRManager.shared.stopSignalTimer()
        
    }
    @objc func didActivate(_ notification: Notification) {
        // code to execute
        debugPrint("didActivate")
        SignalRManager.shared.reConnect()
        SignalRManager.shared.startSignalTimer()
        delegate?.didActivate(notification)
    }
}
// MARK: - END
