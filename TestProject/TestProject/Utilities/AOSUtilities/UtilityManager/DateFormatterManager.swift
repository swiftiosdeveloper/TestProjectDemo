//
//  DateFormatterManager.swift
//  Atticus
//
//  Created by Comnet India on 11/10/19.
//  Copyright © 2019 Comnet India. All rights reserved.
//

import UIKit

/// Description : This class is used for manage all kind of data formatter methods 
class DateFormatterManager: NSObject {
    
    /// Description : Shared Instance method for global access
    public class var sharedInstance: DateFormatterManager {
        struct Static {
            static let instance: DateFormatterManager = DateFormatterManager()
        }
        return Static.instance
    }
    
    // MARK: - Class Methods
    
    /// Description : This function is used for get current time with UTC format and return in string
    func getCurrentTime() -> String? {
        
        let dateFormatString  = "yyyy-MM-dd'T'HH:mm:ss"
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            dateFormatter.timeZone = aZone as TimeZone
        }
        let current_date = Date()
        var date_stg_only_in_12_formate: String = ""
        
        if check_12hour_and_24hour() == true {
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
            dateFormatter.dateFormat = dateFormatString
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
        } else {
            dateFormatter.dateFormat = dateFormatString
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
        }
        return date_stg_only_in_12_formate
    }
    
    /// Description : This function is used for get the datetime in utc format and return it into string
    /// - Parameter date: date which need to be convert into UTC format
    func getCurrentTimeFromDate(date: Date) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        let timeZone = NSTimeZone(name: "UTC")
        //           if let aZone = timeZone {
        ////               //dateFormatter.timeZone = aZone as TimeZone
        //           }
        let current_date = date
        var date_stg_only_in_12_formate: String
        if check_12hour_and_24hour() == true {
            dateFormatter.dateFormat = "HH:mm:ss"
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
            dateFormatter.dateFormat = "hh:mm:ss a"
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
        }
        else {
            dateFormatter.dateFormat = "hh:mm:ss a"
            date_stg_only_in_12_formate = dateFormatter.string(from: current_date)
        }
        return date_stg_only_in_12_formate
    }
    
    /// Description : This function is used for check if date format is 12hour or 24 hour
    func check_12hour_and_24hour() -> Bool {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        let dateString: String = formatter.string(from: Date())
        let amRange: NSRange? = (dateString as NSString).range(of: formatter.amSymbol)
        let pmRange: NSRange? = (dateString as NSString).range(of: formatter.pmSymbol)
        let is24h: Bool = amRange?.location == NSNotFound && pmRange?.location == NSNotFound
        //print(is24h ? "YES" : "NO")
        return is24h
    }
    
    /// Description : This function is used for get inputed date into localDate time
    /// - Parameter date: date which need to be convert in local date time
    func localDateTime(date: Date) -> Date {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        //dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        dateFormatter.locale = Locale.current
        //dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let localDateString = dateFormatter.string(from: date)
//        print(localDateString)
        return dateFormatter.date(from: localDateString)!
    }
    
    
    /// Description : This function is used for convert string date to Date format
    /// - Parameter date: date as string
    func getDateFromString(date: String, dateFormat: String) -> Date? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        dateFormatter.dateFormat = dateFormat
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            dateFormatter.timeZone = aZone as TimeZone
        }
        let current_date = dateFormatter.date(from: date)
        return current_date
    }
    /// Description : This function used tp convert utc time string into local  time.
    /// - Parameter date: UTC time string.
    func UTCToLocal(date:String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "H:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

        let dt = dateFormatter.date(from: date)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "hh:mm:ss a"

        let localTimeString =  dateFormatter.string(from: dt!)
//        print(localTimeString)
        return  dateFormatter.date(from: localTimeString)!
    }
     /// Description : This function used tp convert utc time string into local  time.
        /// - Parameter date: UTC time string.
    func UTCToLocalDate(date:String, format: String) -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = format
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")

            let dt = dateFormatter.date(from: date)
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format

            let localTimeString =  dateFormatter.string(from: dt!)
    //        print(localTimeString)
            return  dateFormatter.date(from: localTimeString)!
        }
    
    /// Description : This function is used to get local date from utc string.
    /// - Parameters:
    ///   - date: date
    ///   - toDateFormat: toDateFormat
    ///   - fromDateFormat: fromDateFormat
    func getLocaDateFromUTCString(date: String, toDateFormat: String, fromDateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        dateFormatter.dateFormat = toDateFormat
        let current_date = dateFormatter.date(from: date)
        dateFormatter.locale = .current
        dateFormatter.dateFormat = fromDateFormat
        let localDateString = dateFormatter.string(from: current_date!)
//        print(localDateString)
        return dateFormatter.date(from: localDateString)
    }
    /// Description : this function is used to get seconds differant from gien date to today.
    /// - Parameters:
    ///   - date: date
    ///   - dateFormat: dateFormat
    func getDifferanceInSecondsFromCurrentDate(date: String, dateFormat: String)->Int{
        let localDate = self.UTCToLocalDate(date: date,  format: dateFormat)
        let currentDate = self.localDateTime(date: Date())
        let difference = Calendar.current.dateComponents([.second], from:localDate, to: currentDate)
        return abs(difference.second!)
    }
    
    /// Description : This function used to check given dates are similar or not.
    /// - Parameters:
    ///   - date1: date1
    ///   - date2: date2
    ///   - format: format
    func isSimilarDate(date1: Date , date2: Date, format: String) -> Bool{
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            formatter.timeZone = aZone as TimeZone
        }
        formatter.dateFormat = format
        let firstDate = formatter.string(from: date1)
        let secondDate = formatter.string(from: date2)
        
        formatter.locale = .autoupdatingCurrent
        formatter.dateFormat = "dd-MM-yyyy"
        
        let localDate1 = self.getLocalTimeFromUTCDateString(date: firstDate, fromDateFormat: format, toDateFormat: "dd-MM-yyyy")
        let localDate2 = self.getLocalTimeFromUTCDateString(date: secondDate, fromDateFormat: format, toDateFormat: "dd-MM-yyyy")
        
        //        if formatter.date(from: localDate1!)?.compare(formatter.date(from: localDate2!)!) == .orderedSame {
        //           return true
        //        }
        return false
    }
    
    /// Description : This function is used to get string from date.
    /// - Parameters:
    ///   - date: date
    ///   - dateFormat: dateFormat
    func getStringFromDate(date: Date, dateFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        dateFormatter.dateFormat = dateFormat
        //        let timeZone = NSTimeZone(name: "UTC")
        //        if let aZone = timeZone {
        //            dateFormatter.timeZone = aZone as TimeZone
        //        }
        dateFormatter.timeZone = .current
        let current_date = dateFormatter.string(from: date)
        return current_date
    }
    
    
    /// Description : This function is used to get UTC string form Date.
    /// - Parameters:
    ///   - date: date
    ///   - dateFormat: dateFormat
    func getUTCStringFromDate(date: Date, dateFormat: String) -> String? {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        dateFormatter.dateFormat = dateFormat
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            dateFormatter.timeZone = aZone as TimeZone
        }
        let current_date = dateFormatter.string(from: date)
        return current_date
    }
    
    /// Description: This function is used to get local  time string from utc string.
    /// - Parameters:
    ///   - date: date
    ///   - fromDateFormat: fromDateFormat
    ///   - toDateFormat: toDateFormat
    func getLocalTimeFromUTCDateString(date: String, fromDateFormat: String, toDateFormat: String) -> String? {
        
        guard date.count > 0 else {
            return "-"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        dateFormatter.dateFormat = fromDateFormat
        let timeZone = NSTimeZone(name: "UTC")
        if let aZone = timeZone {
            dateFormatter.timeZone = aZone as TimeZone
        }
        let current_date = dateFormatter.date(from: date)
        
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = toDateFormat
        
        return dateFormatter.string(from: current_date!)
    }
    
    /// Description: This function is used to get ride entry log header time.
    /// - Parameters:
    ///   - date: date
    ///   - fromDateFormat: fromDateFormat
    ///   - toDateFormat: toDateFormat
    ///   - isUTC: isUTC
    func getHeaderDateTime(date: String, fromDateFormat: String, toDateFormat: String, isUTC: Bool) -> String? {
        
        guard date.count > 0 else {
            return "-"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: "en_US_POSIX") as Locale
        
        dateFormatter.dateFormat = fromDateFormat
        if isUTC{
            let timeZone = NSTimeZone(name: "UTC")
            if let aZone = timeZone {
                dateFormatter.timeZone = aZone as TimeZone
            }
        }
        let current_date = dateFormatter.date(from: date)
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = toDateFormat
        
        return dateFormatter.string(from: current_date!)
    }
    /// Description: This function is used to get local date.
    /// - Parameters:
    ///   - dateString: dateString
    ///   - formate: formate
    func getLocalDate(from dateString: String, formate: String) -> Date? {
        let dateFormatter = DateFormatter()
//        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = formate
        return dateFormatter.date(from: dateString)
    }
    /// Description: This function is used to get formatted date string.
    /// - Parameter dateString: dateString
    func getFormattedDate(dateString: String)->String{
        if dateString.contains(".") {
            let splitDataArray = dateString.components(separatedBy: ".")
            return splitDataArray[0]
        }
        return dateString
    }
    /// Description: This function is used to get local date from utc string.
    /// - Parameters:
    ///   - date: date
    ///   - fromDateFormat: fromDateFormat
    ///   - toDateFormat: toDateFormat
    func getLocalDateFromUTCDateString(date: String, fromDateFormat: String, toDateFormat: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = fromDateFormat
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let utcDate = dateFormatter.date(from: date) ?? Date()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = toDateFormat
        let localDateString = dateFormatter.string(from: utcDate)
//        debugPrint("localDateString \(localDateString)")
        return dateFormatter.date(from: localDateString) ?? Date()
    }
    /// Description: This function is used to calculate elapsed time.
    /// - Parameters:
    ///   - stringDate: stringDate
    ///   - toStringDate: toStringDate
    func calculateElapsedTime(from stringDate:String, toStringDate:String = "") -> String {
        var dateFormate = ""
        var fromDateString = stringDate
        dateFormate = fromDateString.getCurrentDateFormate()
        let fromDate = self.getLocalDateFromUTCDateString(date: fromDateString, fromDateFormat: dateFormate, toDateFormat: DateFormatter.yyyyMMddHHmmss)
        var toDateString = toStringDate
        var toDate = Date()
        if !toStringDate.isEmpty {
            dateFormate = toDateString.getCurrentDateFormate()
            toDate = self.getLocalDateFromUTCDateString(date: toDateString, fromDateFormat: dateFormate, toDateFormat: DateFormatter.yyyyMMddHHmmss)
        }
        toDate = toStringDate.isEmpty ? Date() : toDate
        var calendar = Calendar.current
        calendar.timeZone = .current
        let elapsedTime = calendar.dateComponents([.hour, .minute, .second], from: fromDate, to: toStringDate.isEmpty ? Date() : toDate)
        let h = elapsedTime.hour ?? 0
        let m = elapsedTime.minute ?? 0
        let s = elapsedTime.second ?? 0
        let elapsedString = String.init(format: "(%dh %dm %ds)", h, m, s)
        return elapsedString
    }
}
// MARK: - END
