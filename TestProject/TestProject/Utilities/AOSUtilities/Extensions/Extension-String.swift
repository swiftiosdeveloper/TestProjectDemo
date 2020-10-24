

import Foundation

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    //Validate Email
    var isEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.count)) != nil
        } catch {
            return false
        }
    }
    var trimmed:String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    var isNumber: Bool {
        let phoneRegex = "^[0-9]";
        return NSPredicate(format: "SELF MATCHES %@", phoneRegex).evaluate(with: self)
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
    mutating func insert(string:String,ind:Int) {
        self.insert(contentsOf: string, at:self.index(self.startIndex, offsetBy: ind) )
    }
    mutating func getCurrentDateFormate() -> String {
        if self.contains("z") || self.contains("Z"){
            let arr = self.components(separatedBy: ".")
            self = arr.first ?? ""
            return DateFormatter.yyyyMMddTHHmmss
        }else if self.lowercased().contains("am") ||  self.lowercased().contains("pm"){
           return DateFormatter.yyyyMMddTHHmmssa
        }
        else{
            return self.contains(".") ? DateFormatter.yyyyMMddTHHmmssSSS : DateFormatter.yyyyMMddTHHmmss
        }
    }
    
}
