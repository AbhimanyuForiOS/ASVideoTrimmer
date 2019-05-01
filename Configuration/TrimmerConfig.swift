//
//  VideoTrimmerConfiguration.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation


class  TrimmerConfig {
   
    var orignalPath:String?
    var trimedPath:String
    var startPoint:Int?
    var endPoint:Int?
    var limit:Int?
    var orignalDuration:Int?
    var orignalAsset:AVAsset?
    var orignalUrl:URL?
    //video player related configuration
    var videoConfig:VideoQualityConfig
    
    var sliderConfig:SliderConfig
    
    
    //ui
    var backgroundColor:UIColor?
    var borderColorVideo:UIColor?
    var borderWidthVideo:CGFloat?
    var cancelButtonImage:UIImage?
    var cropButtonImage:UIImage?
    var cancelCropButtonsHightWidth:CGFloat?
    var playButtonImage:UIImage?
    
    init(orignalPath:String? = nil,trimedPath:String = "",startPoint:Int = 0,limit:Int? = 15,
         backgroundColor:UIColor? = .black,
         borderColorVideo:UIColor? = .white,
         borderWidthVideo:CGFloat? = 0.01,
         
         videoConfig:VideoQualityConfig = VideoQualityConfig(),
         cancelButtonImage:UIImage? = #imageLiteral(resourceName: "close"),
         cropButtonImage:UIImage? = #imageLiteral(resourceName: "ok") ,
         playButtonImage:UIImage? = #imageLiteral(resourceName: "play"),
         cancelCropButtonsHightWidth:CGFloat? = 0.15,
         orignalDuration:Int? = 0,
         orignalAsset:AVAsset? = nil,
         orignalUrl:URL?       = nil,
         sliderConfig:SliderConfig = SliderConfig()) {
        self.orignalPath    = orignalPath
        self.trimedPath     = trimedPath
        self.startPoint     = startPoint
        self.limit          = limit
        self.endPoint       = limit
        self.backgroundColor = backgroundColor
        self.videoConfig    = videoConfig
        self.cropButtonImage = cropButtonImage
        self.cancelButtonImage = cancelButtonImage
        self.cancelCropButtonsHightWidth = cancelCropButtonsHightWidth
        self.orignalDuration    = orignalDuration
        self.sliderConfig    = sliderConfig
        self.orignalAsset    = orignalAsset
        self.orignalUrl      = orignalUrl
        self.playButtonImage = playButtonImage
        self.borderColorVideo = borderColorVideo
        self.borderWidthVideo = borderWidthVideo
    }
}

