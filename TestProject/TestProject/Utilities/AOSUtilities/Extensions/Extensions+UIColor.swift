

import UIKit

extension UIColor{
    
    static let colorGreen = #colorLiteral(red: 0.137254902, green: 0.7254901961, blue: 0, alpha: 1)
    static let colorRed = #colorLiteral(red: 0.9176470588, green: 0.1176470588, blue: 0.1529411765, alpha: 1)
    static let colorWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let colorOffWhite = #colorLiteral(red: 0.9725490196, green: 0.9725490196, blue: 0.9725490196, alpha: 1)
    static let colorBlackLighTheme = #colorLiteral(red: 0.1725490196, green: 0.1725490196, blue: 0.1921568627, alpha: 1)
    static let colorCellEdit = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
    static let colorCellDelete = #colorLiteral(red: 0.2235294118, green: 0.2235294118, blue: 0.2431372549, alpha: 1)
    static let colorLightGray = #colorLiteral(red: 0.5176470588, green: 0.5176470588, blue: 0.5176470588, alpha: 1)
    static let colorOffLightGray = #colorLiteral(red: 0.8509803922, green: 0.8509803922, blue: 0.8509803922, alpha: 1)
    static let placeHolder = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let bottomLine = #colorLiteral(red: 0.8470588235, green: 0.8470588235, blue: 0.8470588235, alpha: 1)
    static let colorCellBG = #colorLiteral(red: 0.3803921569, green: 0.4156862745, blue: 0.4470588235, alpha: 1)
    static let colorRedButton = #colorLiteral(red: 0.6745098039, green: 0.1137254902, blue: 0.137254902, alpha: 1)
    static let colorLightCellBG = #colorLiteral(red: 0.8078431373, green: 0.8431372549, blue: 0.8745098039, alpha: 1)
    static let colorLightGrayBG = #colorLiteral(red: 0.9450980392, green: 0.9450980392, blue: 0.9450980392, alpha: 1)


    convenience init?(hexString: String) {
           var chars = Array(hexString.hasPrefix("#") ? hexString.dropFirst() : hexString[...])
           let red, green, blue, alpha: CGFloat
           switch chars.count {
           case 3:
               chars = chars.flatMap { [$0, $0] }
               fallthrough
           case 6:
               chars = ["F","F"] + chars
               fallthrough
           case 8:
               alpha = CGFloat(strtoul(String(chars[0...1]), nil, 16)) / 255
               red   = CGFloat(strtoul(String(chars[2...3]), nil, 16)) / 255
               green = CGFloat(strtoul(String(chars[4...5]), nil, 16)) / 255
               blue  = CGFloat(strtoul(String(chars[6...7]), nil, 16)) / 255
           default:
               return nil
           }
           self.init(red: red, green: green, blue:  blue, alpha: alpha)
       }
}
