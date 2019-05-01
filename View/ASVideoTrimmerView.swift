    //
    //  CropperView.swift
    //  ASVideoTrimmer
    //
    //  Created by Nidhi Singh Naruka on 30/03/19.
    //  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
    //
    
    import Foundation
    import UIKit
    import AVFoundation
    
    protocol  ASVideoTrimmerViewDelegate{
        func cancel(message:String)
        func croped(trimedVideoUrl:URL?)
    }
    
    class ASVideoTrimmerView :UIView{
        var  delegate:ASVideoTrimmerViewDelegate? = nil
        static let shared:ASVideoTrimmerView = ASVideoTrimmerView()
        var config:TrimmerConfig!
        
        var parentView:UIView!
        
        lazy var videoView:UIView = {
            let v  = UIView()
            v.translatesAutoresizingMaskIntoConstraints = false
            return v
        }()
        
        var avPlayer: AVPlayer?
        var videoPlayerItem: AVPlayerItem? = nil {
            didSet {
                avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)
            }
        }
        var avPlayerLayer: AVPlayerLayer?
        
        lazy var bottomActionView:ASBottomActionView = {
            let view = ASBottomActionView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor =  .clear
            return view
        }()
        
        
        lazy var slider:ASCropperSlider = {
            let slider = ASCropperSlider()
            slider.translatesAutoresizingMaskIntoConstraints = false
            slider.backgroundColor =  .clear
            return slider
        }()
        
        
        func startVideo(){
            
            self.avPlayer?.play() }
        func stopVideo() { self.avPlayer?.pause() }
        
        func  setTrimmerOn(controller :UIViewController,configuration:TrimmerConfig) {
            if  ASVideoTrimmerView.shared.config == nil {
                ASVideoTrimmerView.shared.config             = configuration
                
                if ASVideoTrimmerView.shared.config.orignalPath == nil &&  ASVideoTrimmerView.shared.config.orignalUrl == nil {
                    self.alert(message: "Please give a proper video URL or Video Path in configuration.")
                }
                
                if  ASVideoTrimmerView.shared.config.orignalPath != nil  {
                    
                    guard let path  =  ASVideoTrimmerView.shared.config.orignalPath else {
                        return
                    }
                    let url = URL(fileURLWithPath: path)
                    ASVideoTrimmerView.shared.config.orignalUrl = url
                    ASVideoTrimmerView.shared.config.orignalAsset = AVAsset(url: url)
                    if let asset = ASVideoTrimmerView.shared.config.orignalAsset {
                        ASVideoTrimmerView.shared.config.orignalDuration = Int( CMTimeGetSeconds(asset.duration))
                    }
                    
                }else if ASVideoTrimmerView.shared.config.orignalUrl != nil  {
                    guard let url  =  ASVideoTrimmerView.shared.config.orignalUrl else {
                        return
                    }
                    ASVideoTrimmerView.shared.config.orignalAsset = AVAsset(url: url)
                    if let asset = ASVideoTrimmerView.shared.config.orignalAsset {
                        ASVideoTrimmerView.shared.config.orignalDuration = Int( CMTimeGetSeconds(asset.duration))
                    }
                    
                }
                
                if configuration.limit! > configuration.orignalDuration!{
                    self.alert(message: "Video is Small  from the croping limit,Please Select Big Size Video.")
                    return
                }
                
                if configuration.limit! <= 0{
                    self.alert(message: "Please Set Croping  Limit More than 0 Seconds.")
                    return
                }
                
                ASVideoTrimmerView.shared.parentView = controller.view
                ASVideoTrimmerView.shared.backgroundColor    =  ASVideoTrimmerView.shared.config.backgroundColor
                ASVideoTrimmerView.shared.translatesAutoresizingMaskIntoConstraints = false
                //subviews
                addUI()
            }else{
                ASVideoTrimmerView.shared.parentView = controller.view
                self.addUI()
            }
        }
        
        
        func addUI(){
            
            ASVideoTrimmerView.shared.parentView.addSubview(ASVideoTrimmerView.shared)
            ASVideoTrimmerView.shared.addSubview(ASVideoTrimmerView.shared.videoView)
            
            guard let url  =  ASVideoTrimmerView.shared.config.orignalUrl else {print("url not able to init")
                return }
            
            if   ASVideoTrimmerView.shared.avPlayer !=  nil  {
                ASVideoTrimmerView.shared.avPlayer = nil
                ASVideoTrimmerView.shared.avPlayerLayer = nil
                ASVideoTrimmerView.shared.videoPlayerItem = nil
            }
            ASVideoTrimmerView.shared.videoPlayerItem = AVPlayerItem.init(url:url)
            
            
            
            ASVideoTrimmerView.shared.avPlayer                       = AVPlayer.init(playerItem: ASVideoTrimmerView.shared.videoPlayerItem)
            ASVideoTrimmerView.shared.avPlayerLayer                  = AVPlayerLayer(player: avPlayer)
            ASVideoTrimmerView.shared.avPlayerLayer?.videoGravity    = ASVideoTrimmerView.shared.config.videoConfig.videoGravity
            ASVideoTrimmerView.shared.avPlayer?.volume               = ASVideoTrimmerView.shared.config.videoConfig.videoVolume
            ASVideoTrimmerView.shared.avPlayer?.actionAtItemEnd      = ASVideoTrimmerView.shared.config.videoConfig.currentVideoEndAction
            ASVideoTrimmerView.shared.videoView.layoutIfNeeded()
            ASVideoTrimmerView.shared.avPlayerLayer?.frame = CGRect.init(x: 0,
                                                                         y: 0,
                                                                         width:  ASVideoTrimmerView.shared.videoView.frame.size.width,
                                                                         height: ASVideoTrimmerView.shared.videoView.frame.size.height)
            
            ASVideoTrimmerView.shared.avPlayerLayer?.backgroundColor = UIColor.clear.cgColor
            
            ASVideoTrimmerView.shared.videoView.layer.insertSublayer(  ASVideoTrimmerView.shared.avPlayerLayer!, at: 0)
            ASVideoTrimmerView.shared.videoView.layer.borderColor = UIColor.white.cgColor
            ASVideoTrimmerView.shared.videoView.layer.borderWidth =  ASVideoTrimmerView.shared.videoView.bounds.size.width*0.01
            ASVideoTrimmerView.shared.avPlayer?.play()
            ASVideoTrimmerView.shared.addSubview(ASVideoTrimmerView.shared.slider)
            ASVideoTrimmerView.shared.addSubview(ASVideoTrimmerView.shared.bottomActionView)
            
            removeAllConstraints()
            setConstraints()
        }
        
        func setConstraints(){
            
            ASVideoTrimmerView.shared.set(attribute: .bottom, relatedBy: .equal, toItem: parentView , attributeSecond: .bottom, multiplier: 1.0, constant: 0.0, viewMain: parentView)
            ASVideoTrimmerView.shared.set(attribute: .top, relatedBy: .equal, toItem: parentView , attributeSecond: .top, multiplier: 1.0, constant: 0.0, viewMain: parentView)
            ASVideoTrimmerView.shared.set(attribute: .height, relatedBy: .equal, toItem: parentView , attributeSecond: .height, multiplier: 1.0, constant: 0.0, viewMain: parentView)
            ASVideoTrimmerView.shared.set(attribute: .width, relatedBy: .equal, toItem: parentView , attributeSecond: .width, multiplier: 1.0, constant: 0.0, viewMain: parentView)
            ASVideoTrimmerView.shared.layoutIfNeeded()
            
            
            
            
            //Slider
            ASVideoTrimmerView.shared.slider.set(attribute: .width, relatedBy: .equal, toItem:ASVideoTrimmerView.shared.videoView, attributeSecond: .width, multiplier: 1.0, constant:0.0, viewMain:ASVideoTrimmerView.shared )
            
            let sliderHeight:CGFloat  = ASVideoTrimmerView.shared.config.sliderConfig.sliderHeight
            
            ASVideoTrimmerView.shared.slider.set(attribute: .height, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.width*sliderHeight, viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.slider.set(attribute: .top, relatedBy: .equal, toItem:ASVideoTrimmerView.shared, attributeSecond: .top, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*0.10 , viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.slider.set(attribute: .centerX, relatedBy: .equal, toItem:ASVideoTrimmerView.shared, attributeSecond: .centerX, multiplier: 1.0, constant: 0, viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.slider.addUI()
            
            ASVideoTrimmerView.shared.slider.layoutIfNeeded()
            
            //add movie view
            ASVideoTrimmerView.shared.videoView.backgroundColor =  ASVideoTrimmerView.shared.config.backgroundColor
            
            ASVideoTrimmerView.shared.videoView.set(attribute: .centerX, relatedBy: .equal, toItem:ASVideoTrimmerView.shared , attributeSecond: .centerX, multiplier: 1.0, constant: 0.0, viewMain: ASVideoTrimmerView.shared)
            ASVideoTrimmerView.shared.videoView.set(attribute: .top, relatedBy: .equal, toItem:ASVideoTrimmerView.shared.slider , attributeSecond: .bottom, multiplier: 1.0, constant:ASVideoTrimmerView.shared.slider.frame.size.height , viewMain: ASVideoTrimmerView.shared)
            ASVideoTrimmerView.shared.videoView.set(attribute: .width, relatedBy: .equal, toItem:ASVideoTrimmerView.shared , attributeSecond: .width, multiplier: ASVideoTrimmerView.shared.config.videoConfig.width, constant: 0.0, viewMain: ASVideoTrimmerView.shared)
            ASVideoTrimmerView.shared.videoView.set(attribute: .bottom, relatedBy: .equal, toItem:ASVideoTrimmerView.shared , attributeSecond: .bottom, multiplier:1.0, constant: -10, viewMain: ASVideoTrimmerView.shared)
            
            
            
            //bottom action view close/crop
            let widthHeight:CGFloat  = ASVideoTrimmerView.shared.config.cancelCropButtonsHightWidth!
            ASVideoTrimmerView.shared.bottomActionView.set(attribute: .width, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight*2.5 , viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.bottomActionView.set(attribute: .height, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight , viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.bottomActionView.set(attribute: .bottom, relatedBy: .equal, toItem:ASVideoTrimmerView.shared, attributeSecond: .bottom, multiplier: 0.95, constant:0, viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.bottomActionView.set(attribute: .centerX, relatedBy: .equal, toItem:ASVideoTrimmerView.shared, attributeSecond: .centerX, multiplier: 1.0, constant: 0, viewMain:ASVideoTrimmerView.shared )
            ASVideoTrimmerView.shared.bottomActionView.addUI()
            
        }
        
        
        
        
        func removeAllConstraints() {
            ASVideoTrimmerView.shared.removeConstraints(ASVideoTrimmerView.shared.constraints)
            for view in ASVideoTrimmerView.shared.subviews{
                view.removeConstraints(view.constraints)
            }
        }
        
        override func layoutSubviews() {
            super.layoutSubviews()
            
            ASVideoTrimmerView.shared.videoView.layoutIfNeeded()
            ASVideoTrimmerView.shared.avPlayerLayer?.frame = CGRect.init(x: 0,
                                                                         y:0,
                                                                         width:  ASVideoTrimmerView.shared.videoView.frame.size.width,
                                                                         height: ASVideoTrimmerView.shared.videoView.frame.size.height)
            
            ASVideoTrimmerView.shared.avPlayerLayer?.borderColor = ASVideoTrimmerView.shared.config.borderColorVideo!.cgColor
            ASVideoTrimmerView.shared.avPlayerLayer?.borderWidth =  ASVideoTrimmerView.shared.videoView.bounds.size.width*ASVideoTrimmerView.shared.config.borderWidthVideo!
            
        }
        
        func closeTrimmer(message:String =  "you canceled the video trimmer"){
            DispatchQueue.main.async {
                ASVideoTrimmerView.shared.removeFromSuperview()
                ASVideoTrimmerView.shared.stopVideo()
                self.removeAllConstraints()
                ASVideoTrimmerView.shared.avPlayerLayer?.removeFromSuperlayer()
                ASVideoTrimmerView.shared.videoView.removeFromSuperview()
                ASVideoTrimmerView.shared.bottomActionView.removeFromSuperview()
                ASVideoTrimmerView.shared.slider.lineCurrentPlayPoint.removeFromSuperview()
                ASVideoTrimmerView.shared.slider.removeFromSuperview()
                ASVideoTrimmerView.shared.config.startPoint = 0
                ASVideoTrimmerView.shared.config.endPoint = ASVideoTrimmerView.shared.config.limit!
                
                
                ASVideoTrimmerView.shared.removeFromSuperview()
                UIDevice.current.endGeneratingDeviceOrientationNotifications()
                
                
                
                if let _delegate = ASVideoTrimmerView.shared.delegate {
                    _delegate.cancel(message: message)
                }
            }
            
            
        }
        
        func alert(title:String = "Alert", message:String) -> Void {
            //make alert controller
            let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
            //add okay button
            alert.addAction(UIAlertAction.init(title: "Okay",style: .default,handler: { (action) in }))
            //present it on controller
            if  let vc = UIApplication.shared.keyWindow?.rootViewController{
                vc.present(alert, animated: true, completion: nil)
            }
        }
        
        deinit {
            UIDevice.current.endGeneratingDeviceOrientationNotifications()
        }
        
        
    }
    
