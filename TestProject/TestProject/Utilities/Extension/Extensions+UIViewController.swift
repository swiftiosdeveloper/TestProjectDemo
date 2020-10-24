

import UIKit
import SVProgressHUD

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UIViewController Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UIViewController {
    // MARK: - Action Sheet
    struct Holder {
        static var alertVC: UIAlertController = UIAlertController.init()
    }
    var alertViewController: UIAlertController {
        get {
            return Holder.alertVC
        }
        set(newValue) {
            Holder.alertVC = newValue
        }
    }
    func showActionSheet(_ title: String = AppConstant.AppName,
                         message: String,
                         deleteTitle: String? = "Delete",
                         saveTitle: String? = "Save",
                         shareTitle: String? = "Share",
                         deleteAction: (() -> Void)? = nil,
                         saveAction: (() -> Void)? = nil,
                         shareAction: (() -> Void)? = nil,
                         cancelAction: (() -> Void)? = nil) {
        let actionSheet = UIAlertController(title: title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: deleteTitle,
                                            style: .default,
                                            handler: { (_) in
            if deleteAction != nil {
                deleteAction!()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: saveTitle, style: .default, handler: { (_) in
            if deleteAction != nil {
                saveAction!()
            }
        }))
        actionSheet.addAction(UIAlertAction(title: shareTitle, style: .default, handler: { (_) in
            if shareAction != nil {
                shareAction!()
            }
        }))
        if cancelAction != nil {
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
                cancelAction!()
            }))
        }
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                actionSheet.popoverPresentationController?.sourceView = self.view
                actionSheet.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    func showActionSheet(_ title: String = AppConstant.AppName,
                         message: String, doneTitle: String? = "OK",
                         cancelTitle: String? = "Cancel",
                         doneAction: (() -> Void)? = nil,
                         cancelAction: (() -> Void)? = nil) {
        let actionSheet = UIAlertController(title: title,
                                            message: nil,
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: doneTitle, style: .default, handler: { (_) in
            if doneAction != nil {
                doneAction!()
            }
        }))
        if cancelAction != nil {
            actionSheet.addAction(UIAlertAction(title: cancelTitle, style: .default, handler: { (_) in
                cancelAction!()
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                actionSheet.popoverPresentationController?.sourceView = self.view
                actionSheet.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    func showDeleteActionSheet(_ title: String = AppConstant.AppName,
                               message: String, doneTitle: String? = "Delete",
                               cancelTitle: String? = "Cancel",
                               doneAction: (() -> Void)? = nil,
                               cancelAction: (() -> Void)? = nil) {
        let actionSheet = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let delete = UIAlertAction(title: doneTitle, style: .default, handler: { (_) in
            if doneAction != nil {
                doneAction!()
            }
        })
        delete.setValue(UIColor.red, forKey: "titleTextColor")
        actionSheet.addAction(delete)
        if cancelAction != nil {
            let cancel = UIAlertAction(title: cancelTitle, style: .cancel, handler: { (_) in
                cancelAction!()
            })
            actionSheet.addAction(cancel)
        }
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                actionSheet.popoverPresentationController?.sourceView = self.view
                actionSheet.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                self.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    // MARK: - Alert
    func alertWith(_ title: String = AppConstant.AppName,
                   message: String,
                   doneTitle: String? = "OK",
                   cancelTitle: String? = "Cancel",
                   doneAction: (() -> Void)? = nil,
                   cancelAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: doneTitle,
                                      style: .default,
                                      handler: { (_) in
            if doneAction != nil {
                doneAction!()
            }
        }))
        if cancelAction != nil {
            alert.addAction(UIAlertAction(title: cancelTitle,
                                          style: .cancel,
                                          handler: { (_) in
                cancelAction!()
            }))
        }
        alert.view.tintColor = colorBlueNavigation
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(alert, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func alertWithMessage(_ title: String = AppConstant.AppName, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        }))
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(alert, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func errorAlert(_ title: String = AppConstant.AppName, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (_) in
        }))
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                alert.popoverPresentationController?.sourceView = self.view
                alert.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(alert, animated: true, completion: nil)
            } else {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func successAlert(_ title: String = AppConstant.AppName,
                      message: String,
                      doneAction: (() -> Void)? = nil) {
        self.alertViewController.dismiss(animated: false, completion: nil)
        self.alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        self.alertViewController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (_) in
            if doneAction != nil {
                doneAction!()
            }
        }))
        DispatchQueue.main.async {
            if UIDevice.current.model.range(of: "iPad") != nil {
                self.alertViewController.popoverPresentationController?.sourceView = self.view
                self.alertViewController.popoverPresentationController?.sourceRect = self.view.bounds
                self.present(self.alertViewController, animated: true, completion: nil)
            } else {
                self.present(self.alertViewController, animated: true, completion: nil)
            }
        }
    }
    func showLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.setDefaultMaskType(.custom)
            //SVProgressHUD.setRingRadius(5.0)
            SVProgressHUD.setRingThickness(4.0)
            SVProgressHUD.setDefaultStyle(.custom)
            SVProgressHUD.setBackgroundColor(UIColor.clear)
            SVProgressHUD.setForegroundColor(colorBlueNavigation)
            SVProgressHUD.show()
        }
    }
    func hideLoader() {
        DispatchQueue.main.async {
        SVProgressHUD.dismiss()
        }
    }
    func isURL(string: String?) -> Bool {
        guard let urlString = string else {return false}
        guard let url = NSURL(string: urlString) else {return false}
        if !UIApplication.shared.canOpenURL(url as URL) {return false}
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format: "SELF MATCHES %@", argumentArray: [regEx])
        return predicate.evaluate(with: string)
    }
}
