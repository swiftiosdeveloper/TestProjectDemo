//
//  GlobalAppManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit
import Foundation
import IQKeyboardManagerSwift

/// Description : This is the global app manager class which is used for declaring all global methods used throuhout the application
class GlobalAppManager: NSObject {
    
    /// Description : Shared Instance method for global access
    public class var sharedInstance : GlobalAppManager {
        struct Static {
            static let instance : GlobalAppManager = GlobalAppManager()
        }
        return Static.instance
    }
    
    var apiURLArray = [String]()
    
    // MARK: - Class Methods
    
    /// Description : This function is used globally for enable IQKeyboard
    func EnableIQKeyboard(enable:Bool = true,enableAutoToolbar:Bool = false,shouldShowToolbarPlaceholder:Bool = true,shouldResignOnTouchOutside:Bool = true,previousNextDisplayMode:IQPreviousNextDisplayMode = .default) {
        IQKeyboardManager.shared.enable = enable
        IQKeyboardManager.shared.enableAutoToolbar = enableAutoToolbar
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = shouldShowToolbarPlaceholder
        IQKeyboardManager.shared.shouldResignOnTouchOutside = shouldResignOnTouchOutside
        IQKeyboardManager.shared.previousNextDisplayMode = previousNextDisplayMode
    }
    
    /// Description : This function is used globally for disable IQKeyboard
    func DisableIQKeyboard() {
        IQKeyboardManager.shared.enable = false
        IQKeyboardManager.shared.enableAutoToolbar = false
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = false
    }
    
    /// Description : This function is used for open the setting screen of the device
    /// - Parameter strMessaege: strMessaege which will appeared on the alert
    func openSettingScreen(strMessaege:String) {
        AlertsManager.sharedInstance.showAlert(message: strMessaege, firstBtnName: "Cancel", firstBtnHandler: { (action) in
        }, secondBtnName: "Settings") { (action) in
            self.openSetting()
        }
    }
    
    func encode(toBase64String image_data: Data) -> String {
        return image_data.base64EncodedString(options: .lineLength64Characters)
    }
    
    func decodeBase64(toImage strEncodeData: String) -> Data {
        let data = Data(base64Encoded: strEncodeData, options: .ignoreUnknownCharacters)
        return data ?? Data()
    }
    
