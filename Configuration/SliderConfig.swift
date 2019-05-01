//
//  SliderConfig.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit

class SliderConfig{
    var sliderBaseLineColor:UIColor
    var croperLinesColor:UIColor
    var endStartPointsTextColor:UIColor
    var endStartPointsBgColor:UIColor
    var endStartPointsSize:CGFloat
    var endStartPointsTextFont:UIFont
    var croperAreaBorderColor:UIColor
    var croperAreaBorderWidth:CGFloat
    var croperAreaColor:UIColor
    var sliderBaseLineHeight:CGFloat
    var sliderHeight:CGFloat
    init(sliderBaseLineColor:UIColor = .gray,
         sliderBaseLineHeight:CGFloat = 0.02,
         sliderHeight:CGFloat = 0.10,
         croperLinesColor:UIColor = .white,
         croperAreaColor:UIColor = .clear,
         croperAreaBorderColor:UIColor = .white,
         croperAreaBorderWidth:CGFloat = 3.0,
         
         endStartPointsTextColor:UIColor = .white,
         endStartPointsTextFont:UIFont = UIFont.boldSystemFont(ofSize: 11.0),
         endStartPointsBgColor:UIColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.75),
         endStartPointsSize:CGFloat = 0.075) {
        self.sliderBaseLineColor    = sliderBaseLineColor
        self.sliderBaseLineHeight    = sliderBaseLineHeight
        self.sliderHeight            = sliderHeight
        self.croperLinesColor        = croperLinesColor
        self.croperAreaColor         = croperAreaColor
        self.croperAreaBorderColor   = croperAreaBorderColor
        self.croperAreaBorderWidth         = croperAreaBorderWidth
        self.endStartPointsTextColor   = endStartPointsTextColor
        self.endStartPointsTextFont    = endStartPointsTextFont
        self.endStartPointsBgColor      = endStartPointsBgColor
        self.endStartPointsSize        = endStartPointsSize
    }
}
