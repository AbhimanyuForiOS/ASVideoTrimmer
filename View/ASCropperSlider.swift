//
//  ASCropperSlider.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit
import CoreMedia

import AVFoundation
import AVKit


class ASCropperSlider:UIView,UICollectionViewDelegate,UICollectionViewDataSource{
    
    @objc func oriantationNotify(notification : NSNotification) {
        resetAll()
    }
    
    
    lazy var pan:UIPanGestureRecognizer = {
        let pan:UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(panHandler(pan:)))
        return pan
    }()
    lazy var xPercentageLocationSelectedArea:CGFloat = 0.0
    
    var seconds:Int = 0 {
        didSet(value){
            self.lblStartSeconds.text =  String( value)
        }
    }
    
    var progress:Double = 0.0
    
    
    lazy var imageGenerator:VideoSliceGenerator  = {
        let generator = VideoSliceGenerator.init(videoUrl: ASVideoTrimmerView.shared.config.orignalUrl!)
        return generator
    }()
    
    lazy var buttonPlay:UIButton  = {
        let btn = UIButton(type: .custom)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = UIColor.init(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.65)
        btn.addTarget(self, action: #selector(btnPlayTaped(btn:)), for: .touchUpInside)
        btn.setImage(ASVideoTrimmerView.shared.config.playButtonImage, for: .normal)
        return btn
        
    }()
    
    lazy var framesList:[FrameModel] = [FrameModel]()
    
    var xAxisSelector:NSLayoutConstraint!
    lazy var lineCurrentPlayPoint:UIImageView = {
        let line = UIImageView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.isUserInteractionEnabled = true
        line.backgroundColor =  ASVideoTrimmerView.shared.config.sliderConfig.croperLinesColor
        return line
    }()
    
    
    lazy var lblStartLine:UIImageView = {
        let line = UIImageView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.isUserInteractionEnabled = true
        line.backgroundColor =  ASVideoTrimmerView.shared.config.sliderConfig.croperLinesColor
        return line
    }()
    
    lazy var lblStartSeconds:UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.text          = String((ASVideoTrimmerView.shared.config.startPoint ?? 0))
        lbl.font    = ASVideoTrimmerView.shared.config.sliderConfig.endStartPointsTextFont
        lbl.textColor = ASVideoTrimmerView.shared.config.sliderConfig.endStartPointsTextColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor =  .black
        lbl.text = String(self.seconds)
        return lbl
    }()
    
    
    
    
    
    lazy var lblEndLine:UIImageView = {
        let line = UIImageView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.isUserInteractionEnabled = true
        line.backgroundColor =  ASVideoTrimmerView.shared.config.sliderConfig.croperLinesColor
        return line
    }()
    
    
    lazy var lblEndSeconds:UILabel = {
        let lbl = UILabel()
        lbl.adjustsFontSizeToFitWidth = true
        lbl.minimumScaleFactor = 0.5
        lbl.textAlignment = .center
        lbl.clipsToBounds = true
        lbl.text          = String((ASVideoTrimmerView.shared.config.startPoint ?? 0))
        lbl.font    = ASVideoTrimmerView.shared.config.sliderConfig.endStartPointsTextFont
        lbl.textColor = ASVideoTrimmerView.shared.config.sliderConfig.endStartPointsTextColor
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor =  .black
        lbl.text = String(self.seconds+ASVideoTrimmerView.shared.config.limit!)
        return lbl
    }()
    
    
    
    
    lazy var selectedBoxView:UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isUserInteractionEnabled = true
        view.layer.borderColor        = ASVideoTrimmerView.shared.config.sliderConfig.croperAreaBorderColor.cgColor
        view.layer.borderWidth        = ASVideoTrimmerView.shared.config.sliderConfig.croperAreaBorderWidth
        view.backgroundColor          = ASVideoTrimmerView.shared.config.sliderConfig.croperAreaColor
        return view
    }()
    
    var collectionView:UICollectionView!
    
    @objc func btnPlayTaped(btn:UIButton){
        // let startTime = CMTime(seconds: Double(ASVideoTrimmerView.shared.config.startPoint!), preferredTimescale: 1)
        let endTime = CMTime(seconds: Double(ASVideoTrimmerView.shared.config.endPoint!), preferredTimescale: 1)
        
        let playerTimescale = ASVideoTrimmerView.shared.avPlayer?.currentItem?.asset.duration.timescale ?? 1
        let time =  CMTime(seconds: Double(ASVideoTrimmerView.shared.config.startPoint!), preferredTimescale: playerTimescale)
        ASVideoTrimmerView.shared.avPlayer?.seek(to: time, toleranceBefore: .zero, toleranceAfter: CMTime.zero) { (started) in }
        ASVideoTrimmerView.shared.videoPlayerItem?.forwardPlaybackEndTime = endTime
        ASVideoTrimmerView.shared.avPlayer?.play()
        
        
    }
    
    @objc func panHandler(pan:UIPanGestureRecognizer){
        self.collectionView.layoutIfNeeded()
        self.selectedBoxView.layoutIfNeeded()
        let centerOfSelector =  self.selectedBoxView.frame.size.width/2
        if pan.location(in: self.collectionView).x >= centerOfSelector && pan.location(in: self.collectionView).x <= (self.collectionView.frame.size.width-centerOfSelector){
            UIView.animate(withDuration: 0.3, animations: {
                self.xPercentageLocationSelectedArea = pan.location(in: self.collectionView).x/self.collectionView.bounds.size.width
                //place selectd area in given pan gesture
                self.selectedBoxView.center =   CGPoint(x: pan.location(in: self.collectionView).x, y:  self.selectedBoxView.center.y)
                
                //puase video first of all
                self.pouseVideo()
                
                //Calculate New  start point in seconds
                let x:CGFloat =   self.selectedBoxView.center.x -  self.selectedBoxView.bounds.size.width/2
                self.setTimeOnTimeLbl(seconds: Double(ASVideoTrimmerView.shared.config.orignalDuration!)*Double(x/self.bounds.size.width))
                
                
                //set up remaining properties with respect to new start point and update UI as well
                ASVideoTrimmerView.shared.config.startPoint = self.seconds
                ASVideoTrimmerView.shared.config.endPoint   = self.seconds+ASVideoTrimmerView.shared.config.limit!
                self.lblStartSeconds.text =  String( self.seconds)
                self.lblEndSeconds.text   = String( ASVideoTrimmerView.shared.config.endPoint!)
                self.buttonPlay.isHidden = false
                self.selectedBoxView.layoutIfNeeded()
                self.collectionView.layoutIfNeeded()
                self.lineCurrentPlayPoint.layoutIfNeeded()
                
            })
        }
    }
    
    func addUI(){
        
        //collection view below story if exist
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame:.zero, collectionViewLayout: flowLayout)
        
        // Create an instance of UICollectionViewFlowLayout since you cant
        let sliderHeight:CGFloat  = ASVideoTrimmerView.shared.config.sliderConfig.sliderHeight
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width:ASVideoTrimmerView.shared.frame.width*sliderHeight, height: ASVideoTrimmerView.shared.frame.width*sliderHeight)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        if collectionView != nil{
            collectionView.removeFromSuperview()
            collectionView = nil
        }
        
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //add the observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(oriantationNotify(notification:)),
            name: UIDevice.orientationDidChangeNotification,
            object: nil)
        
        collectionView = UICollectionView(frame:CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.bounces = false
        collectionView.clipsToBounds = true
        collectionView.register(FrameCell.self, forCellWithReuseIdentifier: "cell")
        collectionView.showsVerticalScrollIndicator = false
        collectionView.backgroundColor = UIColor.red
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(collectionView)
        
        selectedBoxView.addSubview(lineCurrentPlayPoint)
        selectedBoxView.addSubview(lblStartLine)
        selectedBoxView.addSubview(lblEndLine)
        
        lblStartLine.addSubview(lblStartSeconds)
        lblEndLine.addSubview(lblEndSeconds)
        
        self.addSubview(selectedBoxView)
        
        ASVideoTrimmerView.shared.videoView.addSubview(buttonPlay)
        
        
        
        
        removeAllConstraints()
        setConstraints()
        
        imageGenerator.getAllFrames { (model) in
            if let _model = model {
                self.framesList.append(_model)
                self.collectionView.reloadData()
            }
        }
        //self.collectionView.addGestureRecognizer(pan)
        self.selectedBoxView.addGestureRecognizer(pan)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.framesList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FrameCell
        let data =  framesList[indexPath.row]
        cell.loadData(frameInfo: data)
        return cell
    }
    
    func returnWidthOfSelectedArea()->CGFloat{
        return CGFloat(ASVideoTrimmerView.shared.config.limit!)/CGFloat(ASVideoTrimmerView.shared.config.orignalDuration!)
    }
    func setConstraints()
    {
        collectionView.set(attribute: .leading, relatedBy: .equal, toItem: self, attributeSecond: .leading, multiplier: 1.0, constant: 0, viewMain: self)
        collectionView.set(attribute: .top , relatedBy: .equal, toItem: self, attributeSecond: .top, multiplier: 1.0, constant: 0, viewMain: self)
        collectionView.set(attribute: .bottom, relatedBy: .equal, toItem: self, attributeSecond: .bottom, multiplier: 1.0, constant: 0 , viewMain: self)
        collectionView.set(attribute: .trailing, relatedBy: .equal, toItem: self, attributeSecond: .trailing, multiplier: 1.0, constant: 0, viewMain: self)
        
        selectedBoxView.set(attribute: .leading, relatedBy: .equal, toItem: collectionView, attributeSecond: .leading, multiplier: 1.0, constant: 0.0, viewMain: self)
        selectedBoxView.set(attribute: .centerY, relatedBy: .equal, toItem: collectionView, attributeSecond: .centerY, multiplier: 1.0, constant: 0.0, viewMain: self)
        selectedBoxView.set(attribute: .width, relatedBy: .equal, toItem: collectionView, attributeSecond: .width, multiplier: returnWidthOfSelectedArea(), constant: 0.0, viewMain: self)
        selectedBoxView.set(attribute: .height, relatedBy: .equal, toItem: collectionView, attributeSecond: .height, multiplier: 1.0, constant: 0.0, viewMain: self)
        
        self.layoutIfNeeded()
        
        lineCurrentPlayPoint.set(attribute: .height, relatedBy: .equal, toItem:selectedBoxView , attributeSecond: .height, multiplier: 1.0, constant: 0.0, viewMain: selectedBoxView)
        lineCurrentPlayPoint.set(attribute: .width, relatedBy: .equal, toItem:nil , attributeSecond: .notAnAttribute, multiplier: 1.0, constant: ASVideoTrimmerView.shared.config.sliderConfig.croperAreaBorderWidth, viewMain: selectedBoxView)
        xAxisSelector =   lineCurrentPlayPoint.get(attribute: .leading, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .leading, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        lineCurrentPlayPoint.set(attribute: .centerY, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .centerY, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        self.selectedBoxView.layoutIfNeeded()
        
        
        lblStartLine.set(attribute: .height, relatedBy: .equal, toItem:selectedBoxView , attributeSecond: .height, multiplier: 1.0, constant: 0.0, viewMain: selectedBoxView)
        lblStartLine.set(attribute: .width, relatedBy: .equal, toItem:nil , attributeSecond: .notAnAttribute, multiplier: 1.0, constant: ASVideoTrimmerView.shared.config.sliderConfig.croperAreaBorderWidth, viewMain: selectedBoxView)
        lblStartLine.set(attribute: .leading, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .leading, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        lblStartLine.set(attribute: .centerY, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .centerY, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        
        lblStartSeconds.set(attribute: .height, relatedBy: .equal, toItem: nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant: screenWidth*0.05, viewMain: lblStartLine)
        lblStartSeconds.set(attribute: .width, relatedBy: .equal, toItem: nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant: screenWidth*0.05, viewMain: lblStartLine)
        lblStartSeconds.set(attribute: .centerX, relatedBy: .equal, toItem: lblStartLine, attributeSecond: .centerX, multiplier: 1.0, constant: 0.0, viewMain: lblStartLine)
        lblStartSeconds.set(attribute: .top, relatedBy: .equal, toItem: lblStartLine, attributeSecond: .bottom, multiplier: 1.0, constant: 0, viewMain: lblStartLine)
        self.layoutIfNeeded()
        lblStartSeconds.layer.cornerRadius = screenWidth*0.05/2
        
        
        
        
        lblEndLine.set(attribute: .height, relatedBy: .equal, toItem:selectedBoxView , attributeSecond: .height, multiplier: 1.0, constant: 0.0, viewMain: selectedBoxView)
        lblEndLine.set(attribute: .width, relatedBy: .equal, toItem:nil , attributeSecond: .notAnAttribute, multiplier: 1.0, constant: ASVideoTrimmerView.shared.config.sliderConfig.croperAreaBorderWidth, viewMain: selectedBoxView)
        lblEndLine.set(attribute: .trailing, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .trailing, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        lblEndLine.set(attribute: .centerY, relatedBy: .equal, toItem:selectedBoxView, attributeSecond: .centerY, multiplier: 1.0, constant:0.0, viewMain:selectedBoxView )
        
        lblEndSeconds.set(attribute: .height, relatedBy: .equal, toItem: nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant: screenWidth*0.05, viewMain: lblEndLine)
        lblEndSeconds.set(attribute: .width, relatedBy: .equal, toItem: nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant: screenWidth*0.05, viewMain: lblEndLine)
        lblEndSeconds.set(attribute: .centerX, relatedBy: .equal, toItem: lblEndLine, attributeSecond: .centerX, multiplier: 1.0, constant: 0.0, viewMain: lblEndLine)
        lblEndSeconds.set(attribute: .top, relatedBy: .equal, toItem: lblEndLine, attributeSecond: .bottom, multiplier: 1.0, constant: 0, viewMain: lblEndLine)
        self.layoutIfNeeded()
        lblEndSeconds.layer.cornerRadius = screenWidth*0.05/2
        buttonPlay.isHidden = false
        
        buttonPlay.set(attribute: .leading, relatedBy: .equal, toItem: ASVideoTrimmerView.shared.videoView, attributeSecond: .leading, multiplier: 1.0, constant: 0.0, viewMain:ASVideoTrimmerView.shared.videoView )
        buttonPlay.set(attribute: .trailing, relatedBy: .equal, toItem: ASVideoTrimmerView.shared.videoView, attributeSecond: .trailing, multiplier: 1.0, constant: 0.0, viewMain:ASVideoTrimmerView.shared.videoView )
        buttonPlay.set(attribute: .top, relatedBy: .equal, toItem: ASVideoTrimmerView.shared.videoView, attributeSecond: .top, multiplier: 1.0, constant: 0.0, viewMain:ASVideoTrimmerView.shared.videoView )
        buttonPlay.set(attribute: .bottom, relatedBy: .equal, toItem: ASVideoTrimmerView.shared.videoView, attributeSecond: .bottom, multiplier: 1.0, constant: 0.0, viewMain:ASVideoTrimmerView.shared.videoView )
        
        self.playerObserver()
        
    }
    
    func playerObserver(){
        if let player = ASVideoTrimmerView.shared.avPlayer{
            ASVideoTrimmerView.shared.avPlayer!.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 8), queue: DispatchQueue.main) {(progressTime) in
                if    ASVideoTrimmerView.shared.avPlayer!.timeControlStatus == .playing {
                    if let duration = player.currentItem?.duration {
                        self.buttonPlay.isHidden = true
                        let seconds = CMTimeGetSeconds(progressTime)
                        
                        
                        UIView.animate(withDuration: 0.5, animations: {
                            self.setTimeOnTimeLbl(seconds: ceil(seconds) )
                            if  Int(self.seconds) ==  ASVideoTrimmerView.shared.config.endPoint!{
                                self.pouseVideo()
                                
                            }else{
                                let percentage = CGFloat(CGFloat(self.progress)/CGFloat(ASVideoTrimmerView.shared.config.limit!))
                                self.xAxisSelector.constant = self.selectedBoxView.bounds.size.width*percentage
                                ASVideoTrimmerView.shared.config.startPoint  =  Int(ceil(progressTime.seconds))
                                
                                self.progress =  (progressTime.seconds - Double(ASVideoTrimmerView.shared.config.endPoint!-ASVideoTrimmerView.shared.config.limit!))
                                
                            }
                            self.selectedBoxView.layoutIfNeeded()
                        })
                } 
                }
            }
        }
    }
    
    func pouseVideo(){
        ASVideoTrimmerView.shared.avPlayer?.pause()
        ASVideoTrimmerView.shared.config.startPoint = ASVideoTrimmerView.shared.config.startPoint!-ASVideoTrimmerView.shared.config.limit!
        self.buttonPlay.isHidden = false
        self.xAxisSelector.constant =  0.0
        self.lblStartSeconds.text = String( ASVideoTrimmerView.shared.config.startPoint!)
        self.progress = 0.0
    }
    
    func resetAll(){
        
        ASVideoTrimmerView.shared.avPlayer?.pause()
        ASVideoTrimmerView.shared.config.startPoint = 0
        ASVideoTrimmerView.shared.config.endPoint = ASVideoTrimmerView.shared.config.limit!
        self.buttonPlay.isHidden = false
        if self.xAxisSelector !=  nil{
            self.xAxisSelector.constant =  0.0
            self.lblStartSeconds.text = String( ASVideoTrimmerView.shared.config.startPoint!)
            self.lblEndSeconds.text = String( ASVideoTrimmerView.shared.config.endPoint!)
        }
        self.progress = 0.0
    }
    
    
    func setTimeOnTimeLbl(seconds: Double){
        let secs = Int(seconds)
//        let hours = secs / 3600
//        let minutes = (secs % 3600) / 60
        self.seconds = (secs % 3600) % 60
        ASVideoTrimmerView.shared.config.startPoint = Int(self.seconds)
    }
    
    
    func removeAllConstraints() {
        if xAxisSelector != nil{
            lineCurrentPlayPoint.removeConstraint(xAxisSelector)
        }
        for view in ASVideoTrimmerView.shared.videoView.subviews{
            view.removeConstraints(view.constraints)
        }
    }
    
    
    
    
}
