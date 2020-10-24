

import UIKit
import CoreGraphics
import SDWebImage
import RealmSwift

// MARK: - TextField

extension UITextField{
    
    func setCustomePlaceholder(placeholderText : String,textColor : UIColor){
        self.attributedPlaceholder = NSAttributedString(string: placeholderText,
                                                        attributes: [NSAttributedString.Key.foregroundColor: textColor])
    }
    func setCursor(position: Int) {
        let position = self.position(from: beginningOfDocument, offset: position)!
        selectedTextRange = textRange(from: position, to: position)
    }
}




// MARK: - UIStoryboard extension
extension UIStoryboard {
    static let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    static let waitTime : UIStoryboard = UIStoryboard(name: "WaitTime", bundle: nil)
    static let downTime : UIStoryboard = UIStoryboard(name: "DownTime", bundle: nil)
    static let operatingInfo : UIStoryboard = UIStoryboard(name: "OperatingInfo", bundle: nil)
    static let notification : UIStoryboard = UIStoryboard(name: "Notification", bundle: nil)
    static let dashboard : UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)

}


// MARK: - UIFont extension

/// This extension provide differant types of fonts which are supported by system.
extension UIFont{
    static func FONT_IBMPlexSans_Medium(size: CGFloat) -> UIFont {
        return UIFont(name: "IBMPlexSans-Medium", size: size)!
    }
    static func FONT_IBMPlexSans_Bold(size: CGFloat) -> UIFont {
        return UIFont(name: "IBMPlexSans-Bold", size: size)!
    }
    static func FONT_IBMPlexSans_Regular(size: CGFloat) -> UIFont {
        return UIFont(name: "IBMPlexSans", size: size)!
    }
    static func FONT_IBMPlexSans_SemiBold(size: CGFloat) -> UIFont {
        return UIFont(name: "IBMPlexSans-SemiBold", size: size)!
    }
}


extension Date {
    func isBetweeen(date date1: Date, andDate date2: Date) -> Bool {
        return date1.compare(self) == self.compare(date2)
    }
    
    func compareTimeOnly(to: Date) -> ComparisonResult {
        let calendar = Calendar.current
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!
        
        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        if seconds == 0 {
            return .orderedSame
        } else if seconds > 0 {
            // Ascending means before
            return .orderedAscending
        } else {
            // Descending means after
            return .orderedDescending
        }
    }
    
    var timeAgoSinceNow: String {
        return getTimeAgoSinceNow()
    }
    
    private func getTimeAgoSinceNow() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year ago" : "\(interval)" + " years ago"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month ago" : "\(interval)" + " months ago"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day ago" : "\(interval)" + " days ago"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour ago" : "\(interval)" + " hours ago"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute ago" : "\(interval)" + " minutes ago"
        }
        
        return "a moment ago"
    }
    
    func getTimeDefferanceFromNow() -> String {
        
        var interval = Calendar.current.dateComponents([.year], from: self, to: Date()).year!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " year" : "\(interval)" + " years"
        }
        
        interval = Calendar.current.dateComponents([.month], from: self, to: Date()).month!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " month" : "\(interval)" + " months"
        }
        
        interval = Calendar.current.dateComponents([.day], from: self, to: Date()).day!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " day" : "\(interval)" + " days"
        }
        
        interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " hour" : "\(interval)" + " hours"
        }
        
        interval = Calendar.current.dateComponents([.minute], from: self, to: Date()).minute!
        if interval > 0 {
            return interval == 1 ? "\(interval)" + " minute" : "\(interval)" + " minutes"
        }
        
        return "a moment ago"
    }
    
    func getTimeDefferanceFromNow() -> Int {
    
        let interval = Calendar.current.dateComponents([.hour], from: self, to: Date()).hour!
        if abs(interval) >= 24 {
            return abs(interval)
        }
        return 0
    }
}

extension Notification{
    static let notiToggleUpDownScreen = Notification.Name.init("toggleUpDownScreen")
    static let pinChangedNotification = Notification.Name.init("pinChanged")
    static let notiAttractionChange = Notification.Name.init("AttractionChange")
    static let notiIsShowBaseCounter = Notification.Name.init("notiIsShowBaseCounter")
    static let parkChangeNotification = Notification.Name.init("parkChangeNotification")
    static let recievedSummaryPush = Notification.Name.init("recievedSummaryPush")

}

extension Array where Element: Equatable {
    mutating func move(_ item: Element, to newIndex: Index) {
        if let index = firstIndex(of: item) {
            move(at: index, to: newIndex)
        }
    }
    
    mutating func bringToFront(item: Element) {
        move(item, to: 0)
    }
    
    mutating func sendToBack(item: Element) {
        move(item, to: endIndex-1)
    }
}

extension Array {
    mutating func move(at index: Index, to newIndex: Index) {
        insert(remove(at: index), at: newIndex)
    }
}


// MARK: - Extension of DateFormatter
extension DateFormatter {
    static let yyyyMMddTHHmmss = "yyyy-MM-dd'T'HH:mm:ss"
    static let yyyyMMddTHHmmssa = "yyyy-MM-dd'T'HH:mm:ss a"
    static let yyyyMMddTHHmm = "yyyy-MM-dd'T'HH:mm"
    static let yyyyMMddTHHmmssSSS = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    static let ddMMYYYY = "dd/MM/YYYY"
    static let HHmm = "HH:mm"
    static let HHMM = "HH:MM"
    static let hhmmssa = "hh:mm:ss a"
    static let HHmmss = "HH:mm:ss"
    static let ddmmyyyy = "dd-MM-yyyy"
    static let yyyyMMddHHmmss = "yyyy-MM-dd HH:mm:ss"
    static let ddMMyyyy = "dd-MM-yyyy"


}

extension TimeZone {

    func offsetFromUTC() -> String
    {
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }

    func offsetInHours() -> String
    {

        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}

extension Dictionary {
    var queryString: String {
        var output: String = ""
        for (key,value) in self {
            output +=  "\(key)=\(value)&"
        }
        output = String(output.dropLast())
        return output
    }
}

extension UINavigationController {
    
    override open var shouldAutorotate: Bool {
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.shouldAutorotate
            }
            return super.shouldAutorotate
        }
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.preferredInterfaceOrientationForPresentation
            }
            return super.preferredInterfaceOrientationForPresentation
        }
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        get {
            if let visibleVC = visibleViewController {
                return visibleVC.supportedInterfaceOrientations
            }
            return super.supportedInterfaceOrientations
        }
    }
}
