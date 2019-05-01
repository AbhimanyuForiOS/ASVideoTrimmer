//
//  VideoSliceGenerator.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 02/04/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class VideoSliceGenerator {
    
    var videoUrl:URL // use your own url
    lazy var frameList:[FrameModel] = [FrameModel]()
    private var generator:AVAssetImageGenerator!
    
    init(videoUrl:URL ) {
        self.videoUrl = videoUrl
    }
    
    
    func getAllFrames( _ response:((FrameModel?)->())){
        
        guard let duration = ASVideoTrimmerView.shared.config.orignalDuration  else { return }
        guard let _asset = ASVideoTrimmerView.shared.config.orignalAsset else { return }
        self.generator = AVAssetImageGenerator(asset:_asset)
        self.generator.appliesPreferredTrackTransform = true
        
        
        
        for index:Int in 0 ..< Int(duration) {
            response(self.getFrame(fromTime:Float64(index)))
        }
        self.generator = nil
        
    }
    
    private func getFrame(fromTime:Float64)->FrameModel? {
        let time:CMTime =  CMTimeMake(value: 5, timescale: 1)
        let image:CGImage
        do {
            try image = self.generator.copyCGImage(at:time, actualTime:nil)
        } catch {
            return nil
        }
        return  FrameModel.init(second: Int(fromTime), frame: UIImage(cgImage:image))
    }
    
}
