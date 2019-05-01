//
//  FrameCell.swift
//  ASVideoTrimmer
//
//  Created by Nidhi Singh Naruka on 02/04/19.
//  Copyright © 2019 Abhimanyu Singh Rathore. All rights reserved.
//

import Foundation

import UIKit



class FrameCell: UICollectionViewCell {
    
    lazy var imgVActivity:UIImageView = {
        let img = UIImageView()
        img.backgroundColor = .yellow
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(imgVActivity)
        imgVActivity.set(attribute: .leading, relatedBy: .equal, toItem: self.contentView, attributeSecond: .leading, multiplier: 1.0, constant: 0, viewMain: self.contentView)
        imgVActivity.set(attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attributeSecond: .trailing, multiplier: 1.0, constant: 0, viewMain: self.contentView)
        imgVActivity.set(attribute: .top, relatedBy: .equal, toItem: self.contentView, attributeSecond: .top, multiplier: 1.0, constant: 0, viewMain: self.contentView)
        imgVActivity.set(attribute: .bottom, relatedBy: .equal, toItem: self.contentView, attributeSecond: .bottom, multiplier: 1.0, constant: 0, viewMain: self.contentView)
    }
    func loadData(frameInfo:FrameModel?){
        if let _info = frameInfo{
            imgVActivity.image = _info.frame
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
