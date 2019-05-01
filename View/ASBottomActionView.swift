//
//  ASBottomActionViewswift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Photos
class ASBottomActionView:UIView{
    
    //UI elemenets
    lazy var btnCancel:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor =  .clear
        btn.showsTouchWhenHighlighted = true
        btn.setImage(ASVideoTrimmerView.shared.config.cancelButtonImage, for: .normal)
        btn.addTarget(self, action: #selector(btnCancelTaped), for: .touchUpInside)
        return btn
    }()
    
    lazy var btnCrop:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor =  .clear
        btn.showsTouchWhenHighlighted = true
        btn.setImage(ASVideoTrimmerView.shared.config.cropButtonImage, for: .normal)
        btn.addTarget(self, action: #selector(btnCropTaped), for: .touchUpInside)
        return btn
    }()
    
    
    func addUI(){
        //btn cancel & crop
        self.addSubview(btnCrop)
        self.addSubview(btnCancel)
        //constraints
        removeConstraints()
        setConstraints()
        
    }
    
    
    func setConstraints()
    {
        let widthHeight:CGFloat  = ASVideoTrimmerView.shared.config.cancelCropButtonsHightWidth!
        btnCancel.set(attribute: .width, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight , viewMain:self )
        btnCancel.set(attribute: .height, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight , viewMain:self )
        btnCancel.set(attribute: .leading, relatedBy: .equal, toItem:self, attributeSecond: .leading, multiplier: 1.0, constant: 0, viewMain:self )
        btnCancel.set(attribute: .centerY, relatedBy: .equal, toItem:self, attributeSecond: .centerY, multiplier: 1.0, constant: 0, viewMain:self )
        
        btnCrop.set(attribute: .width, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight , viewMain:self )
        btnCrop.set(attribute: .height, relatedBy: .equal, toItem:nil, attributeSecond: .notAnAttribute, multiplier: 1.0, constant:ASVideoTrimmerView.shared.frame.size.width*widthHeight , viewMain:self )
        btnCrop.set(attribute: .trailing, relatedBy: .equal, toItem:self, attributeSecond: .trailing, multiplier: 1.0, constant:0, viewMain:self )
        btnCrop.set(attribute: .centerY, relatedBy: .equal, toItem:self, attributeSecond: .centerY, multiplier: 1.0, constant: 0, viewMain:self )
        
    }
    
    func removeConstraints() {
        func removeAllConstraints() {
            for view in ASVideoTrimmerView.shared.videoView.subviews{
                view.removeConstraints(view.constraints)
            }
        }
    }
    
    @objc func btnCancelTaped(){
        ASVideoTrimmerView.shared.closeTrimmer()
    }
    
    @objc func btnCropTaped(){
        self.alert(message: "Are you sure?")
    }
    
    
    func alert(title:String = "Alert", message:String) -> Void {
        //make alert controller
        let alert = UIAlertController(title: title,message: message,preferredStyle: UIAlertController.Style.alert)
        //add okay button
        alert.addAction(UIAlertAction.init(title: "Okay",style: .default,handler: { (action) in
            self.crop()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel",style: .destructive ,handler: { (action) in }))
        //present it on controller
        if  let vc = UIApplication.shared.keyWindow?.rootViewController{
            vc.present(alert, animated: true, completion: nil)
        }
    }
    
    func crop(){
        var outputURL = URL(fileURLWithPath:NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!)
        let fileManager = FileManager.default
        do {
            try fileManager.createDirectory(at: outputURL, withIntermediateDirectories: true, attributes: nil)
        } catch {}
        outputURL.appendPathComponent("output.mp4")
        
        // Remove existing file
        do {
            try fileManager.removeItem(at: outputURL)
        }
        catch{}
        let start = CMTimeMakeWithSeconds(Float64(ASVideoTrimmerView.shared.config.startPoint!), preferredTimescale: 600)
        let duration = CMTimeMakeWithSeconds(Float64(ASVideoTrimmerView.shared.config.endPoint!), preferredTimescale: 600)
        
        let videoTrimer = VideoTrimmer()
        
        videoTrimer.trimVideo(sourceURL: ASVideoTrimmerView.shared.config.orignalUrl!, destinationURL: outputURL, trimPoints: [(start,duration)]) { (error) in
            if error != nil{
                if let _delegate = ASVideoTrimmerView.shared.delegate {
                    _delegate.cancel(message: "Sorry, video not trimmed due to some reason. Please retry with another file or same.")
                }
                
            }else{
                if let _delegate = ASVideoTrimmerView.shared.delegate {
                    _delegate.croped(trimedVideoUrl: outputURL)
                    // self.saveCropedVideoToUsersPhotoGallery(url: outputURL)
                    //close trimmer
                    ASVideoTrimmerView.shared.closeTrimmer(message: "Succesfully croped")
                    
                }
            }
        }
        
        
    }
    
    func saveCropedVideoToUsersPhotoGallery(url:URL){
        PHPhotoLibrary.shared().performChanges({
            PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: url)
        }) { saved, error in
            if saved {
                self.alert(message: "Your video was successfully saved")
                
            }
        }
    }
}
