
import UIKit

// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
// MARK: - FileManager
// #-#-#-#-#-#-#-#-#-#-#-#-#-#-#
extension FileManager {
    static var documentDirectoryURL: URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    static var myBannerImageDirectoryURL: URL {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("MyBannerImage")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    static var myDatabaseDirectoryURL: URL {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("MyDatabase")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    static var mySideMenuDirectoryURL: URL {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("MySideMenu")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    static var myEventDirectoryURL: URL {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("MyEvent")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
    static var myGuideDirectoryURL: URL {
        let url = FileManager.documentDirectoryURL.appendingPathComponent("MyGuide")
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return url
    }
}
