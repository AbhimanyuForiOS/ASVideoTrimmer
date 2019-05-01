//
//  VideoQualityConfig.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import AVFoundation

class VideoQualityConfig{
    
    var videoGravity:AVLayerVideoGravity
    var videoVolume:Float
    var height:CGFloat//give between only 0 to 1 , Ex:- 0.80 means 80% of parent view
    var width:CGFloat //give between only 0 to 1 , Ex:- 0.80 means 80% of parent view
    var currentVideoEndAction:AVPlayer.ActionAtItemEnd//when video will finish, what you want ? pause,repeat or play advance next
    init(videoGravity:AVLayerVideoGravity = .resizeAspect,
         videoVolume:Float = 3.0,
         width:CGFloat = 0.90,
         height:CGFloat = 0.90,
         currentVideoEndAction:AVPlayer.ActionAtItemEnd = .pause) {
        self.videoGravity    = videoGravity
        self.videoVolume     = videoVolume
        self.width     = width
        self.height       = height
        self.currentVideoEndAction = currentVideoEndAction
    }
}
