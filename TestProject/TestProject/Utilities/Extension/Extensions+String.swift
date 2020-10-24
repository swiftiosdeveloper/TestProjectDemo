

import Foundation
import UIKit

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - String Extension
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    public var length: Int { return self.count }
    var data: Data {
        return Data(utf8)
    }
    var boolValue: Bool {
        return NSString(string: self).boolValue
    }
    var stringByRemovingWhitespaces: String {
        return components(separatedBy: .whitespacesAndNewlines).joined()
    }
    var isValidURL: Bool {
        let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let range = NSRange(location: 0, length: self.utf16.count)
        if let match = detector?.firstMatch(in: self, options: [], range: range) {
            // it is a link, if the match covers the whole string
            return match.range.length == self.utf16.count
        } else {
            return false
        }
    }
    static var CURRENTURL: String {
        return currentAppMode.currentURL
    }
    static var BASEURL: String {
        return currentAppMode.baseURL
    }
    static var BASEIMAGEURL: String {
        return currentAppMode.baseImageURL
    }
    static var MAPURL: String {
        return currentAppMode.mapURL
    }
    //: ### Base64 encoding a string
    func base64Encoded() -> String? {
        if let data = self.data(using: .utf8) {
            return data.base64EncodedString()
        }
        return nil
    }
    
    //: ### Base64 decoding a string
    func base64Decoded() -> String? {
        if let data = Data(base64Encoded: self) {
            return String(data: data, encoding: .utf8)
        }
        return nil
    }
}
