

import UIKit
import SVProgressHUD
import RNCryptor

/// Utility class
class Utility {
    // Encryption
    class func encryptionData(data: Data) -> Data {
        let ciphertext = RNCryptor.encrypt(data: data, withPassword: PASSWARDEncryptionDecryption)
        return ciphertext ?? Data()
    }
    // Decryption
    class func decryptionData(data: Data) -> Data {
        var originalData: Data = Data()
        do {
            originalData = try RNCryptor.decrypt(data: data, withPassword: PASSWARDEncryptionDecryption)
        } catch {
            print(error)
        }
        return originalData
    }
    class func showLoader() {
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
    class func hideLoader() {
        DispatchQueue.main.async {
            SVProgressHUD.dismiss()
        }
    }
    // MARK: - Dic to JSON
    /// Conver Dictionary to JSON string
    ///
    /// - Parameter dic: dictionary data
    /// - Returns: json string value
    class func dicToJSON(dic: NSDictionary) -> String {
        var jsonString: String = ""
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dic, options: .prettyPrinted)
            jsonString = String.init(data: jsonData, encoding: .utf8)!
        } catch {
            print(error.localizedDescription)
            jsonString = ""
        }
        return jsonString
    }
    // MARK: - JSON to Dic
    /// Convert string json value to dictionary
    ///
    /// - Parameter text: string value
    /// - Returns: covert in dictionary
    class func convertToDictionary(text: String?) -> [String: Any]? {
        guard let text = text else {
            return [:]
        }
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    /// Convert JSON to string
    ///
    /// - Parameter json: json value
    /// - Returns: string value
    class func convertJSONToString(json: [String: Any]?) -> String? {
        var encodedData = String()
        guard let text = json else {
            return String()
        }
        do {
            let serializedData = try JSONSerialization.data(withJSONObject: text, options: [])
            encodedData = String(data: serializedData, encoding: String.Encoding.utf8)!
        } catch {
            print(error.localizedDescription)
        }
        return encodedData
    }
    // MARK: - Get Like List API Call Done
    /// Like API call done first time or not
    ///
    /// - Parameter isCallDone: true or false
    class func setGetLikeListAPICallDone(isCallDone: Bool) {
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: isCallDone)
        UserDefaults.standard.set(Utility.encryptionData(data: encodedData),
                                  forKey: UserDefaultKey.keyGetLikeListAPICallDone)
        UserDefaults.standard.synchronize()
    }
    /// Check Is like api first time done or not
    ///
    /// - Returns: true or false
    class func getGetLikeListAPICallDone() -> Bool {
        if UserDefaults.standard
            .object(forKey: UserDefaultKey.keyGetLikeListAPICallDone) == nil {
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: false)
            UserDefaults.standard.set(encodedData, forKey: UserDefaultKey.keyGetLikeListAPICallDone)
            UserDefaults.standard.synchronize()
        }
        let decoded = UserDefaults.standard.object(forKey: UserDefaultKey.keyGetLikeListAPICallDone) as? Data ?? Data()
        let decodedData = NSKeyedUnarchiver
            .unarchiveObject(with: Utility.decryptionData(data: decoded)) as? Bool ?? false
        return decodedData
    }
    class func removeImageToDocumentDirectory(urls: [URL]) {
        for item in urls {
            // get the documents directory url
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            // choose a name for your image
            let fileName = item.lastPathComponent
            // create the destination file url to save your image
            let fileURL = documentsDirectory.appendingPathComponent(fileName)
            // get your UIImage jpeg data representation and check if the destination file url already exists
            do {
                // writes the image data to disk
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    //Remove here
                    try FileManager.default.removeItem(atPath: fileURL.path)
                    //                    print("IMAGE REMOVED SUCCESSFULLY")
                }
            } catch {
                print("error saving file:", error)
            }
        }
    }
    class func deleteDocumentDirectory(to document: URL) {
        let fileManager = FileManager.default
        do {
            try fileManager.removeItem(at: document)
            print("Document Directory Deleted Successfully \(document)")
        } catch {
            print(error.localizedDescription)
        }
    }
    /// Get UDID of device
    ///
    /// - Returns: udid string
    class func getUUID() -> String? {
        //print(UUID().uuidString)
        return UUID().uuidString
    }
    /// Get current app version
    ///
    /// - Returns: string
    class func getAppVersion() -> String {
        let bundleMAIN = Bundle.main
        return bundleMAIN.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
    /// Get current app build version
    ///
    /// - Returns: string
    class func getBuildAppVersion() -> String {
        let bundleMAIN = Bundle.main
        return bundleMAIN.infoDictionary?["CFBundleVersion"] as?  String ?? ""
    }

    class func openAppstore(stringUrl: String) {
        guard let url = URL.init(string: stringUrl) else {return}
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.openURL(url)
            }
        }
    }
   
}

