
import Foundation
import UIKit
import SVProgressHUD
import Alamofire
import SDWebImage
import AlamofireImage
import WebKit

let imageDownloader = ImageDownloader(
    configuration: ImageDownloader.defaultURLSessionConfiguration(),
    downloadPrioritization: .lifo,
    maximumActiveDownloads: 10,
    imageCache: AutoPurgingImageCache()
)
//var sessionManager: Session = {
//    let configuration = URLSessionConfiguration.default
//    configuration.timeoutIntervalForRequest = TimeInterval(120.0)
//    let trustmanager = ServerTrustManager(evaluators: ["stamaapp1v.rws-dev.rwsentosa.com": DisabledEvaluator()])
//    let manager = Session(configuration: configuration,
//delegate: SessionDelegate(),
//startRequestsImmediately: false,
//serverTrustManager: trustmanager)
//    return manager
//}()
//    
//let imageDownloader = ImageDownloader.init(
//session: sessionManager,
//downloadPrioritization: .lifo,
//maximumActiveDownloads: 6,
//imageCache: AutoPurgingImageCache()
//)
// MARK: - StoryBoard
/// Story Board Constant
extension UIStoryboard {
    static let rws  = UIStoryboard(name: "RWSStoryBoard", bundle: Bundle.main)
}
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UITabBar Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UITabBar {
    // Workaround for iOS 11's new UITabBar behavior where on iPad, the UITabBar inside
    // the Master view controller shows the UITabBarItem icon next to the text
    override open var traitCollection: UITraitCollection {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return UITraitCollection(horizontalSizeClass: .compact)
        }
        return super.traitCollection
    }
}
extension Bool {
    var intValue: Int {
        return NSNumber(value: self).intValue
    }
}
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - UINavigationController Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension UINavigationController {
    var rootViewController: UIViewController? {
        return self.viewControllers.first
    }
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - Data Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension Data {
    var attributedString: NSAttributedString? {
        do {
            let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
                NSAttributedString.DocumentType.html]
            return try NSAttributedString(data: self, options: options, documentAttributes: nil)
        } catch {
        }
        return nil
    }
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - Date Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

// MARK: - Extension of UIFont
extension UIFont {
    /// Get avenir pro medium font with specific size.
    ///
    /// - Parameter size: Font size.
    /// - Returns: AvenirLTPro-Medium font.
    class func sourceSansProRegular(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Regular", size: size)!
    }
    class func sourceSansProBold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Bold", size: size)!
    }
    class func sourceSansProSemibold(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: "SourceSansPro-Semibold", size: size)!
    }
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - NSError Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension NSError {
    class func error(with message: String) -> NSError {
        let error = NSError.init(domain: "Local", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
        return error
    }
}

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - URL Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension URL {
    func downloadImagerFromURLAvailable(fileURL: URL) {
        NetworkUtilities.AFManager.request(self).responseData { (response) in
            if response.response?.statusCode == 404 {
                self.reamoveImageFromCache(fileURL: fileURL)
            }
        }
    }
    func reamoveImageFromCache(fileURL: URL) {
        Utility.removeImageToDocumentDirectory(urls: [fileURL])
    }
    func downloadImagerFromURL(imageURL: URL, imageName: String, documentDirURL: URL) {
        SDWebImagePrefetcher.shared.prefetchURLs([imageURL], progress: nil, completed: { _, _ in
//            print("Prefetch complete!")
        })
        imageDownloader.download(URLRequest.init(url: imageURL)) { response in
            switch response.result {
            case .success:
//                print(value)
                self.saveImageToDocumentDirectory(imageName: imageName,
                                                  imageData: response.data,
                                                  documentDirURL: documentDirURL)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    func saveImageToDocumentDirectory(imageName: String?, imageData: Data?, documentDirURL: URL) {
        if let data = imageData {
            do {
                // writes the image data to disk
                if !FileManager.default.fileExists(atPath: documentDirURL.path) {
                    //Remove here
                }
                // print(fileURL)
                let encryptData: Data = Utility.encryptionData(data: data)
                try encryptData.write(to: documentDirURL, options: Data.WritingOptions.completeFileProtection)
            } catch {
                print("error saving file:", error)
            }
        }
    }
}
// MARK: - Dictionary
extension Dictionary where Key: ExpressibleByStringLiteral, Value: Any {
    var jsonData: Data? {
        do {
            return try JSONSerialization.data(withJSONObject: self)
        } catch {
            return nil
        }
    }
    func getStrigValue(for key: String) -> String? {
        if let dic = self as? [String: Any] {
            if let value = dic[key] as? String {
                return value
            } else if let value = dic[key] as? Int {
                return String(value)
            }
        }
        return nil
    }
    func getIntValue(for key: String) -> Int? {
        if let dic = self as? [String: Any] {
            if let value = dic[key] as? String {
                return Int(value)
            } else if let value = dic[key] as? Int {
                return value
            }
        }
        return nil
    }
}
// MARK: - Data
extension Data {
    func getJSONResponse() -> Any? {
        guard let response = try? JSONSerialization.jsonObject(with: self) else {
            return nil
        }
        return response
    }
    var size: Double {
        return Double(self.count) / (1000 * 1000)
    }
}

// MARK: - Int
extension Int {
    static let zero = 0
    static let success = 200
    static let unAuthorize = 401
    static let badRequest = 400
    static let internalServerError = 500
}

// MARK: - Bundle
extension Bundle {
    var appName: String {
        return (infoDictionary?["CFBundleName"] as? String) ?? ""
    }
    var bundleId: String {
        return bundleIdentifier ?? ""
    }
    var versionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? ""
    }
    var buildNumber: String {
        return (infoDictionary?["CFBundleVersion"] as? String) ?? ""
    }
}
extension Sequence where Iterator.Element: Hashable {
    func uniq() -> [Iterator.Element] {
        var seen = Set<Iterator.Element>()
        return filter { seen.update(with: $0) == nil }
    }
}