    /// Description : This function open the setting screen of the device
    func openSetting(){
        guard let settingsUrl = URL(string:UIApplication.openSettingsURLString) else {
            return
        }
        if UIApplication.shared.canOpenURL(settingsUrl) {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            } else {
            }
        }
    }
    
    /// Description : This function is used for the emoji encoading
    /// - Parameter s: emoji string
    func encodeEmojiString(_ s: String) -> String {
        let data = s.data(using: .nonLossyASCII, allowLossyConversion: true)!
        return String(data: data, encoding: .utf8)!
    }
    
    /// Description : This function is used for decode the emoji
    /// - Parameter s: encoded emoji string
    func decodeEmojiString(_ s: String) -> String? {
        let data = s.data(using: .utf8)!
        return String(data: data, encoding: .nonLossyASCII)
    }
    
    /// Description : This function is used for the add leftview with image to the textfeild
    /// - Parameter textFeild: textFeild
    /// - Parameter image: image
    /// - Parameter strPlaceHolder: strPlaceHolder text
    /// - Parameter padding: padding - space you want to add in the leftview
    func addLeftViewToTextFeild (textFeild : UITextField , image:UIImage , strPlaceHolder:String,padding:CGFloat) {
        let leftImageView = UIImageView()
        leftImageView.contentMode = .scaleAspectFit
        
        let leftView = UIView()
        leftView.frame = CGRect(x: 0, y: 0, width: padding, height: textFeild.frame.size.height)
        leftImageView.frame = CGRect(x: 13, y: 0, width: 15, height: 20)
        textFeild.leftViewMode = .always
        textFeild.leftView = leftView
        
        leftImageView.image = image
        leftImageView.tintColor = UIColor(red: 106/255, green: 79/255, blue: 131/255, alpha: 1.0)
        leftImageView.tintColorDidChange()
        leftView.addSubview(leftImageView)
        textFeild.leftViewMode = UITextField.ViewMode.always
        textFeild.leftView = leftView;
    }
    
    // MARK: - Get Topmost View Controller
    
    /// Description : This function is used for getting topMostController in current stack
    func topMostController() -> UIViewController? {
        var topController: UIViewController? = kAppDelegate.window?.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        return topController
    }
    
    
    /// Description : This function is used for the topcorner to anyview
    /// - Parameter object: uiview need to apply corner raidus
    /// - Parameter radius: radius
    func setTopCorner( object: UIView , radius: Int)-> CAShapeLayer {
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = (object.superview?.frame)!
        rectShape.position = object.center
        rectShape.path = UIBezierPath(roundedRect: object.bounds, byRoundingCorners: [.topLeft , .topRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        object.layer.backgroundColor = UIColor.white.cgColor
        return rectShape
    }
    
    /// Description : This function is used for the bottom corner radius to anyview
    /// - Parameter object: uiview need to apply corner raidus
    /// - Parameter radius: radius
    func setBottomCorner( object : UIView, radius : Int) -> CAShapeLayer {
        
        let rectShape = CAShapeLayer()
        rectShape.bounds = object.frame
        rectShape.position = object.center
        rectShape.path = UIBezierPath(roundedRect: object.bounds, byRoundingCorners: [ .bottomLeft , .bottomRight], cornerRadii: CGSize(width: radius, height: radius)).cgPath
        
        object.layer.backgroundColor = UIColor.white.cgColor
        return rectShape
    }
    
    
    /// Description : This function is used to clear all files from document directory folder.
    func clearAllFile() {
        let fileManager = FileManager.default
        let myDocuments = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            try fileManager.removeItem(at: myDocuments)
        } catch {
            return
        }
    }
    
    
    /// Description : This function used to check device is iPad of iPhone.
    func isiPad()->Bool {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return true
        }
        return false
    }
    
    
    /// Description : This function is used to check user is logged in or not.
    func isLogin()->Bool {
        if let userToken = realmManager.FetchObjects(type: UserModelClass.self)?.first?.jwtToken {
            return userToken.count > 1 ? true : false
        }
        return false
    }
    
    
    /// Description : this function is used to check user has selected attraction or not.
    func isAttractionSelected()->Bool {
           if let userToken = UserDefaults.standard.secretObject(forKey: UserDefaultsKey.CurrentAttraction) as? Int {
               return userToken > 0 ? true : false
           }
           return false
       }
    
    
    /// Description : This Function used to set header font in whole app.
    func headerFont()->UIFont {
        var myDefaultFontSize: CGFloat = 17
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = 11.0
        case .iPhone6,.iPhone6S,.iPhone7,.iPhone6Plus,.iPhone6SPlus,.iPhone7Plus,.iPhone8,.iPhone8Plus:
            myDefaultFontSize = 14.0
        default: break
        }
        return UIFont.FONT_IBMPlexSans_Bold(size:myDefaultFontSize)
    }
    
    /// Description : This Function used to set  segment font in whole app.
    func segmentFont()->UIFont {
        var myDefaultFontSize: CGFloat = 13.0
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = 11.0
        case .iPhone6,.iPhone6S,.iPhone7,.iPhone6Plus,.iPhone6SPlus,.iPhone7Plus,.iPhone8,.iPhone8Plus:
            myDefaultFontSize = 12.0
        default: break
        }
        return UIFont.FONT_IBMPlexSans_SemiBold(size:myDefaultFontSize)
    }
    
    /// Description : This Function used to set sub header font in whole app.
    func subHeaderFont()->UIFont {
        var myDefaultFontSize: CGFloat = 10
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = 8.0
        case .iPhone6,.iPhone6S,.iPhone7:
            myDefaultFontSize = 9.0
        default:
            break
        }
        return UIFont.FONT_IBMPlexSans_Bold(size:myDefaultFontSize)
    }
    
    /// Description : This Function used to set body title font in whole app.
    func bodyTitleFont()->UIFont {
        var myDefaultFontSize: CGFloat = 30.0
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = 25.0
        case .iPhone6,.iPhone6S,.iPhone7:
            myDefaultFontSize = 28.0
        default: break
        }
        return UIFont.FONT_IBMPlexSans_Bold(size:myDefaultFontSize)
    }
    
    /// Description : This Function used to set body sub title font in whole app.
    func bodySubTitleFont()->UIFont {
        var myDefaultFontSize: CGFloat = 16.0
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = 12.0
        case .iPhone6,.iPhone6S,.iPhone7:
            myDefaultFontSize = 14.0
        default: break
        }
        return UIFont.FONT_IBMPlexSans_Bold(size:myDefaultFontSize)
    }
    
    func IBMPlexSans_Reguler(ipad:CGFloat,iPhone:CGFloat)->UIFont {
        var myDefaultFontSize: CGFloat = globalAppManager.isiPad() ? ipad : iPhone
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = iPhone - 2
        case .iPhone6,.iPhone6S,.iPhone7,.iPhone6Plus,.iPhone6SPlus,.iPhone7Plus,.iPhone8,.iPhone8Plus:
            myDefaultFontSize = iPhone - 1
        default: break
        }
        return UIFont.FONT_IBMPlexSans_Regular(size: myDefaultFontSize)
    }
    func IBMPlexSans_SemiBold(ipad:CGFloat,iPhone:CGFloat)->UIFont {
        var myDefaultFontSize: CGFloat = globalAppManager.isiPad() ? ipad : iPhone
        switch UIDevice().type {
        case .iPhone4,.iPhone4S,.iPhoneSE, .iPhone5, .iPhone5S:
            myDefaultFontSize = iPhone - 2
        case .iPhone6,.iPhone6S,.iPhone7,.iPhone6Plus,.iPhone6SPlus,.iPhone7Plus,.iPhone8,.iPhone8Plus:
            myDefaultFontSize = iPhone - 1
        default: break
        }
        return UIFont.FONT_IBMPlexSans_SemiBold(size: myDefaultFontSize)
    }
    
    
    /// Description : This function is used to calculate height of checkbox control.
    /// - Parameters:
    ///   - arr: array of string options.
    ///   - font: font of  control.
    ///   - width: width of control.
    func getHeightForCheckBoxRadioButton(arr: [String], font: UIFont, width: CGFloat) -> CGFloat {
        var arrHeight = [CGFloat]()
        arr.forEach { (item) in
            let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byWordWrapping
            label.font = font
            label.text = item
            label.sizeToFit()
            arrHeight.append(label.frame.height)
        }
        debugPrint(arrHeight)
        debugPrint(arrHeight.max() ?? 0.0)
        return (arrHeight.max() ?? 0.0) < ((globalAppManager.isiPad() ? 50 : 40)) ? (globalAppManager.isiPad() ? 60 : 50) : (arrHeight.max() ?? 0.0)
    }
    // MARK: - convertToDictionary
    
    /// Description : This function is used to convert string into dictionary
    /// - Parameter text: text
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
}
// MARK: - End
