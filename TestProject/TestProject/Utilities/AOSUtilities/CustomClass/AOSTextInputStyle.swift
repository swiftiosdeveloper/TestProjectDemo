//
//  THGTextInputStyle.swift
//  THGCEM
//
//  Created by Nirav Jariwala on 20/11/18.
//  Copyright © 2018 Nirav Jariwala. All rights reserved.
//

import UIKit

/// AOSTextInputStyle  : Structure for floating textfiled.
struct AOSTextInputStyle: AnimatedTextInputStyle {
    public var activeColor = UIColor.white
    public var placeholderInactiveColor = UIColor.gray
    public var lineInactiveColor = UIColor.clear
    public var lineActiveColor = UIColor.clear
    public var inactiveColor = UIColor.white
    public let lineHeight: CGFloat = 1.0
    public let errorColor = UIColor.red
    public let textInputFont = globalAppManager.isiPad() ? UIFont.FONT_IBMPlexSans_SemiBold(size : 20.0) : globalAppManager.segmentFont()
    public var textInputFontColor = UIColor.white
    public var placeholderMinFontSize: CGFloat = 10
    public var counterLabelFont: UIFont? = globalAppManager.isiPad() ? UIFont.FONT_IBMPlexSans_SemiBold(size : 20.0) : globalAppManager.segmentFont()
    public var leftMargin: CGFloat = 0
    public var topMargin: CGFloat = 10
    public let rightMargin: CGFloat = 0
    public var bottomMargin: CGFloat = 2
    public let yHintPositionOffset: CGFloat = 0
    public let yPlaceholderPositionOffset: CGFloat = 0
    public let textAttributes: [String : Any]? = nil
    
    init() {
        
    }
    
    init(lineColor: UIColor) {
        lineInactiveColor = lineColor
        lineActiveColor = lineColor
    }
    
    init(leftMargin: CGFloat) {
        self.leftMargin = leftMargin
    }
    
    init(bottomMargin: CGFloat) {
        self.bottomMargin = bottomMargin
    }
}
