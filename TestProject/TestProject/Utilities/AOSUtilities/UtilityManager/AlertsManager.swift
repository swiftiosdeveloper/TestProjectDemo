//
//  AlertsManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit
import CoreFoundation

/// Description : This class is use for show or display alert view controller within any view controller
class AlertsManager: NSObject {
    
    /// Description : Shared Instance method for global access
    public class var sharedInstance : AlertsManager {
        struct Static {
            static let instance : AlertsManager = AlertsManager()
        }
        return Static.instance
    }
    
    /// Description : This function is used for show alert globally and configure two button
    /// - Parameter message: message need to be display
    /// - Parameter firstBtnName: firstBtnName
    /// - Parameter firstBtnHandler: firstBtnHandler
    /// - Parameter secondBtnName: secondBtnName
    /// - Parameter secondBtnHandler: secondBtnHandler
    
    func showAlert(message: String, firstBtnName: String = "OK", firstBtnHandler: ((UIAlertAction) -> Void)? = nil, secondBtnName: String? = nil, secondBtnHandler: ((UIAlertAction) -> Void)? = nil) {
        if UIApplication.shared.isIgnoringInteractionEvents {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        self.dismissAnyAlertControllerIfPresent()
        let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: firstBtnName, style: .default, handler: firstBtnHandler))
        if secondBtnName != nil {
            alertController.addAction(UIAlertAction(title: secondBtnName, style: .default, handler: secondBtnHandler))
        }
        if(GlobalAppManager.sharedInstance.topMostController()?.presentingViewController != nil) {
            GlobalAppManager.sharedInstance.topMostController()?.present(alertController, animated: true, completion: nil)
            return
        }
        DispatchQueue.main.async {
            kAppDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    }
    
    /// Description : This function is used for show alert which having one button only
    /// - Parameter message: message to be display
    /// - Parameter firstBtnName: firstBtnName
    /// - Parameter firstBtnHandler: firstBtnHandler
    func showAlert(message: String, firstBtnName: String = "OK", firstBtnHandler: ((UIAlertAction) -> Void)? = nil) {
        if (UIApplication.shared.isIgnoringInteractionEvents) {
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        self.dismissAnyAlertControllerIfPresent()
        let alertController = UIAlertController(title: kAppName, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: firstBtnName, style: .default, handler: firstBtnHandler))
        if(GlobalAppManager.sharedInstance.topMostController()?.presentingViewController != nil) {
            GlobalAppManager.sharedInstance.topMostController()?.present(alertController, animated: true, completion: nil)
        } else {
            DispatchQueue.main.async {
                kAppDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    public func showActionSheet(sourceView: UIView, title: [String], handler: @escaping (Int) -> ()) {
        let alertController = UIAlertController(title: "Select", message: "", preferredStyle: .actionSheet)
        alertController.popoverPresentationController?.sourceView = sourceView

        for i in 0..<title.count {
            let otherAction = UIAlertAction(title: title[i], style: .default) { _ in
                handler(i)
            }
            alertController.addAction(otherAction)
        }
        kAppDelegate.window?.rootViewController?.present(alertController, animated: true, completion: nil)

    }
    /// Description : This is global function for display noraml alerts on any view controller
    /// - Parameter title: title for alert
    /// - Parameter strMessage: strMessage for alert
     func displayAlert(title:String , strMessage:NSString) {
         let alert = UIAlertController(title: title, message: strMessage as String, preferredStyle: UIAlertController.Style.alert)
         alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        DispatchQueue.main.async {
            kAppDelegate.window?.rootViewController?.present(alert, animated: true, completion: nil)
        }
     }
    /// Description : This function is used for dismiss any alert controller present in current window
    func dismissAnyAlertControllerIfPresent() {
        if let topController = UIApplication.shared.keyWindow?.rootViewController?.presentedViewController {
           topController.dismiss(animated: false, completion: nil)
        }
    }
}
