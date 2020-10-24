

import UIKit

struct THGTextInputStyle: AnimatedTextInputStyle {
    public let activeColor = UIColor.AppColor.placeHolder
    public var placeholderInactiveColor = UIColor.black
    public var lineInactiveColor = UIColor.AppColor.bottomLine
    public var lineActiveColor = UIColor.AppColor.bottomLine
    public var inactiveColor = UIColor.AppColor.placeHolder
    public let lineHeight: CGFloat = 1.0
    public let errorColor = UIColor.red
    public let textInputFont = UIFont.avenirLTProMediumFont(ofSize: 17)
    public var textInputFontColor = UIColor.black
    public let placeholderMinFontSize: CGFloat = 13
    public let counterLabelFont: UIFont? = UIFont.avenirLTProMediumFont(ofSize: 13)
    public var leftMargin: CGFloat = 0
    public var topMargin: CGFloat = 22
    public let rightMargin: CGFloat = 0
    public var bottomMargin: CGFloat = 2
    public let yHintPositionOffset: CGFloat = 5
    public let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String : Any]? = nil
    
    init() {
        
    }
    
    init(lineColor: UIColor, bottomMargin: CGFloat = 2) {
        self.lineInactiveColor = lineColor
        self.lineActiveColor = lineColor
        self.bottomMargin = bottomMargin
        self.topMargin = bottomMargin == 2 ? 22 : 26
    }
    
    init(leftMargin: CGFloat) {
        self.leftMargin = leftMargin
    }
    
    init(bottomMargin: CGFloat) {
        self.bottomMargin = bottomMargin
        self.topMargin = bottomMargin == 5 ? 26 : 22
    }
}
