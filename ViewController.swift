//
//  ViewController.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 30/03/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVFoundation

class ViewController: UIViewController{
    
    @IBOutlet weak var videoResultView: UIView!
    var avPlayer: AVPlayer?
    var videoPlayerItem: AVPlayerItem? = nil {
        didSet {avPlayer?.replaceCurrentItem(with: self.videoPlayerItem)}
    }
    var avPlayerLayer: AVPlayerLayer?
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK:- UIButton Actions
    @IBAction func btnOpenVideoTrimmerTaped(_ sender: Any) {
        //set trimmer
        if let path = Bundle.main.path(forResource: "test", ofType:"m4v")  {
            ASVideoTrimmerView.shared.setTrimmerOn(controller: self, configuration:TrimmerConfig(orignalPath:   path))
            ASVideoTrimmerView.shared.delegate = self
        }
        if let player = avPlayer{
            player.pause()
        }
    }
    
    @IBAction func btnOpenGallaryTaped(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.savedPhotosAlbum) {
            let videoPicker = UIImagePickerController()
            videoPicker.delegate = self
            videoPicker.sourceType = .photoLibrary
            videoPicker.mediaTypes = [kUTTypeMovie as String]
            videoPicker.allowsEditing = true
            self.present(videoPicker, animated: true, completion: nil)
        }
        if let player = avPlayer{
            player.pause()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoResultView.layoutIfNeeded()
        avPlayerLayer?.frame = CGRect.init(x: 0,
                                           y:0,
                                           width:  videoResultView.frame.size.width,
                                           height: videoResultView.frame.size.height)
        
        
    }
    
    
    
}

extension ViewController:ASVideoTrimmerViewDelegate{
    //MARK:- ASVideoTrimmerViewDelegate
    func cancel(message: String) {
        print(message)
    }
    //Final result
    func croped(trimedVideoUrl: URL?) {
        if let url = trimedVideoUrl {
            DispatchQueue.main.async {
                self.avPlayer   = nil
                self.videoPlayerItem = nil
                self.avPlayerLayer?.removeFromSuperlayer()
                self.avPlayerLayer = nil
                
                self.videoPlayerItem = AVPlayerItem.init(url:url)
                self.avPlayer                       = AVPlayer.init(playerItem: self.videoPlayerItem)
                self.avPlayerLayer                  = AVPlayerLayer(player: self.avPlayer)
                self.avPlayerLayer?.videoGravity    = .resize
                self.avPlayer?.volume               = 3.0
                self.avPlayer?.actionAtItemEnd      = .pause
                self.videoResultView.layoutIfNeeded()
                self.avPlayerLayer?.frame = CGRect.init(x: 0,
                                                        y: 0,
                                                        width:  self.videoResultView.frame.size.width,
                                                        height: self.videoResultView.frame.size.height)
                self.avPlayerLayer?.backgroundColor = UIColor.clear.cgColor
                self.videoResultView.layer.insertSublayer(self.avPlayerLayer!, at: 0)
                self.avPlayer?.play()
            }
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    //MARK:- UiImagePicker Delegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        guard let mediaURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL else { return }
        ASVideoTrimmerView.shared.setTrimmerOn(controller: self, configuration:TrimmerConfig(orignalUrl: mediaURL))
        ASVideoTrimmerView.shared.delegate = self
    }
}
